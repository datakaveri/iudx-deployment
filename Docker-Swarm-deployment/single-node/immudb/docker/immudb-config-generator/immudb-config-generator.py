import immudb
import os
from immudb import ImmudbClient
import urllib.request
Host=os.environ['IMMUDB_HOST']

f = open("/run/secrets/admin-password","r")
ADMIN_PASSWORD = f.read()

f = open("/run/secrets/auth-password","r")
IUDX_AUTH_PASSWORD = f.read()

f = open("/run/secrets/cat-password","r")
IUDX_CAT_PASSWORD = f.read()

f = open("/run/secrets/rs-password","r")
IUDX_RS_PASSWORD = f.read()

while True:
    try:
        if urllib.request.urlopen("http://immudb:8080").getcode() == 200:
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
client.sqlExec("CREATE TABLE auditingtable(id VARCHAR[250] NOT NULL, userRole VARCHAR[250] NOT NULL,userID VARCHAR[250] NOT NULL,iid VARCHAR[250] NOT NULL,api VARCHAR[250] NOT NULL,method VARCHAR[250] NOT NULL,time INTEGER NOT NULL,iudxID VARCHAR[250] NOT NULL,PRIMARY KEY id);")

client.useDatabase("iudxauth")
client.sqlExec("CREATE TABLE table_auditing(id VARCHAR[250] NOT NULL, body VARCHAR[250] NOT NULL,userid VARCHAR[250] NOT NULL,endpoint VARCHAR[250] NOT NULL,method VARCHAR[250] NOT NULL,time INTEGER NOT NULL,PRIMARY KEY id);")

client.useDatabase("iudxrsorg")
client.sqlExec("CREATE TABLE IF NOT EXISTS rsauditingtable (id VARCHAR[128] NOT NULL, api VARCHAR[128], userid VARCHAR[128],epochtime INTEGER,resourceid VARCHAR[256], isotime VARCHAR[64], providerid VARCHAR[128], PRIMARY KEY id);")

client.sqlExec("CREATE INDEX ON rsauditingtable(userid, epochtime, providerid, resourceid);")

client.sqlExec("CREATE TABLE rsaudit (id VARCHAR[128] NOT NULL,api VARCHAR[128] NOT NULL,userid VARCHAR[128] NOT NULL,epochtime INTEGER NOT NULL,resourceid VARCHAR[256] NOT NULL,isotime VARCHAR[64] NOT NULL,providerid VARCHAR[128] NOT NULL,size INTEGER, PRIMARY KEY id);")
client.sqlExec("CREATE INDEX ON rsaudit(userid, epochtime, providerid, resourceid);")



print(client.listUsers())
print(client.databaseList())

client.useDatabase("iudxcat")
print(client.listTables())

client.useDatabase("iudxauth")
print(client.listTables())

client.useDatabase("iudxrsorg")
print(client.listTables())
