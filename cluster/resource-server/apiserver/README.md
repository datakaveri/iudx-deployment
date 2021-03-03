# Deployment of Clustered single container Resource server
## Required Secrets
  - Generate the keystore and split config-depl.json, [see here](https://github.com/datakaveri/iudx-resource-server/example-credentials-environment/one-verticle-configs) into per-vericle and store in secrets which has following structure:
    ```sh
    secrets/
    └── credentials
        ├── keystore.jks
        └── one-verticle-configs
            ├── config-apiserver.json
            ├── config-authenticator.json
            ├── config-callback.json
            ├── config-database.json
            └── config-databroker.json
    ```
## Environment file
  - Create an environment file called '.rs-api-server' with following template:
    ```sh
    # Note: Don't include any statements with '#' because that's not comment, it is been used for only elaborating 
    # the environment variables. Defaults apply if the environment variables are not explicitly defined in env file.
    RS_URL=https://rs.iudx.io       # Default value is http://localhost
    LOG_LEVEL=INFO                  # LOG_LEVEL can be TRACE, DEBUG, INFO, WARN, ERROR,FATAL, OFF, ALL, default is DEBUG
    RS_JAVA_OPTS=-Xmx4096m          # RS_JAVA_OPTS can be any java options but as of now heap max size is sufficient, default is 2GiB
    ```
## Assign node labels
1. To tag node where resource server api service will be placed:
  ```sh
  docker node update --label-add rs_api_node=true <node_name>   
  ```
2. To tag node where resource server databroker will be placed, i.e., along databroker:
  ```sh
  docker node update --label-add databroker_node=true <node_name>   
  ```
3. To tag node where resource server database service will be placed, i.e. along elastic search db:
  ```sh
  docker node update --label-add database_node=true <node_name>   
  ```
4. To tag node where resource server callback will be placed, i.e. along with postgres db:
  ```sh
  docker node update --label-add auth_cred_db_node=true <node_name>   
  ```
5. To tag the node where resource server authenticator service will be placed:
  ```sh
  docker node update --label-add rs_authenticator_node=true <node_name> 
  ```
### Deploy
   - Set `rs_version` environment variable to deploy that tagged image:
    ```sh
    export rs_version=x.y.z-id
    ```
    ```sh
    # Bring up resource server 
    docker stack deploy -c rs-stack.yml rs
    ```
#### Note 
1. Please use [this](https://docs.docker.com/compose/extends/) technique of overriding/merging compose files (i.e. using non-git versioned rs-stack.temp.yml along with unmodified rs-stack.yml) file.