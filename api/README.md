docker build -t koduki/gsu .
docker run -it -p 8080:8080 -v `pwd`:/app -v ~/:/seacret -e GOOGLE_APPLICATION_CREDENTIALS=/seacret/koduki-docker-test-001-1083-ca8b638d0ee5.json koduki/gsu bash

API_URL="http://localhost:8080"
TOKEN="Authorization: Bearer $(gcloud auth print-identity-token)"
CONTENT_TYPE="Content-Type: application/json"
curl -H "${TOKEN}" -H "${CONTENT_TYPE}" -X GET ${API_URL}/healthcheck

これを有効にする
Admin SDK API
https://console.developers.google.com/apis/library/admin.googleapis.com?project=koduki-docker-test-001-1083