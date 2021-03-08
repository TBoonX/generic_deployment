#!/bin/bash

#OLD: login into github in order to have access to the registry
#pwd_=$(cat /home/root/github_access_token_gci_general) bash -c 'docker login --password $pwd_ --username "GCI-general" docker.pkg.github.com'

# read from pipe
pipe=/opt/webhook/pipe/host_executor_queue
[ -p "$pipe" ] || mkfifo -m 0600 "$pipe" || exit 1
while :; do
    while read -r repo; do
        dt=$(date '+%Y/%m/%d %H:%M:%S')
        if [ "$repo" ]; then
            wall "$dt : Fifo value: $repo"
            # Switch case for all service values
            /data/generic_deployment/deploy_repo.sh $repo
        fi
    done <"$pipe"
done
