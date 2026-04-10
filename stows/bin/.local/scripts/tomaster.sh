#!/usr/bin/env bash

current_branch=$(git rev-parse --abbrev-ref HEAD)

if [[ $current_branch == "master" ]]; then
    echo "You are on master branch"
    exit 0
fi

git checkout master
git merge $current_branch

if [[ $1 == "-p" ]]; then
    git push origin master
fi

git checkout $current_branch
