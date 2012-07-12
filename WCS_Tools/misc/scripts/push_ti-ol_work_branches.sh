#!/bin/bash

pushd .

cd workspace/wlan
repo forall -c 'git push ${REPO_REMOTE} ${REPO_RREV}'
cd -

cd workspace/mydroid
repo forall -c 'if [ ${REPO_REMOTE} == "TI-OpenLink" ] ; then git push ${REPO_REMOTE} ${REPO_RREV} ; fi'
cd -

popd
