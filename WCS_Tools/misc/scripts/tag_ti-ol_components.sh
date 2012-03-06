#!/bin/bash

export NEW_TAG_NAME=$1

pushd .
repo forall -c 'git tag -f -a ${NEW_TAG_NAME} -m ${NEW_TAG_NAME}'
repo forall -c 'echo "updating project ${REPO_PROJECT} with new tag ${NEW_TAG_NAME}"'
repo forall -c 'git push -f ${REPO_REMOTE} ${NEW_TAG_NAME}'
popd

