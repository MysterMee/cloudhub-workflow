
# Cloudhub-Workflow
This is a template repository to get a CI/CD setup utilizing github actions to deploy Mulesoft applications to Cloudhub triggered from commits to the repo. Start with repos or copy the template files into preexisting  In addition, the workflow can do the following automatically:
    - Run MUnit Tests during build for code regression!
    - Save Artifacts within Github for release to different environments
    - Prepped for configuring environments easily
    - Sequential environment deployment (dev first, qa second, prod third for example)
    - Configurable deployment properties, such as size of workers or deployment zones
    - Configurable runtime properties, such as anypoint platform configurations
    - Optionally trigger newman (postman) tests for automated post-deployment smoke tests
    - Gate higher environment deployments with user reviews
    - Leverages github secrets for any sensitive keys

### Getting Started:
You'll need **Git Bash** and **NPM** installed locally for initial setup.

<details>
<summary>1.) Anypoint Credentials File:</summary>

The Anypoint CLI is leveraged to interface with Cloudhub directly. This requires setting up a credentials file for secure authentication, which we will eventually upload to github as a secret (note this file is non-accessible once set as a secret.) It's a good idea to test everything locally before uploading. Here's a brief explanation of getting it working locally:

###### Run the following in your bash:
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

###### Here's also an example file:
The **user** used in this file should have deployment access to every environment you would like to support in the cloudhub organization.

The **organization** specified are the names found underneath the Business Group dropdown in the Anypoint Platform.

The **environments** are the exact names setup in your selected organization.
```
{
  "default": {
    "organization": "MyOrg",
    "username": "*",
    "password": "*",
    "environment": "Sandbox"
  },
  "dev": {
	"organization": "MyOrg",
    "username": "*",
    "password": "*#",
    "environment": "Sandbox"
  },
  "qa": {
	"organization": "MyOrg",
    "username": "*",
    "password": "*#",
    "environment": "QA"
  },
  "prod": {
	"organization": "MyOrg",
    "username": "*",
    "password": "*#",
    "environment": "Prod"
  }
}
```
Note that this workflow requires the **keys** that wrap the auth credentials into different environments in cloudhub will be **referenced later in the scripts**. So beware the casing of what you decide to use here while configuring all of the environments you would like to support.
</details>
