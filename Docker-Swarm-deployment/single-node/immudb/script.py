import immudb
from immudb import ImmudbClient

f = open("../run/secrets/adminpassword","r")
ADMIN_PASSWORD = f.read()

f = open("../run/secrets/authpassword","r")
IUDX_AUTH_PASSWORD = f.read()

f = open("../run/secrets/catpassword","r")
IUDX_CAT_PASSWORD = f.read()

f = open("../run/secrets/defaultpassword","r")
IUDX_DEFAULT_PASSWORD = f.read()

f = open("../run/secrets/rspassword","r")
IUDX_RS_PASSWORD = f.read()

f = open("../run/secrets/testpassword","r")
IUDX_TEST_PASSWORD = f.read()

client = ImmudbClient("immudb:3322")
client.login("immudb","immudb")

client.changePassword("immudb",ADMIN_PASSWORD,"immudb")
client.login("immudb",ADMIN_PASSWORD)

client.databaseCreate("iudxauth")
client.databaseCreate("iudxcat")
client.databaseCreate("iudxrsorg")
client.databaseCreate("iudxrs")

client.createUser("iudx_auth",IUDX_AUTH_PASSWORD,immudb.constants.PERMISSION_RW,"iudxauth")
client.createUser("iudx_cat",IUDX_CAT_PASSWORD,immudb.constants.PERMISSION_RW,"iudxcat")
client.createUser("iudx_default",IUDX_DEFAULT_PASSWORD,immudb.constants.PERMISSION_RW,"defaultdb")
client.createUser("iudx_rs",IUDX_RS_PASSWORD,immudb.constants.PERMISSION_RW,"iudxrsorg")
client.createUser("test",IUDX_TEST_PASSWORD,immudb.constants.PERMISSION_RW,"iudxrs")

client.databaseUse("iudxcat")
client.sqlExec("CREATE TABLE auditingtable(id VARCHAR NOT NULL, userRole VARCHAR NOT NULL,userID VARCHAR NOT NULL,iid VARCHAR NOT NULL,api VARCHAR NOT NULL,method VARCHAR NOT NULL,time INTEGER NOT NULL,iudxID VARCHAR NOT NULL,PRIMARY KEY id);")

client.databaseUse("iudxauth")
client.sqlExec("CREATE TABLE table_auditing(id VARCHAR NOT NULL, body VARCHAR NOT NULL,userid VARCHAR NOT NULL,endpoint VARCHAR NOT NULL,method VARCHAR NOT NULL,time INTEGER NOT NULL,PRIMARY KEY id);")

client.databaseUse("iudxrs")
client.sqlExec("CREATE TABLE auditing(id VARCHAR NOT NULL, userid VARCHAR NOT NULL,api VARCHAR NOT NULL,resourceid VARCHAR NOT NULL,time INTEGER NOT NULL,PRIMARY KEY id);")