#!/bin/bash

touch /var/log/cron
echo "@reboot /opt/webhook/readFromPipe.sh > /var/log/cron 2>&1" | tee -a /var/spool/cron/crontabs/root
/opt/webhook/readFromPipe.sh &
