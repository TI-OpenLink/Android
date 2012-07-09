#!/bin/sh

export ARCH=arm
export CROSS_COMPILE=arm-none-linux-gnueabi-
export DRIVER_DIR=`pwd`/workspace/wlan/wl18xx
export NL_OUT_DIR=`pwd`/nl-artifacts

mkdir -p ${NL_OUT_DIR}/boot

cd $DRIVER_DIR
make blaze_defconfig
make -j12
make uImage -j12
make INSTALL_MOD_PATH=${NL_OUT_DIR} modules_install -j12
cp arch/arm/boot/uImage ${NL_OUT_DIR}/boot
cd -

cd ${NL_OUT_DIR}
find lib/ -name *.ko -exec ${CROSS_COMPILE}-strip {} \;
tar cvf nl-artifcats.tar lib
cd -

