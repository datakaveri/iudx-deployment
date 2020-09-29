#!/bin/bash
#Requirements : jq, curl tools

apt update && apt install -y --no-install-recommends jq curl &> /dev/null 
adduser_url="https://tasks.grafana:3000/api/admin/users"
access_url="https://tasks.grafana:3000/api/orgs/$org_id/users"
org_url="https://tasks.grafana:3000/api/orgs/$org_id"
org_id=1
passwd_path="/secrets/passwords"
admin_username="iudx_super_admin"
admin_passwd=`cat $passwd_path/grafana-super-admin-passwd`
update_org() {
	org_name=$1
	json_body=$(printf "{\"name\":\"$org_name\"}" | jq .)
	org_res=`curl -k -s -XPUT -H 'Content-Type: application/json' --user "$admin_username":"$admin_passwd" -d "$json_body" "$org_url"`
	if [[ $(echo "$org_res" | jq .message) == '"Organization updated"' ]]; then
		echo "Grafana org updated with $org_name"
	else
		echo "error in updation of orgranisation due to $org_res"
	fi
}

create_user() {
		username="$1"
		role="$2"
		user_no="$3"
		passwd=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9-_!@#$%^&*()_+{}|:<>?=' | head -c 12)
		json_body=`echo "{\"name\":\"$username\",\"email\":\"$username@datakaveri.org\",\"OrgId\": $org_id,\"login\":\"$username\",\"password\":\"$passwd\"}" | jq .`
		response=`curl -k -XPOST -H 'Content-Type: application/json' --user "$admin_username":"$admin_passwd" -d "$json_body" "$adduser_url"`
		if [[ `echo "$response" | jq .message` == "\"User created\"" ]]; then
			echo "$username created with details $json_body" >> $passwd_path/secrets.txt
			echo " Grafana $username is created"
		else
			echo "Grafana $username not created due to $response"
		fi
		json_body=$(printf "{\"role\":\"$role\"}" | jq .)
		access_res=`curl -k  -XPATCH -H 'Content-Type: application/json' --user "$admin_username":"$admin_passwd" -d "$json_body" "$access_url/$user_no"`
		if [[ `echo "$access_res" | jq .message` == "\"Organization user updated\"" ]]; then
			echo "$username updated with $role" >> $passwd_path/secrets.txt
		else	
			echo "error in updating role of user $username "
		fi
}

# update name of  organisation
org_name="IUDX"
update_org  "$org_name"
# create users with roles
create_user "iudx_admin" "Admin"  "2"	
create_user "iudx_editor" "Editor"  "3"
create_user "iudx_viewer" "Viewer"  "4"
# update access roles (by default the added users have viewer roles)
echo "please find details of users, admin in grafana/secrets/passwords/secrets.txt file"
