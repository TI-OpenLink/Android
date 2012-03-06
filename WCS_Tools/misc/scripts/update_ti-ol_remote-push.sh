#!/bin/bash

pushd .
repo forall -c 'git remote set-url --push ${REPO_REMOTE} git@github.com:TI-OpenLink/${REPO_PROJECT}.git'
popd

