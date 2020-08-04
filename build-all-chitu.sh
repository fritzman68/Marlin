#!/bin/bash

CONFIGS=(
  S_CURVE_ACCELERATION
  LIN_ADVANCE
  LIN_ADVANCE+S_CURVE_ACCELERATION
  CLASSIC_JERK
  CLASSIC_JERK+LIN_ADVANCE
)

MACHINES=(V6_330_TITAN_TMC
V6_330_TITAN_NO_TMC
V6_330_NO_TITAN_TMC
V6_330_NO_TITAN_NO_TMC
V6_400_TITAN_TMC
V6_400_NO_TITAN_TMC
V6_500_TITAN_TMC
V5_330_TITAN_TMC
V5_330_TITAN_NO_TMC
V5_330_NO_TITAN_TMC
V5_330_NO_TITAN_NO_TMC
XY3_V5_310_NO_TITAN_NO_TMC_NO_ABL)

OUTPUT_FOLDER="./Marlin-TronXY"
rm -rf $OUTPUT_FOLDER

for m in ${MACHINES[@]}; do
  printf "Building $m...\n"
  for f in ${CONFIGS[@]}; do
    #clean!
    rm -rf .pio/build/chitu_v5_gpio_init
    DEFINES="-D$m -D"`echo $f | sed "s/+/ -D/g"`
    printf "\tConfig $f..."
    FOLDER="$OUTPUT_FOLDER/$m/$f/"
    mkdir -p $FOLDER
    PLATFORMIO_BUILD_FLAGS="$DEFINES" platformio run > /dev/null 2>&1
    cp .pio/build/chitu_v5_gpio_init/update.cbd $FOLDER
    printf " done\n"
  done;
done;

