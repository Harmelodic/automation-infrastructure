#!/bin/bash

PROJECT_ID=$2
BUCKET_NAME=$3
REGION=$4

if [ -n "$1" ] && [ -n "$2" ] && [ -n "$3" ] && [ -n "$4" ];
then
	if [ "$1" == "create" ];
	then
		gsutil mb \
			-p "$PROJECT_ID" \
			-c STANDARD \
			-l "$REGION" \
			-b on \
			gs://"$BUCKET_NAME"
	elif [ "$1" == "delete" ];
	then
		gsutil rb \
			gs://"$BUCKET_NAME"
	fi
fi
