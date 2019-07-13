#!/bin/bash

TOKEN_NAME=$1
TOKEN_USERNAME=$2
TOKEN_PASSWORD=$3

ME=`basename "$0"`
if [[ $# -eq 0 ]] || [[ $# -eq 1 ]] || [[ $# -eq 2 ]]; then
    echo ""
    echo "Not enough arguments supplied!"
    echo ""
    echo "Run this script with the following arguments:"
    echo "./$ME TOKEN_NAME TOKEN_USERNAME TOKEN_PASSWORD"
    echo ""
    echo "Read about creating Deploy Tokens here: https://docs.gitlab.com/ee/user/project/deploy_tokens/"
    echo ""
    exit 1
fi

if [[ $# -eq 3 ]]; then
    kubectl create secret docker-registry $TOKEN_NAME \
        --docker-server=registry.gitlab.com \
        --docker-username=$TOKEN_USERNAME \
        --docker-password=$TOKEN_PASSWORD \
        --docker-email=xyz@example.com
fi
