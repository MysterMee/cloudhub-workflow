#!/bin/bash

anypoint-cli runtime-mgr cloudhub-application deploy "$@" ||
anypoint-cli runtime-mgr cloudhub-application modify "$@"
