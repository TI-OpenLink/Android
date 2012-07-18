#!/bin/bash

export TAG_NAME=$1

pushd .

cd workspace/wlan
repo forall -c '\
	echo "reseting project ${REPO_PROJECT} to tag ${TAG_NAME}" ; \
	git reset --hard ; \
	git checkout ${REPO_RREV} ; \
	git checkout ${TAG_NAME} -b b_${TAG_NAME} ; \
	echo "project ${REPO_PROJECT} describe output: `git describe --dirty`" ;'
cd -

cd workspace/mydroid
repo forall -c 'if [ ${REPO_REMOTE} == "TI-OpenLink" ] ; then \
	echo "reseting project ${REPO_PROJECT} to tag ${TAG_NAME}" ; \
	git reset --hard ; \
	git checkout ${REPO_RREV} ; \
	git checkout ${TAG_NAME} -b b_${TAG_NAME} ; \
	echo "project ${REPO_PROJECT} describe output: `git describe --dirty`" ; \
fi'

repo forall -c 'if [ ${REPO_REMOTE} == "TI-OpenLink-secured" ] ; then \
	echo "reseting project ${REPO_PROJECT} to tag ${TAG_NAME}" ; \
	git reset --hard ; \
	git checkout ${REPO_RREV} ; \
	git checkout ${TAG_NAME} -b b_${TAG_NAME} ; \
	echo "project ${REPO_PROJECT} describe output: `git describe --dirty`" ; \
fi'
cd -

popd

