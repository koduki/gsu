README
-------

Debug
---------

```bash
docker build -t koduki/gsu .
docker run -it -p 8080:8080 -v `pwd`:/app -v ~/:/secrets -e GOOGLE_APPLICATION_CREDENTIALS=/secrets/key.json koduki/gsu bash
```

Deploy API
---------

```bash
$ ./presetup.sh
$ GCP_ADMIN_USER=
$ GCP_DOMAIN=
$ GSU_API_URL=
$ gcloud builds submit --config=cloudbuild.yaml \
  --substitutions=_GCP_ADMIN_USER="${GCP_ADMIN_USER}",_GCP_DOMAIN="${GCP_DOMAIN}",_GSU_API_URL="${GSU_API_URL}" .
```