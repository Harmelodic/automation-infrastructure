#!/bin/bash

PROJECT_ID=harm-personal-projects
NAME=terraform
FULL_SERVICE_ACCOUNT_IDENTIFIER=$NAME@$PROJECT_ID.iam.gserviceaccount.com

if [ "$1" == "create" ];
then
	gcloud iam service-accounts create $NAME \
		--project=$PROJECT_ID

	gcloud projects add-iam-policy-binding $PROJECT_ID \
		--member=serviceAccount:$FULL_SERVICE_ACCOUNT_IDENTIFIER \
		--role=roles/editor \
		--project=$PROJECT_ID

	gcloud iam service-accounts keys create service_account.json \
		--iam-account=$FULL_SERVICE_ACCOUNT_IDENTIFIER \
		--project=$PROJECT_ID

	echo "Put this in the appropriate GitLab CI/CD variable:"

	cat service_account.json
elif [ "$1" == "delete" ];
then
	gcloud iam service-accounts delete $FULL_SERVICE_ACCOUNT_IDENTIFIER \
		--project=$PROJECT_ID
fi
