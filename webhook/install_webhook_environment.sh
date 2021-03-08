#!/bin/bash

#apt-get update
#apt-get install -y webhook # Docker Container is used

mkdir -p /opt/webhook/pipe
mkfifo /opt/webhook/pipe/host_executor_queue

cp ./webhook.json /opt/webhook/webhook.json
cp ./hook_script.sh /opt/webhook/hook_script.sh
cp ./readFromPipe.sh /opt/webhook/readFromPipe.sh

docker run -d -p 81:81 -v /opt/webhook:/opt/webhook --name=webhook almir/webhook -verbose -hooks=/opt/webhook/webhook.json -hotreload -port 81
