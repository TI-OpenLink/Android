#!/bin/bash

pushd ./workspace/wlan
repo manifest -r -o ../ti-ol-manifest/ti-ol-driver-manifest.R5.yy.xml
popd

pushd ./workspace/mydroid
repo manifest -r -o android-manifest.xml
popd

python ./WCS_Tools/misc/scripts/update_ti-ol_manifests.py ./workspace/mydroid/android-manifest.xml ./workspace/ti-ol-manifest/ti-ol-android-manifest.R5.yy.xml
rm ./workspace/mydroid/android-manifest.xml

pushd workspace/ti-ol-manifest/
git commit -a -m $1
git tag -f -a $1 -m $1
git remote set-url --push origin git@github.com:TI-OpenLink/ti-ol-manifest.git
git push -f origin $1
popd

