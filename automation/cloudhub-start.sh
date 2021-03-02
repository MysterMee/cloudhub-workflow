#!/bin/bash

# This script checks if the deployment is currently set to UNDEPLOYED status.
#   The Anypoint CLI will error out on attempting to start up an application in this state,
#   Therefore the script will start up the app in advance if the script finds as UNDEPLOYTED
status=`anypoint-cli runtime-mgr cloudhub-application describe "$@" -o json | jq -r '.Status'`
if [[ "$status" = "UNDEPLOYED" ]]; then
  echo "$@ was detected to be in UNDEPLOY state, so starting the application first."
  anypoint-cli runtime-mgr cloudhub-application start "$@"
fi
