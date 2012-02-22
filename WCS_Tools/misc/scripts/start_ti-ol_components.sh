#!/bin/bash

pushd .

cd workspace/wlan
repo forall -c 'repo start ${REPO_RREV} ${REPO_PROJECT}'
cd -

cd workspace/mydroid
repo forall -c 'if [ ${REPO_REMOTE} == "TI-OpenLink" ] ; then repo start ${REPO_RREV} ${REPO_PROJECT} ; fi'
repo forall -c 'if [ ${REPO_REMOTE} == "TI-OpenLink-secured" ] ; then repo start ${REPO_RREV} ${REPO_PROJECT} ; fi'
cd -

popd
