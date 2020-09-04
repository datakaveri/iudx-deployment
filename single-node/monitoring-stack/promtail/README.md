# Build docker image
```sh
docker build -t <username>/promtail:1.6.0 .
```
# Description
- Promtail configuration file is present at conf/.
- "run.sh" script to run the promtail with external label as host whose env value is set at the time of running the service with "{{.Nodename}}"
