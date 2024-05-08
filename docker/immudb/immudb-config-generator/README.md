# Immudb Config generator
Docker image for Immudb config generator init container

This code perform the following tasks:

1. Load configuration settings from a JSON file named "config.json".
2. Check the connection to an immudb server by making an HTTP request to the specified immudb host and port (8080).
3. Login to the immudb server using the default username and password.
4. Change the admin password by reading it from a file specified in the configuration.
5. Login again using the updated admin password.
6. Create databases, tables, and update index settings based on the configurations provided in the "config.json" file.
7. Print a list of tables in each database after creating them.
8. Create users with their respective usernames, passwords (read from files), and assign them read-write permissions to specific databases.


## Build Docker Image
```sh
docker build -t ghcr.io/datakaveri/immudb-config-generator:1.4.0-3 .
```


