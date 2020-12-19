#!/bin/bash

mkdir -p /secrets

/opt/google-cloud-sdk/bin/gcloud secrets versions access latest --secret=${GSU_SRC_ACCOUNT_KEY} --project ${GCP_PROJECT} > /secrets/key.json

cd /app
GOOGLE_APPLICATION_CREDENTIALS=/secrets/key.json ruby app.rb