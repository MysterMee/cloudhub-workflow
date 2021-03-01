#!/bin/bash

# Anypoint CLI's deploy command errors out when the application already exists
#   Simply attempt modify when deploy returns an error
anypoint-cli runtime-mgr cloudhub-application deploy "$@" ||
anypoint-cli runtime-mgr cloudhub-application modify "$@"
