#!/usr/bin/env python3
import os
from typing import Tuple
import typer
import sys
import pathlib
import cascadetoml
import subprocess
import gen_stage2 

TOML_ROOT = "nvm.toml"
BUILD_ROOT = "generated"
COMPILER_FLAGS = [
    "-DPICO_FLASH_SPI_CLKDIV=4",
    "-DRASPBERRYPI",
    "-DPICO_ON_DEVICE=1",
    "-DPICO_NO_BINARY_INFO=0",
    "-DPICO_TIME_DEFAULT_ALARM_POOL_DISABLED=0"
    "-DPICO_DIVIDER_CALL_IDIV0=0"
    "-DPICO_DIVIDER_CALL_LDIV0=0",
    "-DPICO_DIVIDER_HARDWARE=1"
    "-DPICO_DOUBLE_ROM=1",
    "-DPICO_FLOAT_ROM=1",
    "-DPICO_MULTICORE=1"
    "-DPICO_BITS_IN_RAM=0",
    "-DPICO_DIVIDER_IN_RAM=0",
    "-DPICO_DOUBLE_PROPAGATE_NANS=0",
    "-DPICO_DOUBLE_IN_RAM=0",
    "-DPICO_MEM_IN_RAM=0",
    "-DPICO_FLOAT_IN_RAM=0",
    "-DPICO_FLOAT_PROPAGATE_NANS=1",
    "-DPICO_NO_FLASH=0",
    "-DPICO_COPY_TO_RAM=0",
    "-DPICO_DISABLE_SHARED_IRQ_HANDLERS=0",
    "-DPICO_NO_BI_BOOTSEL_VIA_DOUBLE_RESET=0",
    "-DNDEBUG",
    "-O3",  # yes, there's -Os too, just like circuitpython does
    "-Wall",
    "-Werror",
    "-std=gnu11",
    "-nostdlib",
    "-fshort-enums",
    "-Werror=missing-prototypes",
    "-Wno-stringop-overflow",
    "-Wno-cast-align",
    "-Wno-error=unused-function",
    "-isystem", "sdk/src/rp2_common/hardware_base/include/",
    "-isystem", "sdk/src/rp2040/hardware_structs/include/",
    "-isystem", "sdk/src/rp2040/hardware_regs/include/",
    "-isystem", "sdk/",
    "-isystem", "sdk/src/common/pico_base/include/",
    "-isystem", "sdk/src/common/pico_binary_info/include/",
    "-isystem", "sdk/src/common/pico_stdlib/include/",
    "-isystem", "sdk/src/common/pico_sync/include/",
    "-isystem", "sdk/src/common/pico_time/include/",
    "-isystem", "sdk/src/common/pico_util/include/",
    "-isystem", "sdk/src/rp2_common/hardware_adc/include/",
    "-isystem", "sdk/src/rp2_common/hardware_claim/include/",
    "-isystem", "sdk/src/rp2_common/hardware_clocks/include/",
    "-isystem", "sdk/src/rp2_common/hardware_divider/include/", 
    "-isystem", "sdk/src/rp2_common/hardware_dma/include/", 
    "-isystem", "sdk/src/rp2_common/hardware_flash/include/", 
    "-isystem", "sdk/src/rp2_common/hardware_gpio/include/", 
    "-isystem", "sdk/src/rp2_common/hardware_irq/include/", 
    "-isystem", "sdk/src/rp2_common/hardware_i2c/include/", 
    "-isystem", "sdk/src/rp2_common/hardware_pio/include/", 
    "-isystem", "sdk/src/rp2_common/hardware_pll/include/", 
    "-isystem", "sdk/src/rp2_common/hardware_resets/include/", 
    "-isystem", "sdk/src/rp2_common/hardware_rtc/include/", 
    "-isystem", "sdk/src/rp2_common/hardware_spi/include/", 
    "-isystem", "sdk/src/rp2_common/hardware_sync/include/", 
    "-isystem", "sdk/src/rp2_common/hardware_timer/include/", 
    "-isystem", "sdk/src/rp2_common/hardware_uart/include/", 
    "-isystem", "sdk/src/rp2_common/hardware_watchdog/include",
    "-isystem", "sdk/src/rp2_common/hardware_xosc/include/", 
    "-isystem", "sdk/src/rp2_common/pico_multicore/include/", 
    "-isystem", "sdk/src/rp2_common/pico_fix/rp2040_usb_device_enumeration/include/",
    "-isystem", "sdk/src/rp2_common/pico_stdio/include/",
    "-isystem", "sdk/src/rp2_common/pico_printf/include/",
    "-isystem", "sdk/src/rp2_common/pico_float/include/",
    "-isystem", "sdk/src/rp2_common/pico_platform/include/",
    "-isystem", "sdk/src/rp2_common/pico_runtime/printf/include/",
    "-isystem", "sdk/src/rp2_common/pico_bootrom/include/",
    "-isystem", "sdk/src/rp2_common/pico_unique_id/include/",
    "--param", "max-inline-insns-single=500",
    "-fsingle-precision-constant",
    "-fno-strict-aliasing",
    "-ffunction-sections",
    "-fdata-sections",
    "-march=armv6-m",
    "-mthumb",
    "-mabi=aapcs-linux",
    "-mcpu=cortex-m0plus",
    "-msoft-float",
    "-mfloat-abi=soft",
    "-Os",
    "-ggdb3",
    "-I.",
    "-fPIC",
    "--specs=nosys.specs",
    "-nostartfiles",
    "-Wl,-T,boot_stage2.ld",
    "-Wl,-Map=boot2.map",
    "-o"
]

def exec_tool(args, input_file, output_file, verbose:bool=False):
    if verbose:
        print("Executing: " + " ".join(map(str,args)))
    try:
        ret = subprocess.check_output(args, shell=True, stderr=subprocess.STDOUT)
        if len(ret) != 0:
            print("Output: " + str(ret))
    except Exception as exc:
        print(f"Exception: {exc!r}")
    if not os.path.isfile(output_file):
        raise RuntimeError(f"Failed to procude file {output_file} for input {input_file}")

def get_compiler_tool(name:str, compiler_path:str):
    return name if compiler_path == "" else str(pathlib.Path(compiler_path) / "bin" / name)

def exec_compiler(compiler_path:str, input_file, output_file, verbose:bool=False):
    tool = get_compiler_tool("arm-none-eabi-gcc", compiler_path)
    args = [ tool ] 
    cflags = COMPILER_FLAGS.copy()
    base = os.path.dirname(output_file)
    cflags = [x if x != "-Wl,-Map=boot2.map" else f"-Wl,-Map={base}/boot2.map" for x in cflags]
    args.extend(cflags)
    args.extend([str(output_file), str(input_file)])
    exec_tool(args, input_file, output_file, verbose)

def conv_to_bin(compiler_path:str, input_file, output_file, verbose:bool=False):
    tool = get_compiler_tool("arm-none-eabi-objcopy", compiler_path)
    exec_tool([
        tool,
        "-O",
        "binary",
        input_file,
        output_file
    ], input_file, output_file, verbose)

def gen_disass(compiler_path:str, input_file, output_file, verbose:bool=False):
    tool = get_compiler_tool("arm-none-eabi-objdump", compiler_path)
    exec_tool([
        tool,
        "-d",
        input_file,
        ">",
        output_file
    ], input_file, output_file, verbose)

def gen_padded_source(bin_file, out_file, verb:bool):
    script = pathlib.Path("sdk") / "src" / "rp2_common" / "boot_stage2" / "pad_checksum"
    exec_tool([
        sys.executable, # Python
        script,
        "-s",
        "0xffffffff",
        bin_file,
        out_file
    ], bin_file, out_file, verb)

def get_toolchain_version(compiler_path, verb:bool=False):
    tool = get_compiler_tool("arm-none-eabi-gcc", compiler_path)
    args = [str(tool), "--version"]
    if verb:
        print("Executing: " + " ".join(args))
    try:
        return subprocess.check_output(args, stderr=subprocess.STDOUT, shell=True).decode('utf-8').splitlines()[0]
    except Exception as exc:
        return "Failed to get compiler version: " + repr(exc) 

def outpath(subdir, file) -> pathlib.Path:
    return pathlib.Path(BUILD_ROOT) / subdir / file

def gen_boot2_for_flash(flash:str, manufacturer:str, comp_path:str="", verb:bool=False):
    # create build dir
    build_dir = os.path.join(BUILD_ROOT, manufacturer, flash)
    for dir in [BUILD_ROOT, os.path.join(BUILD_ROOT, manufacturer), build_dir]:
        if not os.path.isdir(dir):
            os.mkdir(dir)
    # clear out everything in it
    for file in os.scandir(build_dir):
        os.unlink(file.path)
    boot2name = f"boot2_{flash}_4_padded_checksum.S"
    subdir = os.path.join(manufacturer, flash)
    # step 1: generate stage2.c
    gen_stage2.main(pathlib.Path("stage2.c.jinja"), outpath(subdir, "stage2.c"), flash, TOML_ROOT)
    # step 2: generate flash_info.h
    gen_stage2.main(pathlib.Path("flash_info.h.jinja"), outpath(subdir, "flash_info.h"), flash, TOML_ROOT)
    # step 3: generate boot2.elf
    exec_compiler(comp_path, outpath(subdir, "stage2.c"), outpath(subdir, "boot2.elf"), verb)
    # step 4: generate boot2.bin
    conv_to_bin(comp_path, outpath(subdir, "boot2.elf"), outpath(subdir, "boot2.bin"), verb)
    # step 5: boot2_padded_checksummed.S
    gen_padded_source(outpath(subdir, "boot2.bin"), outpath(subdir, boot2name), verb)
    # additonally: generate readable disassembly
    gen_disass(comp_path, outpath(subdir, "boot2.elf"), outpath(subdir, "boot2_disassembly.S"), verb)
    print(f"Generated successfully, boot2.bin size {os.path.getsize(outpath(subdir, 'boot2.bin'))} byte")

# https://github.com/adafruit/cascadetoml/issues/10
def fixup_adafruit_cascadetoml_fail():
    if os.sep == "\\":
        file = pathlib.Path("nvm.toml") / ".cascade.toml"
        if file.exists():
            content = file.read_text()
            fixed = content.replace('/', '\\\\') # replace unix filepaths with Windows ones
            if fixed != content:
                file.write_text(fixed)
                print("Corrected nvm.toml/.cascade.toml file for Windows")

def main(toolchain_path: str = typer.Argument(""), verbose:bool = False):
    fixup_adafruit_cascadetoml_fail()
    print("Toolchain version: " + get_toolchain_version(toolchain_path, verbose))
    # get all flash chips
    flashes = cascadetoml.filter_toml(pathlib.Path("nvm.toml"), ['technology="flash"'])
    print(f"Got {len(flashes['nvm'])} flash chips.")
    all_flashes: list[Tuple[str, str, int]] = [
        (f['manufacturer'], f['sku'], f['total_size']) 
        for f in flashes['nvm'] 
        if 'sku' in f and f['sku'] != f['manufacturer']
    ]
    for manufacturer, flash, size in all_flashes:
        manufacturer = manufacturer.capitalize()
        print(f"Generating for {manufacturer} {flash} ({size / 1024.0 / 1024} MByte)")
        #try:
        gen_boot2_for_flash(flash, manufacturer, toolchain_path, verbose)
        #except Exception as exc:
        #    print(f"Generating boot2.S failed for {flash} due to: {exc!r}")

if __name__ == '__main__':
    typer.run(main)
