import os
from typing import Tuple
import typer
import pathlib
import cascadetoml
import gen_stage2 

TOML_ROOT = "nvm.toml"
BUILD_ROOT = "build"
compiler_flags = [
    "-march=armv6-m",
    "-mthumb",
    "-mabi=aapcs-linux",
    "-mcpu=cortex-m0plus",
    "-msoft-float",
    "-mfloat-abi=soft", 
]

def outpath(flash, file) -> pathlib.Path:
    return pathlib.Path(BUILD_ROOT) / flash / file

def gen_boot2_for_flash(flash:str):
    # create build dir
    build_dir = os.path.join(BUILD_ROOT, flash)
    for dir in [BUILD_ROOT, build_dir]:
        if not os.path.isdir(dir):
            os.mkdir(dir)
    # clear out everything in it
    for file in os.scandir(build_dir):
        os.unlink(file.path)
    # step 1: generate stage2.c
    gen_stage2.main(pathlib.Path("stage2.c.jinja"), outpath(flash, "stage2.c"), flash, TOML_ROOT)
    # step 2: generate flash_info.h
    gen_stage2.main(pathlib.Path("flash_info.h.jinja"), outpath(flash, "flash_info.h"), flash, TOML_ROOT)
    # step 3: generate boot2.elf
    # step 4: generate boot2.bin
    # step 5: boot2_padded_checksummed.S

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

def main(sdk_path: pathlib.Path = pathlib.Path("sdk"), toolchain_path: str = typer.Argument("") ):
    fixup_adafruit_cascadetoml_fail()
    # get all flash chips
    flashes = cascadetoml.filter_toml(pathlib.Path("nvm.toml"), ['technology="flash"'])
    print(f"Got {len(flashes['nvm'])} matches")
    all_flashes: list[Tuple[str, str, int]] = [
        (f['manufacturer'], f['sku'], f['total_size']) 
        for f in flashes['nvm'] 
        if 'sku' in f and f['sku'] != f['manufacturer']
    ]
    for manufacturer, flash, size in all_flashes:
        print(f"Generating for {manufacturer.capitalize()} {flash} ({size / 1024.0 / 1024} MByte)")
        gen_boot2_for_flash(flash)
        #except Exception as exc:
        #    print(f"Generating boot2.S failed for {flash} due to: {exc!r}")

if __name__ == '__main__':
    typer.run(main)
