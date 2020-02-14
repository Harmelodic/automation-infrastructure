#!/bin/bash

kubectl create serviceaccount kd

kubectl create clusterrolebinding kd-editor \
    --clusterrole=edit \
    --serviceaccount=default:kd

SECRET=`kubectl get secrets | grep kd-token- | awk '{print $1;}'`

TOKEN=`kubectl describe secret $SECRET | grep token: | awk '{print $2;}'`

echo ""
echo "Service Account Token:"
echo $TOKEN
echo ""
