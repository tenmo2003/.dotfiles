#!/usr/bin/env bash

echo $(pwd)
if [[ -z .git ]]; then
    echo "Not a git repository"
    exit 1
fi

url=$(git remote get-url origin)
echo $url

# if [[ $url =~ git@github.com ]]; then
#     url=$(echo $url | sed 's/git@git.com:/https:\/\/github.com\//')
# elif [[ $url =~ git@gitlab.com ]]; then
#     url=$(echo $url | sed 's/git@gitlab.com:/https:\/\/gitlab.com\//')
# fi

url=$(echo $url | sed 's/git@\([^:]*\):/https:\/\/\1\//')

sensible-browser $url || echo "No remote repository"
