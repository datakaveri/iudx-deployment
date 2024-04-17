Data stored in immudb is secure, cannot be altered
or overwritten and mainly used for Auditing in Data Exchange Servers.
Immuclient is used to interact with Immudb database.
<br>
<br>
Link to official documentation for immudb : https://docs.immudb.io/master/

Link to immuclient : https://docs.immudb.io/master/connecting/clitools.html#immuclient

## Steps to setup Immudb

1. Download latest immuclient from GitHub releases
with respect to the corresponding operating system, architecture
Please find the link to the immuclient binaries  : [here](https://docs.immudb.io/master/)
2. Execute the following command to make the binary executable
```
mv <name-of-immudb-binary> immuclient
chmod +x  immuclient
sudo mv immuclient /usr/local/bin/
```
3. Execute the following command to connect with immudb
```
# login with immuclient and enter password on the prompt
immuclient -a <host> -p 3322 login immudb

## Then going forward once the session is created , can do following commands

# Will connect to immudb on the same session 
immuclient -a <host> -p 3322

# Switch to different db
use <db-name>

# list tables 
tables

# describe tables for schema
describe <table-name> 

# For SQL query 
query <sql-statement>
query SELECT * from auditing_acl_apd LIMIT 1;

# For executing a SQL <sql-query>
exec <sql-query>
exec CREATE TABLE dummy_table(id VARCHAR[256] NOT NULL,user_id VARCHAR NOT NULL,PRIMARY KEY id);

# to get list of commands with
help

# to quit
quit
```
