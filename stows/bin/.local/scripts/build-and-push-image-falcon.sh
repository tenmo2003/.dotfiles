#!/usr/bin/env bash

tag=$1

remote_url=$(git remote get-url origin)

regex="(?:https?|ssh):\/\/.*?\/(.*)(?:\.git)?"

if [[ $remote_url =~ ^(https?|ssh)://[^/]*/(.*)(\.git)?$ ]]; then
    location=${BASH_REMATCH[2]}

    full_location="registry.falcongames.com/$location:$tag"
    echo "Building $full_location"

    sudo docker build -t $full_location .
    sudo docker push $full_location
else
    echo "Could not determine remote name from $remote_url"
fi
