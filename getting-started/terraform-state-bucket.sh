#!/bin/bash

PROJECT_ID=harm-personal-projects
BUCKET_NAME=$PROJECT_ID-terraform-state

if [ "$1" == "create" ];
then
	gsutil mb \
		-p $PROJECT_ID \
		-c STANDARD \
		-l europe-north1 \
		-b on \
		gs://$BUCKET_NAME
elif [ "$1" == "delete" ];
then
	gsutil rb \
		gs://$BUCKET_NAME
fi
