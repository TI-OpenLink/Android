#!/bin/bash

export NEW_TAG_NAME=$1

pushd .

cd workspace/wlan
repo forall -c 'echo "removing tag ${NEW_TAG_NAME} from project ${REPO_PROJECT}" ; git tag -d ${NEW_TAG_NAME} ; git push ${REPO_REMOTE} :${NEW_TAG_NAME}'
cd -

cd workspace/mydroid
repo forall -c 'if [ ${REPO_REMOTE} == "TI-OpenLink" ] ; then \
	echo "removing tag ${NEW_TAG_NAME} from project ${REPO_PROJECT}" ; \
	git tag -d ${NEW_TAG_NAME} ; \
	git push ${REPO_REMOTE} :${NEW_TAG_NAME} ; \
fi'

repo forall -c 'if [ ${REPO_REMOTE} == "TI-OpenLink-secured" ] ; then \
        echo "removing tag ${NEW_TAG_NAME} from project ${REPO_PROJECT}" ; \
        git tag -d ${NEW_TAG_NAME} ; \
        git push ${REPO_REMOTE} :${NEW_TAG_NAME} ; \
fi'
cd -

popd
