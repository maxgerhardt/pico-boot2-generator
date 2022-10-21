# Pico Boot2 File Generator

## Description

This tool generates the Boot2 stage for all flash chips known in a database for a Pico.

These files can e.g. be used to support new combination of a Pico with a new flash chip. 

Refer https://github.com/earlephilhower/arduino-pico/tree/master/boot2.

## Usage

Prerequisites: Python 3 and `arm-none-eabi-gcc` toolchain in the path.

```sh
git clone --recursive https://github.com/maxgerhardt/pico-boot2-generator
pip3 install -r requirements.txt
python3 build.py
```

You can also use the already pregenerated files in `generates/`.

These were generated using arm-nono-eabi-gcc 10.2.1 (Q4 Major).

## Credits

* @tannewt for `gen_stage2.py` in https://github.com/adafruit/circuitpython
* Adafruit for https://github.com/adafruit/nvm.toml/
* Raspbery Pi Foundation for https://github.com/raspberrypi/pico-sdk