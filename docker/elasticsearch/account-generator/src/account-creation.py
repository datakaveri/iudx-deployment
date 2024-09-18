import json
import requests

# Load configuration from config.json
with open('config.json') as config_file:
    config = json.load(config_file)

ELASTICSEARCH_HOST = config["elasticsearch_host"]
elastic_username = config["elastic_username"]
elastic_password_path = config["elastic_password_path"]
clustered = config["clustered"]
change_password_users = config["change_password_users"]
roles = config["roles"]
users = config["users"]
remove_users = config["remove_users"]

# Load Elasticsearch password from file
with open(elastic_password_path) as password_file:
    elastic_password = password_file.read().strip()


def change_password(username, password):
    url = f"{ELASTICSEARCH_HOST}/_security/user/{username}/_password?pretty"
    headers = {'Content-Type': 'application/json'}
    auth = (elastic_username, elastic_password)
    data = {"password": password}
    response = requests.post(url, headers=headers, auth=auth, json=data)
    response.raise_for_status()


def remove_user(username):
    url = f"{ELASTICSEARCH_HOST}/_security/user/{username}"
    auth = (elastic_username, elastic_password)
    response = requests.delete(url, auth=auth)
    response.raise_for_status()


def create_simple_role(role_name, privileges, indices, cluster):
    data = {
        "cluster": cluster,
        "indices": [{"names": indices, "privileges": privileges}]
    }
    url = f"{ELASTICSEARCH_HOST}/_security/role/{role_name}"
    headers = {'Content-Type': 'application/json'}
    auth = (elastic_username, elastic_password)
    response = requests.put(url, headers=headers, auth=auth, json=data)
    response.raise_for_status()
    print(f"Role '{role_name}' created successfully.")

def create_simple_role(role_name, privileges, indices, cluster):
    url = f"{ELASTICSEARCH_HOST}/_security/role/{role_name}"
    headers = {'Content-Type': 'application/json'}
    auth = (elastic_username, elastic_password)
    role_data = {
        "cluster": cluster,
        "indices": [{
            "names": indices,
            "privileges": privileges
        }]
    }
    response = requests.put(url, headers=headers, auth=auth, data=json.dumps(role_data))
    response.raise_for_status()
    print(f"Role '{role_name}' created successfully.")


def create_user(username, password, roles):
    data = {
        "password": password,
        "roles": roles
    }
    url = f"{ELASTICSEARCH_HOST}/_security/user/{username}"
    headers = {'Content-Type': 'application/json'}
    auth = (elastic_username, elastic_password)
    response = requests.post(url, headers=headers, auth=auth, json=data)
    response.raise_for_status()


# Wait for Elasticsearch cluster to become ready

while True:
    print('Waiting for Elasticsearch cluster to become ready')
    response = requests.get(f"{ELASTICSEARCH_HOST}/_cluster/health?wait_for_status=green&timeout=1s",
                            auth=(elastic_username, elastic_password))
    if response.status_code == 200:
        break
    else:
        print('Cluster not ready, waiting 10 seconds...')
        time.sleep(10)

print('Updating system-user passwords')
for user in change_password_users:
    username = user["username"]
    password_path = user["password_path"]
    with open(password_path) as password_file:
        password = password_file.read().strip()
    change_password(username, password)
    print("user ", username ,"password changed")

print('Creating roles')
for role in roles:
    role_name = role["name"]
    privileges = role["privileges"]
    indices = role["indices"]
    cluster = role.get("cluster", []) if clustered else []
    create_simple_role(role_name, privileges, indices, cluster)
    print("role ", role_name ,"created")

print('Creating users')
for user in users:
    username = user["username"]
    password_path = user["password_path"]
    with open(password_path) as password_file:
        password = password_file.read().strip()
    roles = user["roles"]
    print("user ", username ,"created")

print('Removing users')
for username in remove_users:
    remove_user(username)
    print("user ", username ,"removed")
print('Script execution completed.')
