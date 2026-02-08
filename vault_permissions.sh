#!/bin/bash

VAULT_DIR="$HOME/secure_vault"

# Checking  vault existence
if [ ! -d "$VAULT_DIR" ]; then
    echo "Error: secure_vault does not exist."
    exit 1
fi

# updating permissions
update_permission() {
    local file="$1"
    local default_perm="$2"

    echo
    ls -l "$VAULT_DIR/$file"
    read -p "Do you want to update permissions for $file? (y/n): " choice

    if [ "$choice" = "y" ]; then
        read -p "Enter new permission (e.g., 600): " perm
        chmod "$perm" "$VAULT_DIR/$file"
    elif [ -z "$choice" ]; then
        chmod "$default_perm" "$VAULT_DIR/$file"
    fi
}

update_permission "keys.txt" 600
update_permission "secrets.txt" 640
update_permission "logs.txt" 644

echo
echo " Final file permissions:"
ls -l "$VAULT_DIR"
