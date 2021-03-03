# Deployment of Clustered single container Resource server
## Required Secrets
  - Generate the keystore and config-depl.json as instructed [here](https://github.com/datakaveri/iudx-resource-server#prerequisite---make-configuration) and store in secrets which has following structure:
    ```sh
    secrets/
    └── credentials
        ├── all-verticles-configs
        │   └── config-depl.json 
        └── keystore.jks
    ```
## Environment file
  - Create an environment file called '.rs-api-server' with following template:
    ```sh
    # Note: Don't include any statements with '#' because that's not comment, it is been used for only elaborating 
    # the environment variables. Defaults apply if the environment variables are not explicitly defined in env file.
    RS_URL=https://rs.iudx.io       # Default value is http://localhost
    LOG_LEVEL=INFO                  # LOG_LEVEL can be TRACE, DEBUG, INFO, WARN, ERROR,FATAL, OFF, ALL, default is DEBUG
    RS_JAVA_OPTS=-Xmx4096m          # RS_JAVA_OPTS can be any java options but as of now heap max size is sufficient, default is 2GiB
 
## Assign node labels

```sh
docker node update --label-add rs_node=true <node_name>   
```
### Deploy
   - Set `rs_version` environment variable to deploy that tagged image:
    ```sh
    export rs_version=x.y.z-id
    ```
   - Bring up resource server 
    ```sh
    docker stack deploy -c rs-stack.yml rs
    ```
#### Note 
1. Please use [this](https://docs.docker.com/compose/extends/) technique of overriding/merging compose files (i.e. using non-git versioned rs-stack.temp.yml along with unmodified rs-stack.yml) file.
