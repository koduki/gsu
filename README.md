README
==========

CLI
----------

```bash
$ gsu attach {user_name} {group_name}
$ gsu detach {user_name} {group_name}
$ gsu -la
$ gsu -l {user_name}
```

Config
------------

```bash
$ cat ~/.gsu_config
URL: http://localhost:8080
```

Configration of Service Account
-----------

- Create service account
- [Delegate G Suite Domain](https://developers.google.com/admin-sdk/directory/v1/guides/delegation)
- Store service account seacret key by berglas

```bash
export PROJECT_ID=${YOUR_PROJECT_ID}
export BUCKET_ID=${YOUR_BUCKET_ID}
export KMS_KEY=projects/${PROJECT_ID}/locations/global/keyRings/berglas/cryptoKeys/berglas-key
export SA=${YOUR_SEARVICE_ACCOUNT}

$ gcloud services enable --project ${PROJECT_ID} \
  cloudkms.googleapis.com \
  storage-api.googleapis.com \
  storage-component.googleapis.com

$ berglas bootstrap --project $PROJECT_ID --bucket $BUCKET_ID
$ berglas create ${BUCKET_ID}/sa-key "$(cat secreat.json)"  --key ${KMS_KEY}
$ berglas grant ${BUCKET_ID}/sa-key --member serviceAccount:${SA}

```

Deploy
---------

```bash
export PROJECT_ID=${YOUR_PROJECT_ID}
export GCP_ADMIN_USER=${YOUR_ADMIN_MAIL}
export GCP_DOMAIN=${YOUR_ADMIN_MAIL}
export BUCKET_ID=${YOUR_BUCKET_ID}

$ gcloud builds submit --tag gcr.io/${PROJECT_ID}/gsu .
$ gcloud run deploy \
    --image gcr.io/${PROJECT_ID}/gsu \
    --set-env-vars "GCP_ADMIN_USER=${GCP_ADMIN_USER},GCP_DOMAIN=${GCP_DOMAIN}" \
    --platform=managed --region us-central1 \
    --service-account gsu-785@${PROJECT_ID}.iam.gserviceaccount.com
```

