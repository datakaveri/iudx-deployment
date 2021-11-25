# Install
## Required secrets
```sh
secrets
`-- adminpassword
```
Please see the example-secrets directory to get more idea, can use the 'secrets' in that directory by copying into root database directory  for demo or local testing purpose only! For other environment, please generate strong passwords.
## Build the docker file
```sh
docker build -t redisrejson .
```
## Creating an overlay network
```sh
docker network create --driver overlay overlay-net
```
## Deploy
Bring up the redis stack,
```sh
docker stack deploy -c redis-rejson-stack.yml redis
```