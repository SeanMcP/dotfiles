#!/bin/bash

BRANCH_CURRENT=$(git rev-parse --abbrev-ref HEAD)
BRANCH_DESTINATION=$1

if [ -z $BRANCH_DESTINATION ]; then
    echo "Provide a destination branch"
    exit 1
fi

git checkout $BRANCH_DESTINATION
git fetch
git pull
git branch -d $BRANCH_CURRENT
