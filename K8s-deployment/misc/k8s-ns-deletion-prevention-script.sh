#!/bin/bash

function kubectl() {
    local message="You are trying to delete a namespace. Do you want to proceed? (yes/no): "
    local message1="$(tput setaf 1)You are trying to delete all namespaces. Please type 'delete all namespace' to confirm: $(tput sgr0)"
    if [[ "$*" == *"delete namespace"* || "$*" == *"delete ns"* ]]; then
        if [[ "$*" == *"--all"* ]]; then
            read -p "$message1" confirm
            if [[ "$confirm" == "delete all namespace" ]]; then
                command kubectl "$@"
            else
                echo "Deletion cancelled."
            fi
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
