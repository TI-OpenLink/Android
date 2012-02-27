#!/bin/bash

export NEW_TAG_NAME=$1

pushd .

cd workspace/wlan
repo forall -c 'git tag -d ${NEW_TAG_NAME}'
repo forall -c 'echo "deleting tag ${NEW_TAG_NAME} from project ${REPO_PROJECT}"'
repo forall -c 'git push -f ${REPO_REMOTE} :${NEW_TAG_NAME}'
cd -

cd workspace/mydroid
repo forall -c 'if [ ${REPO_REMOTE} == "TI-OpenLink" ] ; then git tag -d ${NEW_TAG_NAME} ; fi'
repo forall -c 'if [ ${REPO_REMOTE} == "TI-OpenLink" ] ; then echo "deleting tag ${NEW_TAG_NAME} from project ${REPO_PROJECT}" ; fi'
repo forall -c 'if [ ${REPO_REMOTE} == "TI-OpenLink" ] ; then git push -f ${REPO_REMOTE} :${NEW_TAG_NAME} ; fi'

repo forall -c 'if [ ${REPO_REMOTE} == "TI-OpenLink-secured" ] ; then git tag -d ${NEW_TAG_NAME} ; fi'
repo forall -c 'if [ ${REPO_REMOTE} == "TI-OpenLink-secured" ] ; then echo "deleting tag ${NEW_TAG_NAME} from project ${REPO_PROJECT}" ; fi'
repo forall -c 'if [ ${REPO_REMOTE} == "TI-OpenLink-secured" ] ; then git push -f ${REPO_REMOTE} :${NEW_TAG_NAME} ; fi'
cd -

popd
