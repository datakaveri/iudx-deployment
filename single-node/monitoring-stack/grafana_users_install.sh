#!/bin/bash
#Requirements : jq, curl tools

apt update > /dev/null 2>&1 &&  apt install jq curl > /dev/null 2>&1 

create_users() {
	url="https://localhost:3000/api/admin/users"
	for ((i = 1; i <= $1; i++)); do
		passwd=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9-_!@#$%^&*()_+{}|:<>?=' | head -c 12)
		json_body=$(echo "{\"name\":\"User$i\",\"email\":\"user$i@datakaveri.org \", \"OrgId\": $2, \"login\":\"user$i\", \"password\":\"$passwd\"}" | jq .)
		response=$(curl -k -s -XPOST -H 'Content-Type: application/json' --user admin:"$admin_passwd" -d "$json_body" "$url")
		if [[ $(echo "$response" | jq .message) == '"User created"' ]]; then
			echo "user$i created with details $json_body" >>secrets.txt
			echo " Grafana user$i is created"
		else
			echo "Grafana user$i not created due to $response"
		fi
	done

}

# update name of  organisation
((org_id = 1))
org_url="https://localhost:3000/api/orgs/$org_id"
org_res=$(curl -k -s -XPUT -H 'Content-Type: application/json' --user admin:"$admin_passwd" -d "$(printf '{"name":"IUDX" }' | jq .)" "$org_url")

# create users
((no_of_users = $1))
create_users "$no_of_users" "$org_id"

# update access roles (by default the added users have viewer roles)
access_url="https://localhost:3000/api/orgs/$org_id/users"
access_res=$(curl -k -s -XPATCH -H 'Content-Type: application/json' --user admin:"$admin_passwd" -d "$(printf '{"role":"Editor" }' | jq .)" "$access_url/2")
if [[ $(echo "$access_res" | jq .message) == '"Organization user updated"' ]]; then

	echo "user 1  has Editor access" >>secrets.txt
else
	echo "user 1 could not be made editor and so  has Viewer access" >>secrets.txt
fi


echo "please find details of users, admin in secrets.txt file"
