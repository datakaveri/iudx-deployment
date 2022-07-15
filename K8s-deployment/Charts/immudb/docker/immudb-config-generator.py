import immudb
from immudb import ImmudbClient
import urllib.request
import os
Host=os.environ['IMMUDB_HOST']
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

client.databaseCreate("iudxauth")
client.databaseCreate("iudxcat")
client.databaseCreate("iudxrsorg")

client.createUser("iudx_auth",IUDX_AUTH_PASSWORD,immudb.constants.PERMISSION_RW,"iudxauth")
client.createUser("iudx_cat",IUDX_CAT_PASSWORD,immudb.constants.PERMISSION_RW,"iudxcat")
client.createUser("iudx_rs",IUDX_RS_PASSWORD,immudb.constants.PERMISSION_RW,"iudxrsorg")

client.databaseUse("iudxcat")
client.sqlExec("CREATE TABLE auditingtable(id VARCHAR[128] NOT NULL, userRole VARCHAR[128] NOT NULL,userID VARCHAR[128] NOT NULL,iid VARCHAR[200] NOT NULL,api VARCHAR[128] NOT NULL,method VARCHAR[128] NOT NULL,time INTEGER NOT NULL,iudxID VARCHAR[200] NOT NULL,PRIMARY KEY id);")

client.databaseUse("iudxauth")
client.sqlExec("CREATE TABLE table_auditing(id VARCHAR[128] NOT NULL, body VARCHAR[200] NOT NULL,userid VARCHAR[128] NOT NULL,endpoint VARCHAR[128] NOT NULL,method VARCHAR[128] NOT NULL,time INTEGER NOT NULL,PRIMARY KEY id);")

client.databaseUse("iudxrsorg")
client.sqlExec("CREATE TABLE rsauditingtable (id VARCHAR[128] NOT NULL, api VARCHAR[128],userid VARCHAR[128],epochtime INTEGER,resourceid VARCHAR[200],isotime VARCHAR[128],providerid VARCHAR[128],size INTEGER,PRIMARY KEY id);")


print(client.listUsers())
print(client.databaseList())

client.databaseUse("iudxcat")
print(client.listTables())

client.databaseUse("iudxauth")
print(client.listTables())

client.databaseUse("iudxrsorg")
print(client.listTables())
