# Cloudhub-Workflow
This is a template repository to get a CI/CD setup utilizing github actions to deploy Mulesoft applications to Cloudhub triggered from commits to the repo. Start with repos or copy the template files into preexisting  In addition, the workflow can do the following automatically:
    - Run MUnit Tests during build for code regression!
    - Save Artifacts within Github for release to different environments
    - Prepped for configuring environments easily
    - Configurable deployment properties, such as size of workers or deployment zones
    - Configurable runtime properties, such as anypoint platform configurations
    - Optionally trigger newman (postman) tests for automated post-deployment smoke tests
    - Gate higher environment deployments with user reviews
    - Leverages github secrets for any sensitive keys

### Getting Started:
