#!/bin/bash

export NEW_TAG_NAME=$1

pushd .

cd workspace/wlan
repo forall -c 'echo "updating project ${REPO_PROJECT} with new tag ${NEW_TAG_NAME}" ; git tag -d ${NEW_TAG_NAME}'
cd -

cd workspace/mydroid
repo forall -c 'if [ ${REPO_REMOTE} == "TI-OpenLink" ] ; then \
	echo "updating project ${REPO_PROJECT} with new tag ${NEW_TAG_NAME}" ; \
	git tag -d ${NEW_TAG_NAME} ; \
fi'

repo forall -c 'if [ ${REPO_REMOTE} == "TI-OpenLink-secured" ] ; then \
	echo "updating project ${REPO_PROJECT} with new tag ${NEW_TAG_NAME}" ; \
	git tag -d ${NEW_TAG_NAME} ; \
fi'
cd -

popd
