#!/usr/bin/env bash

current_branch=$(git rev-parse --abbrev-ref HEAD)

if [[ $current_branch == "server-test" ]]; then
    echo "You are on server-test branch"
    exit 0
fi

git checkout server-test
git merge $current_branch

if [[ $1 == "-p" ]]; then
    git push origin server-test
fi

git checkout $current_branch
