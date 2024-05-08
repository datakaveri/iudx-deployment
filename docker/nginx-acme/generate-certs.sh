#!/bin/bash

acme.sh() {
    /home/.acme.sh/acme.sh --config-home '/acme.sh' "$@"
}

# Path to the certs/ directory containing certificates 
certs_directory="/etc/nginx/certs"

# Path to the JSON config file containing hostnames for certificate generation
config_file="/etc/acme.sh/acme-config.json"

# Check if the directory exists
if [ ! -d "$certs_directory" ];
then 
    echo "directory not found: $certs_directory"
    exit 1
fi 

# Check if the config file exists
if [ ! -f "$config_file" ]; 
then
    echo "Configuration file not found."
    exit 1
fi

# Initialize an empty array to store certificates already present in the directory
cert_folders=()
# Iterate over contents of /certs directory
while IFS= read -r -d '' entry; do
    if [ -d "$entry" ];
    then 
        folder_name=$(basename "$entry")
        folder_name=${folder_name##+([[:space]])} # Trim trailing whitespace
        folder_name=${folder_name%%+([[:space]])} # Trim Leading Whitespace
        cert_folders+=("$folder_name")
    fi
done < <(find "$certs_directory" -mindepth 1 -maxdepth 1 -type d -print0)

# Print folder names
echo "---Folders in $certs_directory---"
for folder in "${cert_folders[@]}";
do 
    echo "$folder"
done

# Read and extract domain hostnames from the JSON file
config_hostnames=()
while IFS= read -r hostname;
do
    hostname=${hostname##+([[:space]])} # Trim trailing whitespace
    hostname=${hostname%%+([[:space]])} # Trim Leading Whitespace
    config_hostnames+=("$hostname")
done < <(jq -r '.hostnames[]' "$config_file")

# Print hostnames in config file
echo -e "\n---Hostnames in $config_file---"
for hostname in ${config_hostnames[@]};
do 
    echo "$hostname"
done

# Find the difference between the two sets of hostnames
difference=()
for hostname in "${config_hostnames[@]}";
do
    if ! printf '%s\n' "${cert_folders[@]}" | grep -qx "$hostname";
    then 
        # echo "$folder is not present in config_hostnames array"
        difference+=("$hostname")
    fi
done

if [ "${#difference[@]}" -eq 0 ];
then 
    echo -e "\n\e[1mAll certs are already generated!!\e[0m"
else 
echo -e "\n---Will generate new certs for the following hostnames---"
    for diff in "${difference[@]}";
    do
        echo "$diff"
    done
fi


if [ ! "${#difference[@]}" -eq 0 ];
then 
    #set default CA to letsencrypt
    echo -e "\n---Setting default CA to LetsEncrypt---"
    acme.sh  --set-default-ca  --server letsencrypt

    # Generate new certs
    echo -e "\n---Generating new certs---"

    for hostname in "${difference[@]}"; 
    do
        acme.sh --issue --standalone $1 $(printf " -d %s" "${hostname}")
        # Install generated certs to nginx certs directory
        mkdir /etc/nginx/certs/$hostname
        acme.sh --install-cert -d $hostname --key-file /etc/nginx/certs/$hostname/key.pem --fullchain-file /etc/nginx/certs/$hostname/cert.pem --reloadcmd 'nginx -s reload'
    done
fi