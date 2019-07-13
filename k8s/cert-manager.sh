#!/bin/bash

SECRET_ACCESS_KEY=$1
HOSTED_ZONE_ID=$2
ACCESS_KEY_ID=$3

ME=`basename "$0"`
if [[ $# -eq 0 ]] || [[ $# -eq 1 ]] || [[ $# -eq 2 ]]; then
    echo ""
    echo "Not enough arguments supplied!"
    echo ""
    echo "Run this script with the following arguments:"
    echo "./$ME SECRET_ACCESS_KEY HOSTED_ZONE_ID ACCESS_KEY_ID"
    echo ""
    echo "Read about getting these here: https://scribbles.harmelodic.com/post/1542578400000"
    echo ""
    exit 1
fi

if [[ $# -eq 3 ]]; then
    helm install \
        --name cert-manager \
        --namespace kube-system \
        stable/cert-manager

    kubectl create secret generic cert-manager-route53 --from-literal=secret-access-key=$SECRET_ACCESS_KEY

    ISSUER=`cat "cert-manager-issuer.template.yaml" | sed "s/{{HOSTED_ZONE_ID}}/$HOSTED_ZONE_ID/g"`
    ISSUER=`echo "$ISSUER" | sed "s/{{ACCESS_KEY_ID}}/$ACCESS_KEY_ID/g"`

    echo "$ISSUER" | kubectl apply -f -

    cat << EndOfMessage
    Create an NGINX Ingress with the following extra values:

    # ...
    metadata:
    # ...
    annotations:
      # ...
      kubernetes.io/tls-acme: "true"
      certmanager.k8s.io/acme-dns01-provider: route53
      certmanager.k8s.io/acme-challenge-type: dns01
      certmanager.k8s.io/issuer: letsencrypt-staging
    # ...
    spec:
      # ...
      tls:
      - hosts:
        - "*.example.com"
        - example.com
        secretName: tls-staging-cert-wildcard-example
EndOfMessage
fi
