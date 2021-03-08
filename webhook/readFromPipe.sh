#!/bin/bash

# login into github in order to have access to the registry
pwd_=$(cat /home/root/github_access_token_gci_general) bash -c 'docker login --password $pwd_ --username "GCI-general" docker.pkg.github.com'

# set deployment dir
deployment_dir=/usr/local/src/nelga/nelga-deployment

# read from pipe
pipe=/opt/webhook/pipe/host_executor_queue
[ -p "$pipe" ] || mkfifo -m 0600 "$pipe" || exit 1
while :; do
    while read -r service; do
        dt=$(date '+%Y/%m/%d %H:%M:%S')
        if [ "$service" ]; then
            wall "$dt : Fifo value: $service"
            # Switch case for all service values
            case "$service" in 
                portal|nelga_portal)    cd $deployment_dir && ./update_portal.sh ;;
                import)                 cd $deployment_dir && ./update_import.sh ;;
                *)                      echo "Webhook: unknown service $service";;
            esac
        fi
    done <"$pipe"
done
