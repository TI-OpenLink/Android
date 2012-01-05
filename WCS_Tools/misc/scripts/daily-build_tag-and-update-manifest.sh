#!/bin/bash

repo sync
repo manifest -r -o ./workspace/ti-ol-manifest/TI-OpenLink-R5.00.y.xml
pushd workspace/ti-ol-manifest/
git commit TI-OpenLink-R5.00.y.xml -m $1
git tag -f $1
git remote set-url --push origin git@github.com:TI-OpenLink/ti-ol-manifest.git
git push origin master --tags
git push origin $1
popd

