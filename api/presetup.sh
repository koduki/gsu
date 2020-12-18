#!/bin/bash

PROJECT_ID=$(gcloud config list --format json|jq -r .core.project)

# enable apis
gcloud services enable run.googleapis.com
gcloud services enable cloudtasks.googleapis.com
gcloud services enable secretmanager.googleapis.com
gcloud services enable admin.googleapis.com

# create account and store credential
gcloud iam service-accounts create --display-name gsu-api gsu-api
sleep 10
gcloud iam service-accounts keys create --iam-account $(gcloud iam service-accounts list --filter='displayName:gsu-api' --format json|jq -r .[0].email) /tmp/key.json


gcloud secrets create gsu-credential --replication-policy="automatic"
gcloud secrets versions add gsu-credential --data-file="/tmp/key.json"
rm /tmp/key.json
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:gsu-api@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/secretmanager.secretAccessor

# create queue
gcloud tasks queues create q-gsu-events
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:gsu-api@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/cloudtasks.taskRunner

