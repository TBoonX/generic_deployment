# Webhook

This webhook setting is used to automatically redeploy container if the webhook is used.
It is not for production use!

With this setting, a webhook is listening for requests with the correct secret in it and will write the redeploy value of the request into a pipe.
This pipe is read permanent by a script which executes redeployment scripts for each container when the redeploy value matches.

## Installation

The script need to be run as root if you dont want to change the hosts directory rights.

### Webhook

Use the script 'install_webhook_environment.sh' to prepare the webhook directory under '/opt/webhook/' and start the container which runs webhook.
The webhook container is included in the docker-compose file.

### Execution of redeployment

The webhook writes into a pipe which needs to be read by a script.
In order to run this script automatically cron is used.
With 'add_crontab_entry' the cron job description is added and the script is started.
The cron job will be restarted after each reboot.

### Add of new service

Changes needed for a new service A:

* Add of a new script which handles the container redeploy on the root folder of this repo: update_A.sh
* Add a new handling (one line) of the new service value ```A``` webhook send to the pipe in webhook/readFromPipe.sh
* In the CI of service A after the docker image was build, the webhook has to be called with a secret. The secret could be found on the server in /opt/webhook/webhook.json under "trigger-rule" - "and" - "match" - "value"
