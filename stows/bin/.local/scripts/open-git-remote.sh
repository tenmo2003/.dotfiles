#!/usr/bin/env bash

if [[ -z .git ]]; then
    echo "Not a git repository"
    exit 1
fi

url=$(git remote get-url origin)

# if [[ $url =~ git@github.com ]]; then
#     url=$(echo $url | sed 's/git@git.com:/https:\/\/github.com\//')
# elif [[ $url =~ git@gitlab.com ]]; then
#     url=$(echo $url | sed 's/git@gitlab.com:/https:\/\/gitlab.com\//')
# fi

# ssh://[user@]host[:port]/path and [user@]host:path -> https://host/path
url=$(echo "$url" | sed -E \
    -e 's#^(git\+)?ssh://([^@/]+@)?([^:/]+)(:[0-9]+)?/#https://\3/#' \
    -e 's#^[^@/:]+@([^:/]+):#https://\1/#' \
    -e 's#\.git$##')

sensible-browser $url || echo "No remote repository"
