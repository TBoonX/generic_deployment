#!/bin/bash

repo=$1
url="https://github.com/TBoonX/$repo.git"
workdir="/data"

# Verify repo is existing
lines=`git ls-remote --exit-code -h  "$url" | wc -l`
lines=$(($lines + 1))
if [ $lines -ne 2 ]; then
    # Wrong URL
    echo "Repository is not available. Exit."
    exit
fi

# Clone or update git repo
cd $workdir
DIR="$workdir/$repo"
if [ -d "$DIR" ]; then
   cd $repo
   git pull
else
   git clone $url
   cd $repo
fi

services=`cat services.txt`
docker-compose -f $workdir/generic_deployment/proxy.yml -f ./docker-compose.yml stop $services
docker-compose -f $workdir/generic_deployment/proxy.yml -f ./docker-compose.yml rm -f $services
docker-compose -f $workdir/generic_deployment/proxy.yml -f ./docker-compose.yml up -d $services

echo "Deployment of $repo done."
