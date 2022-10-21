#include "sdk/src/rp2040/hardware_structs/include/hardware/structs/ssi.h"
#include "sdk/src/rp2040/hardware_structs/include/hardware/structs/pads_qspi.h"
#include "sdk/src/rp2040/hardware_regs/include/hardware/regs/addressmap.h"
#include "sdk/src/rp2040/hardware_regs/include/hardware/regs/m0plus.h"

// "Mode bits" are 8 special bits sent immediately after
// the address bits in a "Read Data Fast Quad I/O" command sequence.
// On W25Q080, the four LSBs are don't care, and if MSBs == 0xa, the
// next read does not require the 0xeb instruction prefix.
#define MODE_CONTINUOUS_READ 0xa0

// Define interface width: single/dual/quad IO

#define FRAME_FORMAT SSI_CTRLR0_SPI_FRF_VALUE_STD
#define TRANSACTION_TYPE SSI_SPI_CTRLR0_TRANS_TYPE_VALUE_1C1A
#define INSTRUCTION_LENGTH SSI_SPI_CTRLR0_INST_L_VALUE_8B
#define READ_INSTRUCTION (0x03)
#define ADDR_L 6 // * 4 = 24


#define CMD_READ_STATUS1 0x05
#define CMD_READ_STATUS2 0x35
#define CMD_WRITE_ENABLE 0x06
#define CMD_WRITE_STATUS1 0x01
#define CMD_WRITE_STATUS2 0x31

#define SREG_DATA 0x02

static uint32_t wait_and_read(uint8_t);
static uint8_t read_flash_sreg(uint8_t status_command);

// This function is use by the bootloader to enable the XIP flash. It is also
// used by the SDK to reinit XIP after doing non-read flash interactions such as
// writing or erasing. This code must compile down to position independent
// assembly because we don't know where in RAM it'll be when run.

// This must be the first defined function so that it is placed at the start of
// memory where the bootloader jumps to!
extern void _stage2_boot(void);
void __attribute__((section(".entry._stage2_boot"), used)) _stage2_boot(void) {
    uint32_t lr;
    asm ("MOV %0, LR\n" : "=r" (lr) );

    // Set aggressive pad configuration for QSPI
    // - SCLK 8mA drive, no slew limiting
    // - SDx disable input Schmitt to reduce delay

    // SCLK
    pads_qspi_hw->io[0] = PADS_QSPI_GPIO_QSPI_SCLK_DRIVE_VALUE_8MA << PADS_QSPI_GPIO_QSPI_SCLK_DRIVE_LSB |
                          PADS_QSPI_GPIO_QSPI_SCLK_SLEWFAST_BITS;

    // Data lines
    uint32_t data_settings = pads_qspi_hw->io[1];
    data_settings &= ~PADS_QSPI_GPIO_QSPI_SCLK_SCHMITT_BITS;
    pads_qspi_hw->io[2] = data_settings;
    

    // Disable the SSI so we can change the settings.
    ssi_hw->ssienr = 0;

    // QSPI config
    ssi_hw->baudr = 4; // 125 mhz / clock divider

    // Set 1-cycle sample delay. If PICO_FLASH_SPI_CLKDIV == 2 then this means,
    // if the flash launches data on SCLK posedge, we capture it at the time that
    // the next SCLK posedge is launched. This is shortly before that posedge
    // arrives at the flash, so data hold time should be ok. For
    // PICO_FLASH_SPI_CLKDIV > 2 this pretty much has no effect.
    ssi_hw->rx_sample_dly = 1;

    // Set a temporary mode for doing simple commands.
    ssi_hw->ctrlr0 = (7 << SSI_CTRLR0_DFS_32_LSB) | // 8 bits per data frame
                     (SSI_CTRLR0_TMOD_VALUE_TX_AND_RX << SSI_CTRLR0_TMOD_LSB);

    ssi_hw->ssienr = 0x1;

    

    // Disable SSI again so that it can be reconfigured
    ssi_hw->ssienr = 0;

    // Do a single read to get us in continuous mode.

    // Final SSI ctrlr0 settings. We only change the SPI specific settings later.
    ssi_hw->ctrlr0 = (FRAME_FORMAT << SSI_CTRLR0_SPI_FRF_LSB) | // Quad I/O mode
                     (31 << SSI_CTRLR0_DFS_32_LSB)  |       // 32 data bits
                     (SSI_CTRLR0_TMOD_VALUE_EEPROM_READ << SSI_CTRLR0_TMOD_LSB);    // Send INST/ADDR, Receive Data

    ssi_hw->ctrlr1 = 0; // Single 32b read

    

    // Final SPI ctrlr0 settings.
    ssi_hw->spi_ctrlr0 = (READ_INSTRUCTION << SSI_SPI_CTRLR0_XIP_CMD_LSB) | // Mode bits to keep flash in continuous read mode
                         (ADDR_L << SSI_SPI_CTRLR0_ADDR_L_LSB) |    // Total number of address + mode bits
                         (0 << SSI_SPI_CTRLR0_WAIT_CYCLES_LSB) |    // Hi-Z dummy clocks following address + mode
                         (INSTRUCTION_LENGTH << SSI_SPI_CTRLR0_INST_L_LSB) | // Do not send a command, instead send XIP_CMD as mode bits after address
                         (TRANSACTION_TYPE << SSI_SPI_CTRLR0_TRANS_TYPE_LSB); // Send Address in Quad I/O mode (and Command but that is zero bits long)

    // Re-enable the SSI
    ssi_hw->ssienr = 1;

    // If lr is 0, then we came from the bootloader.
    if (lr == 0) {
        uint32_t* vector_table = (uint32_t*) (XIP_BASE + 0x100);
        // Switch the vector table to immediately after the stage 2 area.
        *((uint32_t *) (PPB_BASE + M0PLUS_VTOR_OFFSET)) = (uint32_t) vector_table;
        // Set the top of the stack according to the vector table.
        asm volatile ("MSR msp, %0" : : "r" (vector_table[0]) : );
        // The reset handler is the second entry in the vector table
        asm volatile ("bx %0" : : "r" (vector_table[1]) : );
        // Doesn't return. It jumps to the reset handler instead.
    }
    // Otherwise we return.
}

static uint32_t wait_and_read(uint8_t count) {
    while ((ssi_hw->sr & SSI_SR_TFE_BITS) == 0) {}
    while ((ssi_hw->sr & SSI_SR_BUSY_BITS) != 0) {}
    uint32_t result = 0;
    while (count > 0) {
        result = ssi_hw->dr0;
        count--;
    }
    return result;
}

static uint8_t read_flash_sreg(uint8_t status_command) {
    ssi_hw->dr0 = status_command;
    ssi_hw->dr0 = status_command;

    return wait_and_read(2);
}