
status=`anypoint-cli runtime-mgr cloudhub-application describe "$@" -o json | jq -r '.Status'`
if [[ "$status" = "UNDEPLOYED" ]]; then
  echo "$@ was detected to be in UNDEPLOY state, so starting the application first."
  anypoint-cli runtime-mgr cloudhub-application start "$@"
fi
