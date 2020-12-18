README
==========

This is Just in Time PIM for GCP.

CLI
----------

```bash
$ gsu: Switch GCP user role.
usage:
    gsu {group_name}
    gsu -l
    gsu -la
    gsu config scaffold
    gsu config set API_URL {API URL}
    gsu admin attach {user_name} {group_name}
    gsu admin detach {user_name} {group_name}
```

Config
------------

```bash
$ cat ~/.gsu_config
URL: http://localhost:8080
```

Deploy API
---------

```bash
$ ./presetup.sh
$ gcloud builds submit --config=cloudbuild.yaml \
  --substitutions=_GCP_ADMIN_USER="${GCP_ADMIN_USER}",_GCP_DOMAIN="${GCP_DOMAIN}",_GSU_API_URL="${GSU_API_URL}" .
```

