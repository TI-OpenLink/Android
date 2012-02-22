#!/bin/bash

pushd .

cd workspace/wlan
repo forall -c 'git remote set-url --push ${REPO_REMOTE} git@github.com:TI-OpenLink/${REPO_PROJECT}.git'
cd -

cd workspace/mydroid
repo forall -c 'if [ ${REPO_REMOTE} == "TI-OpenLink" ] ; then git remote set-url --push ${REPO_REMOTE} git@github.com:TI-OpenLink/${REPO_PROJECT}.git ; fi'
repo forall -c 'if [ ${REPO_REMOTE} == "TI-OpenLink-secured" ] ; then git remote set-url --push ${REPO_REMOTE} git@github.com:TI-OpenLink/${REPO_PROJECT}.git ; fi'
cd -

popd
