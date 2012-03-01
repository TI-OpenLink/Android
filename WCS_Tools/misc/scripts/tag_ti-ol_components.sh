#!/bin/bash

export NEW_TAG_NAME=$1

pushd .

cd workspace/wlan
repo forall -c 'git tag -f ${NEW_TAG_NAME} -m ${NEW_TAG_NAME}'
repo forall -c 'echo "updating project ${REPO_PROJECT} with new tag ${NEW_TAG_NAME}"'
repo forall -c 'git push -f ${REPO_REMOTE} ${NEW_TAG_NAME}'
cd -

cd workspace/mydroid
repo forall -c 'if [ ${REPO_REMOTE} == "TI-OpenLink" ] ; then git tag -f ${NEW_TAG_NAME} -m ${NEW_TAG_NAME} ; fi'
repo forall -c 'if [ ${REPO_REMOTE} == "TI-OpenLink" ] ; then echo "updating project ${REPO_PROJECT} with new tag ${NEW_TAG_NAME}" ; fi'
repo forall -c 'if [ ${REPO_REMOTE} == "TI-OpenLink" ] ; then git push -f ${REPO_REMOTE} ${NEW_TAG_NAME} ; fi'

repo forall -c 'if [ ${REPO_REMOTE} == "TI-OpenLink-secured" ] ; then git tag -f ${NEW_TAG_NAME} -m ${NEW_TAG_NAME} ; fi'
repo forall -c 'if [ ${REPO_REMOTE} == "TI-OpenLink-secured" ] ; then echo "updating project ${REPO_PROJECT} with new tag ${NEW_TAG_NAME}" ; fi'
repo forall -c 'if [ ${REPO_REMOTE} == "TI-OpenLink-secured" ] ; then git push -f ${REPO_REMOTE} ${NEW_TAG_NAME} ; fi'
cd -

popd
