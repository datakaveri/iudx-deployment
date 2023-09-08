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
client.login(config['immudb_default_user'],config['immudb_default_user_password'])

# Changing the admin passowrd
if config['change_admin_password']:
    f = open(config['admin_password'],"r")
    ADMIN_PASSWORD = f.read()
    client.changePassword(config['immudb_default_user'],ADMIN_PASSWORD,config['immudb_default_user_password'])
    client.login(config['immudb_default_user'],ADMIN_PASSWORD)


# Creating database and use the same for tables
client.createDatabase(config['database'])
client.useDatabase(config['database'])


# Creating tables and updating index settings
for info in config['tables']:
    client.sqlExec("CREATE TABLE {0};".format(info['table']))
    client.sqlExec("CREATE INDEX ON {0};".format(info['indexing_on']))
    client.updateDatabaseV2("{0}".format(config['database']), datatypesv2.DatabaseSettingsV2(indexSettings=datatypesv2.IndexSettings( flushThreshold=info['flush_threshold'], syncThreshold=info['sync_threshold'], cleanupPercentage=info['cleanup_percentage']),))
    print(client.listTables())

# Creating user
for users in config['users']:
    f = open(users['password'],"r")
    PASSWORD = f.read()
    permission = getattr(immudb.constants, f'PERMISSION_{users["permissions"]}')
    client.createUser( users['username'],PASSWORD, permission ,users['database_name'])

