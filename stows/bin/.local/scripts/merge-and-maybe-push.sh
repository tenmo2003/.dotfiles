#!/usr/bin/env bash

target_branch=$1
current_branch=$(git rev-parse --abbrev-ref HEAD)

if [[ $current_branch == "$target_branch" ]]; then
    echo "You are on $target_branch branch"
    exit 0
fi

git checkout $target_branch
git merge $current_branch

answer="n"
read -p "Do you want to push to origin $target_branch? (y/n) (default: n) " answer

if [[ $answer == "y" ]]; then
    git push origin $target_branch
fi

git checkout $current_branch
