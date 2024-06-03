#!/bin/bash

function kubectl() {
    local message="You are trying to delete a namespace. Do you want to proceed? (yes/no): "
    local message1="$(tput setaf 1)Deleting all namespaces is not allowed. Operation cancelled.$(tput sgr0)"
    if [[ "$*" == *"delete namespace"* || "$*" == *"delete ns"* ]]; then
        if [[ "$*" == *"--all"* ]]; then
            echo "$message1"
        else
            read -p "$message" confirm
            if [[ "$confirm" == "yes" ]]; then
                command kubectl "$@"
            else
                echo "Deletion cancelled."
            fi
        fi
    else
        command kubectl "$@"
    fi
}
