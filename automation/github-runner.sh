# Download Anypoint CLI to the runner
sudo npm i -g anypoint-cli@latest

# Setup credentials file within the runner
mkdir ~/.anypoint
echo "$credentials" >> credentials
cp ./credentials ~/.anypoint/
rm credentials

# Set Anypoint Platform enivornment context
export ANYPOINT_PROFILE="${environment}"

# Extract full jar name of the built artifact
jarName=$(ls staging/*.jar)

# Run cloudhub-start.sh
#   Starts up applications in cloudhub in UNDEPLOYED status before proceeding to the next steps.
if [[ "${environment}" == "prod" ]]; then
  repoName="${repository##*/}"
else
  repoName="${repository##*/}-${environment}"
fi
set -- "${repoName}"
bash "${PWD}/automation/cloudhub-start.sh" $@

# Compile runtime and deployment properties that the cloudhub application requires before deploying.
set --
if [ -f "$PWD/automation/env/${environment}/deploy.properties" ]; then
  while IFS='=' read key value; do
    set -- $@ "--$key $value"
  done < "$PWD/automation/env/${environment}/deploy.properties"
else
  echo 'Artifact does not contain deployment.properties!'
  exit 1
fi
if [ -f "$PWD/automation/env/${environment}/runtime.properties" ]; then
  while IFS='=' read key value; do
    set -- $@ "--property $key:$value"
  done < "$PWD/automation/env/${environment}/runtime.properties"
else
  echo 'Artifact does not contain runtime.properties!'
  exit 1
fi
set -- "$@" "--property encryptionKey:${encryption}" "--property anypoint.platform.client_id:${clientId}" "--property anypoint.platform.client_secret:${clientSecret}"
set -- "$@" "'${repoName}'" "'${PWD}/${jarName}'"
bash "${PWD}/automation/cloudhub-deploy.sh" $@

# Ping the application until the status is no longer in DEPLOYING or UPDATING status
set -- "'${repoName}'"
bash "${PWD}/automation/cloudhub-healthcheck.sh" $@
