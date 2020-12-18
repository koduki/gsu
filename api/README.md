README
-------

## Debug

```bash
docker build -t koduki/gsu .
docker run -it -p 8080:8080 -v `pwd`:/app -v ~/:/secrets -e GOOGLE_APPLICATION_CREDENTIALS=/secrets/key.json koduki/gsu bash
```