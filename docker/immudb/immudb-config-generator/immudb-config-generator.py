import immudb
import os
from immudb import ImmudbClient
import immudb.datatypesv2 as datatypesv2
import urllib.request
Host=os.environ['IMMUDB_HOST']

IUDX_AUTH_FLUSH_THRESHOLD=int(os.environ['IUDX_AUTH_FLUSH_THRESHOLD'])
IUDX_AUTH_SYNC_THRESHOLD=int(os.environ['IUDX_AUTH_SYNC_THRESHOLD'])
IUDX_AUTH_CLEANUP_PERCENTAGE=float(os.environ['IUDX_AUTH_CLEANUP_PERCENTAGE'])

IUDX_CAT_FLUSH_THRESHOLD=int(os.environ['IUDX_CAT_FLUSH_THRESHOLD'])
IUDX_CAT_SYNC_THRESHOLD=int(os.environ['IUDX_CAT_SYNC_THRESHOLD'])
IUDX_CAT_CLEANUP_PERCENTAGE=float(os.environ['IUDX_CAT_CLEANUP_PERCENTAGE'])

IUDX_RS_FLUSH_THRESHOLD=int(os.environ['IUDX_RS_FLUSH_THRESHOLD'])
IUDX_RS_SYNC_THRESHOLD=int(os.environ['IUDX_RS_SYNC_THRESHOLD'])
IUDX_RS_CLEANUP_PERCENTAGE=float(os.environ['IUDX_RS_CLEANUP_PERCENTAGE'])

f = open("/run/secrets/password/admin-password","r")
ADMIN_PASSWORD = f.read()

f = open("/run/secrets/password/auth-password","r")
IUDX_AUTH_PASSWORD = f.read()

f = open("/run/secrets/password/cat-password","r")
IUDX_CAT_PASSWORD = f.read()

f = open("/run/secrets/password/rs-password","r")
IUDX_RS_PASSWORD = f.read()

while True:
    try:
        if urllib.request.urlopen("http://{0}:8080".format(Host)).getcode() == 200:
            break
    except:
        continue

client = ImmudbClient("{0}:3322".format(Host))
client.login("immudb","immudb")

client.changePassword("immudb",ADMIN_PASSWORD,"immudb")
client.login("immudb",ADMIN_PASSWORD)

client.createDatabase("iudxauth")
client.createDatabase("iudxcat")
client.createDatabase("iudxrsorg")

client.createUser("iudx_auth",IUDX_AUTH_PASSWORD,immudb.constants.PERMISSION_RW,"iudxauth")
client.createUser("iudx_cat",IUDX_CAT_PASSWORD,immudb.constants.PERMISSION_RW,"iudxcat")
client.createUser("iudx_rs",IUDX_RS_PASSWORD,immudb.constants.PERMISSION_RW,"iudxrsorg")

client.useDatabase("iudxcat")
client.sqlExec("CREATE TABLE auditingtable(id VARCHAR[128] NOT NULL, userRole VARCHAR[64] NOT NULL,userID VARCHAR[128] NOT NULL,iid VARCHAR[250] NOT NULL,api VARCHAR[128] NOT NULL,method VARCHAR[32] NOT NULL,time INTEGER NOT NULL,iudxID VARCHAR[256] NOT NULL,PRIMARY KEY id);")
client.sqlExec("CREATE INDEX ON auditingtable(userID, iudxID, time, api);")
client.updateDatabaseV2(b"iudxcat", datatypesv2.DatabaseSettingsV2(indexSettings=datatypesv2.IndexSettings( flushThreshold=IUDX_CAT_FLUSH_THRESHOLD, syncThreshold=IUDX_CAT_SYNC_THRESHOLD, cleanupPercentage=IUDX_CAT_CLEANUP_PERCENTAGE),))

client.useDatabase("iudxauth")
client.sqlExec("CREATE TABLE table_auditing(id VARCHAR[128] NOT NULL, body VARCHAR NOT NULL,userid VARCHAR[128] NOT NULL,endpoint VARCHAR[128] NOT NULL,method VARCHAR[32] NOT NULL,time INTEGER NOT NULL,PRIMARY KEY id);")
client.sqlExec("CREATE INDEX ON table_auditing(userid, endpoint, time);")
client.updateDatabaseV2(b"iudxauth", datatypesv2.DatabaseSettingsV2(indexSettings=datatypesv2.IndexSettings( flushThreshold=IUDX_AUTH_FLUSH_THRESHOLD, syncThreshold=IUDX_AUTH_SYNC_THRESHOLD,cleanupPercentage=IUDX_AUTH_CLEANUP_PERCENTAGE),))


client.useDatabase("iudxrsorg")
client.sqlExec("CREATE TABLE rsaudit (id VARCHAR[128] NOT NULL,api VARCHAR[128] NOT NULL,userid VARCHAR[128] NOT NULL,epochtime INTEGER NOT NULL,resourceid VARCHAR[256] NOT NULL,isotime VARCHAR[64] NOT NULL,providerid VARCHAR[128] NOT NULL,size INTEGER, PRIMARY KEY id);")
client.sqlExec("CREATE INDEX ON rsaudit(userid, epochtime, providerid, resourceid);")
client.updateDatabaseV2(b"iudxrsorg", datatypesv2.DatabaseSettingsV2(indexSettings=datatypesv2.IndexSettings(flushThreshold=IUDX_RS_FLUSH_THRESHOLD, syncThreshold=IUDX_RS_SYNC_THRESHOLD, cleanupPercentage=IUDX_RS_CLEANUP_PERCENTAGE),))

print(client.listUsers())
print(client.databaseList())

client.useDatabase("iudxcat")
print(client.listTables())

client.useDatabase("iudxauth")
print(client.listTables())

client.useDatabase("iudxrsorg")
print(client.listTables())
