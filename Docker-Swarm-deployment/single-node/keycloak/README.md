# Install
Following deployments assume, there is a docker swarm and docker overlay network called "overlay-net" in the swarm. Please [refer](https://github.com/hackcoderr/iudx-deployment/blob/keycloak/docs/swarm-setup.md) to bring up docker swarm and the network.

## Required secrets

```sh
secrets/
└── passwords
    ├── postgres-user
    ├── postgres-password
    ├── postgres-db
    ├── keycloak-user
    ├── keycloak-password
    └── db-password
 ```
    
    
    

## Keycloak and PostgreSQL
The `keycloak-postgres.yml` template creates a volume for PostgreSQL and starts Keycloak connected to a PostgreSQL instance.

Run the example with the following command:

    docker-compose -f keycloak-postgres.yml up

Open http://localhost:8080/auth and login as user 'keycloak-user' with password 'keycloak-password'.

