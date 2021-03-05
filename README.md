
# Cloudhub-Workflow
This is a template repository to get a CI/CD setup utilizing GitHub actions to deploy MuleSoft applications to Cloudhub triggered from commits to the repo. Start with this repo or copy the template files into pre-existing repos. In addition, the workflow can do the following automatically:
- Run MUnit Tests during build for code regression
- Save Artifacts within Github for release to different environments
- Prepped for configuring environments easily
- Sequential environment deployment (dev first, qa second, prod third for example)
- Configurable deployment properties, such as size of workers or deployment zones
- Configurable runtime properties, such as Anypoint Platform configurations
- Optionally trigger newman (postman) tests for automated post-deployment smoke tests
- Gate higher environment deployments with user reviews
- Leverages GitHub secrets for any sensitive keys

## Getting Started:
You'll need **Git Bash** and **NPM** installed locally for initial setup.
<details>
  <summary>
  1.) Anypoint Credentials File:
  </summary>
<br/>

The Anypoint CLI is leveraged to interface with Cloudhub directly. This requires setting up a credentials file for secure authentication, which we will eventually upload to GitHub as a secret (note this file is non-accessible once set as a secret.) It's a good idea to test everything locally before uploading. Here's a brief explanation of getting it working locally:

##### Run the following in your bash:
Install Anypoint CLI to your local machine first
```
npm -i g anypoint-cli@latest
```
Then create your credentials file:
```
mkdir ~/.anypoint
cat > credentials
```
The official documentation describes how to write out the actual file [here](https://docs.mulesoft.com/runtime-manager/anypoint-platform-cli#credentials-file)

#####  Here's also an example file:
- The **user** used in this file should have deployment access to every environment you would like to support in the Cloudhub organization.
- The **organization** specified are the names found underneath the Business Group dropdown in the Anypoint Platform.
- The **environments** are the exact names setup in your selected organization.
```
{
  "default": {
    "organization": "MyOrg",
    "username": "*",
    "password": "#",
    "environment": "Sandbox"
  },
  "dev": {
	"organization": "MyOrg",
    "username": "*",
    "password": "#",
    "environment": "Sandbox"
  },
  "qa": {
	"organization": "MyOrg",
    "username": "*",
    "password": "#",
    "environment": "QA"
  },
  "prod": {
	"organization": "MyOrg",
    "username": "*",
    "password": "#",
    "environment": "Prod"
  }
}
```
Note that this workflow requires the **keys** that wrap the Auth credentials into different environments in Cloudhub will be **referenced later in the scripts**. So beware the casing of what you decide to use here while configuring all of the environments you would like to support.

Test out your config by opening a bash anywhere, and using the command:
```
anypoint-cli account environment list
```
You should see a list of all of the environments in your org. This verifies your default configuration.
</details>
<br/>

<details>
  <summary>
  2.) Setup Secrets in GitHub
  </summary>
<br/>

Within the settings of the repo you are configuring, open up the Environments tab. Open up as many environments needed to match whatever was put into the credentials file from the previous step.
<br/><br/>
Within Actions Secrets under Settings, this template requires specific declarations of variables the scripts will reference.

Ensure the following are declared:

1.) **ANYPOINT_CREDENTIALS_FILE** - Repository Secret
This is the credentials file you setup earlier. You can simply copy and paste the contents into the text box and save.

2.) **ANYPOINT_PLATFORM_CLIENT_ID** - Environment Secret
This is the `-Danypoint.platform.client_id` property that allows the Cloudhub application to leverage other features of the Anypoint Platform.

3.) **ANYPOINT_PLATFORM_CLIENT_SECRET** - Environment Secret
This is the `-Danypoint.platform.client_secret` property that allows the Cloudhub application to leverage other features of the Anypoint Platform.

4.) **ENCRYPTION_KEY** - Either Repository or Environment Secret
Assuming that your project uses a `-DencryptionKey` property to isolate key from the project, this is where the template will reference that to inject it during deployment. If it's the same across all of the environments it should be a Repository secret.
</details>
<br/>

<details>
  <summary>
  3.) Final Tweaks to .yml File
  </summary>
<br/>

The real engine behind the scripts is the file found under `.github/workflows/Cloudhub.yml`.
Here you will have to adjust this file if your environments does not exactly match up with dev/qa/prod.

There is a repeating section of the yaml file towards the end that steps for each environment. It looks like this:
```
dev-deploy:
  needs: build
  environment: dev
  env:
    environment: dev
    repository: ${{ github.repository }}
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v2

    - name: A.) Download Artifact
      uses: actions/download-artifact@v1
      with:
        name: artifact
        path: staging

    - name: B.) Deploy to Cloudhub
      shell: bash
      env:
        encryption: ${{ secrets.ENCRYPTION_KEY }}
        credentials: ${{ secrets.ANYPOINT_CREDENTIALS_FILE }}
        clientId: ${{ secrets.ANYPOINT_PLATFORM_CLIENT_ID }}
        clientSecret: ${{ secrets.ANYPOINT_PLATFORM_CLIENT_SECRET }}
      run: bash "${PWD}/automation/github-runner.sh"

#    - name: C.) Post-deployment API Tests
#      shell: bash
#      run: |
#        sudo npm i -g newman@latest
#        repoName="${repository##*/}"
#        newman run "automation/tests/${repoName}.postman_collection.json" -e "automation/tests/${environment}.postman_environment.json"
```
If you have more or less environments than this template, remove or add more based on this pattern.

Make minor tweaks for templates added in:
```
newenv-deploy:            # Change this to describe a new environment in the GitHub UI
  needs: build            # Name of the job that must complete before this job starts.
                            # If this is the lowest environment, ensure its still 'build'.
                            # If this is a higher environment, rig this needs step to be the name of the job that should occur before deploying to this environment.
  environment: newenv     # Reference to the configured GitHub environment
  env:
    environment: newenv   # Reference to the key specified in the credentials file
```

Ensure that at the top of the file, that the trigger branch is specified in your repo:
```
on:
  push:
    branches:
      - 'develop'
```
For further customization of the workflow trigger, see [here](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#on)
</details>
