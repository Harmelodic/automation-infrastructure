#!/bin/bash

helm install \
    --name nginx \
    --set rbac.create=true \
    stable/nginx-ingress
