#!/bin/sh

TAG_NAME=$1

pushd .

cd workspace/mydroid/
. build/envsetup.sh
lunch full_blaze-userdebug
cd external/wpa_supplicant_8

if [ -d wapi_and_wfd-patches ] ; then rm -rf wapi_and_wfd-patches ; fi
git clone git@gitorious.tif.ti.com:ti-openlink/wapi_and_wfd-patches.git -b r5.1

git checkout mc_internal -b wapi_wfd
git am wapi_and_wfd-patches/00*
git tag -f -a "${TAG_NAME}-wapi_wfd" -m "${TAG_NAME}-wapi_wfd"
cd wapi_and_wfd-patches/
git tag -f -a "${TAG_NAME}" -m "${TAG_NAME}"
git push origin ${TAG_NAME}
cd ../

find ../../out/target/product/blaze/ -name wpa_\* -exec rm {} \;
find . -name '*.c' -exec touch {} \;
mm -j12
mv ../../out/target/product/blaze/system/bin/wpa_supplicant ./wpa_supplicant-wapi_wfd
mv ../../out/target/product/blaze/system/bin/wpa_cli ./wpa_cli-wapi_wfd


find ../../out/target/product/blaze/ -name wpa_\* -exec rm {} \;
find . -name '*.c' -exec touch {} \;
git checkout mc_internal
mm -j12

mv ./wpa_supplicant-wapi_wfd ../../out/target/product/blaze/system/bin/wpa_supplicant-wapi_wfd
mv ./wpa_cli-wapi_wfd ../../out/target/product/blaze/system/bin/wpa_cli-wapi_wfd

strings ../../out/target/product/blaze/system/bin/wpa_supplicant | grep $TAG_NAME
strings ../../out/target/product/blaze/system/bin/wpa_cli | grep $TAG_NAME
strings ../../out/target/product/blaze/system/bin/wpa_supplicant-wapi_wfd | grep $TAG_NAME
strings ../../out/target/product/blaze/system/bin/wpa_cli-wapi_wfd | grep $TAG_NAME



popd
