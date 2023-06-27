import immudb
import os
from immudb import ImmudbClient
import immudb.datatypesv2 as datatypesv2
import urllib.request
import json

#Loading Configuration file
with open("config.json") as file:
    config = json.load(file)

# Checking connection using http, wether immudb is up
while True:
    try:
        if urllib.request.urlopen("http://{0}:8080".format(config['immudb_host'])).getcode() == 200:
            break
    except:
        continue

# Login through default passowrd
client = ImmudbClient("{0}:3322".format(config['immudb_host']))
client.login("immudb","immudb")

# Changing the admin passowrd
f = open(config['admin_password'],"r")
ADMIN_PASSWORD = f.read()

client.changePassword("immudb",ADMIN_PASSWORD,"immudb")
client.login("immudb",ADMIN_PASSWORD)

# Creating database, tables and updating index settings
for database in config['database']:
    client.createDatabase(database['database_name'])
    client.useDatabase(database['database_name'])
    client.sqlExec("CREATE TABLE {0};".format(database['table']))
    client.sqlExec("CREATE INDEX ON {0};".format(database['indexing_on']))
    client.updateDatabaseV2("{0}".format(database['database_name']), datatypesv2.DatabaseSettingsV2(indexSettings=datatypesv2.IndexSettings( flushThreshold=database['flush_threshold'], syncThreshold=database['sync_threshold'], cleanupPercentage=database['cleanup_percentage']),))
    print(client.listTables())

# Creating user
for users in config['users']:
    f = open(users['password'],"r")
    PASSWORD = f.read()
    client.createUser( users['username'],PASSWORD,immudb.constants.PERMISSION_RW,users['database_name'])

