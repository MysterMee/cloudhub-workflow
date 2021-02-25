
counter=0
tick=10
timeout=300

sleep $tick

until [ $counter -gt $timeout ]
do
  echo `anypoint-cli runtime-mgr cloudhub-application describe $repoName -o json`
  status=`anypoint-cli runtime-mgr cloudhub-application describe $repoName -o json | jq -r '.Status'`
  if [ $status == "STARTED" ]; then
    echo 'Deployment has started on cloudhub.'
    exit 0
    break
  elif [[ $status == "DEPLOYING" || $status == "UPDATING" ]]; then
    (( counter = counter + tick ))
    echo 'Currently still deploying or updating.'
    sleep $tick
  else
    echo 'Unexpected state detected! Check deployment at cloudhub for more details.'
    exit 1
  fi
done

echo 'Script exceeded set timeout.'
exit 1
