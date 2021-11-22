## Get this image

The recommended way to get the Bitnami keycloak Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/keycloak).

```console
$ docker pull bitnami/keycloak:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/keycloak/tags/) in the Docker Hub Registry.

```console
$ docker pull bitnami/keycloak:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t bitnami/keycloak:latest 'https://github.com/bitnami/bitnami-docker-keycloak.git#master:15/debian-10'
```

## Configuration

### Admin credentials

The Bitnami Keycloak container can create a default admin user by setting the following environment variables:

- `KEYCLOAK_CREATE_ADMIN_USER`: Create administrator user on boot. Default: **true**.
- `KEYCLOAK_ADMIN_USER`: Administrator default user. Default: **user**.
- `KEYCLOAK_ADMIN_PASSWORD`: Administrator default password. Default: **bitnami**.
- `KEYCLOAK_MANAGEMENT_USER`: WildFly default management user. Default: **manager**.
- `KEYCLOAK_MANAGEMENT_PASSWORD`: WildFly default management password. Default: **bitnami1**.

### Connecting to a PostgreSQL database

The Bitnami Keycloak container requires a PostgreSQL database to work. This is configured with the following environment variables:

- `KEYCLOAK_DATABASE_HOST`: PostgreSQL host. Default: **postgresql**.
- `KEYCLOAK_DATABASE_PORT`: PostgreSQL port. Default: **5432**.
- `KEYCLOAK_DATABASE_NAME`: PostgreSQL database name. Default: **bitnami_keycloak**.
- `KEYCLOAK_DATABASE_USER`: PostgreSQL database user. Default: **bn_keycloak**.
- `KEYCLOAK_DATABASE_PASSWORD`: PostgreSQL database password. No defaults.
- `KEYCLOAK_DATABASE_SCHEMA`: PostgreSQL database schema. Default: **public**.
- `KEYCLOAK_JDBC_PARAMS`: PostgreSQL database JDBC parameters (example: `sslmode=verify-full&connectTimeout=30000`). No defaults.

### Port and address binding

The listening port and listening address can be configured with the following environment variables:

- `KEYCLOAK_HTTP_PORT`: Keycloak HTTP port. Default: **8080**.
- `KEYCLOAK_HTTPS_PORT`: Keycloak HTTPS port. Default: **8443**.
- `KEYCLOAK_BIND_ADDRESS`: Keycloak bind address. Default: **0.0.0.0**.

### Cluster configuration

The Bitnami Keycloak Docker image allows configuring a highly available cluster. In order to do so, two elements must be configured: the service discovery mechanism and the caching settings.

Service discovery is configured by setting the following variables:

- `KEYCLOAK_JGROUPS_DISCOVERY_PROTOCOL`: Sets the protocol that Keycloak nodes would use to discover new peers. Check the [official jgroups documentation](http://www.jgroups.org/javadoc3/org/jgroups/protocols/) for the list of available protocols. No defaults.
- `KEYCLOAK_JGROUPS_DISCOVERY_PROPERTIES`: Sets the properties for the discovery protocol set in `KEYCLOAK_JGROUPS_DISCOVERY_PROTOCOL`. It is a comma-separated list of `key=>value` pairs. No defaults.
- `KEYCLOAK_JGROUPS_TRANSPORT_STACK`: Transport stack for the discovery protocol set in `KEYCLOAK_JGROUPS_DISCOVERY_PROTOCOL`. Default: **tcp**.

Caching is configured by setting the following variables:

- `KEYCLOAK_CACHE_OWNERS_COUNT`: Number of nodes that will replicate cached data. Default: **1**.
- `KEYCLOAK_AUTH_CACHE_OWNERS_COUNT`: Number of nodes that will replicate cached authentication data. Default: **1**.

In the example below we will configure a 3-node keycloak cluster with a database-based discovery protocol (JDBC_PING):

```yaml
version: "2"
services:
  postgresql:
    image: "docker.io/bitnami/postgresql:11"
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - POSTGRESQL_USERNAME=bn_keycloak
      - POSTGRESQL_DATABASE=bitnami_keycloak
    volumes:
      - "postgresql_data:/bitnami/postgresql"
  keycloak-1:
    image: docker.io/bitnami/keycloak:latest
    ports:
      - "80:8080"
    environment:
      - KEYCLOAK_CREATE_ADMIN_USER=true
      - KEYCLOAK_JGROUPS_DISCOVERY_PROTOCOL=JDBC_PING
      - 'KEYCLOAK_JGROUPS_DISCOVERY_PROPERTIES=datasource_jndi_name=>java:jboss/datasources/KeycloakDS, initialize_sql=>"CREATE TABLE IF NOT EXISTS JGROUPSPING ( own_addr varchar(200) NOT NULL, cluster_name varchar(200) NOT NULL, created timestamp default current_timestamp, ping_data BYTEA, constraint PK_JGROUPSPING PRIMARY KEY (own_addr, cluster_name))"'
      - KEYCLOAK_CACHE_OWNERS_COUNT=3
      - KEYCLOAK_AUTH_CACHE_OWNERS_COUNT=3
    depends_on:
      - postgresql
  keycloak-2:
    image: docker.io/bitnami/keycloak:latest
    ports:
      - "81:8080"
    depends_on:
      - postgresql
    environment:
      - KEYCLOAK_JGROUPS_DISCOVERY_PROTOCOL=JDBC_PING
      - 'KEYCLOAK_JGROUPS_DISCOVERY_PROPERTIES=datasource_jndi_name=>java:jboss/datasources/KeycloakDS, initialize_sql=>"CREATE TABLE IF NOT EXISTS JGROUPSPING ( own_addr varchar(200) NOT NULL, cluster_name varchar(200) NOT NULL, created timestamp default current_timestamp, ping_data BYTEA, constraint PK_JGROUPSPING PRIMARY KEY (own_addr, cluster_name))"'
      - KEYCLOAK_CACHE_OWNERS_COUNT=3
      - KEYCLOAK_AUTH_CACHE_OWNERS_COUNT=3
  keycloak-3:
    image: docker.io/bitnami/keycloak:latest
    ports:
      - "82:8080"
    depends_on:
      - postgresql
    environment:
      - KEYCLOAK_JGROUPS_DISCOVERY_PROTOCOL=JDBC_PING
      - 'KEYCLOAK_JGROUPS_DISCOVERY_PROPERTIES=datasource_jndi_name=>java:jboss/datasources/KeycloakDS, initialize_sql=>"CREATE TABLE IF NOT EXISTS JGROUPSPING ( own_addr varchar(200) NOT NULL, cluster_name varchar(200) NOT NULL, created timestamp default current_timestamp, ping_data BYTEA, constraint PK_JGROUPSPING PRIMARY KEY (own_addr, cluster_name))"'
      - KEYCLOAK_CACHE_OWNERS_COUNT=3
      - KEYCLOAK_AUTH_CACHE_OWNERS_COUNT=3
volumes:
  postgresql_data:
    driver: local
```
