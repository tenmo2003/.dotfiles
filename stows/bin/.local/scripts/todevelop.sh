#!/usr/bin/env bash

current_branch=$(git rev-parse --abbrev-ref HEAD)

if [[ $current_branch == "develop" ]]; then
    echo "You are on develop branch"
    exit 0
fi

git checkout develop
git merge $current_branch

if [[ $1 == "-p" ]]; then
    git push origin develop
fi

git checkout $current_branch
