#!/bin/bash

kubectl create serviceaccount gitlab

kubectl create clusterrolebinding gitlab-editor --clusterrole=edit --serviceaccount=default:gitlab

SECRET=kubectl get secrets | grep gitlab-token- | awk '{print $1;}'

TOKEN=kubectl describe secret $SECRET | grep token: | awk '{print $2;}'

echo ""
echo "Service Account Token:"
echo $TOKEN
echo ""
