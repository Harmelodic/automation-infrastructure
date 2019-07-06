#!/bin/bash

helm init

kubectl create clusterrolebinding add-on-cluster-admin-tiller --clusterrole=cluster-admin --serviceaccount=kube-system:default

helm install --name nginx --set rbac.create=true stable/nginx-ingress
