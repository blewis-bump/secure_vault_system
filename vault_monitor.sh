#!/bin/bash

VAULT_DIR="$HOME/secure_vault"
REPORT="vault_report.txt"
LOGS="$VAULT_DIR/logs.txt"

echo "Secure Vault Security Report" > "$REPORT"
echo "Generated on: $(date)" >> "$REPORT"
echo "------------------" >> "$REPORT"

# Check vault existence
if [ ! -d "$VAULT_DIR" ]; then
    echo " secure_vault directory missing!" | tee -a "$REPORT"
    exit 1
fi

echo " secure_vault directory exists" >> "$REPORT"
echo >> "$REPORT"

# Expected permissions
declare -A expected_perms
expected_perms[keys.txt]=600
expected_perms[secrets.txt]=640
expected_perms[logs.txt]=644

# Check each file
for file in "${!expected_perms[@]}"; do
    FILE_PATH="$VAULT_DIR/$file"

    if [ -f "$FILE_PATH" ]; then
        current_perm=$(stat -c "%a" "$FILE_PATH")
        expected_perm=${expected_perms[$file]}

        echo "$file permissions: $current_perm" >> "$REPORT"

        if [ "$current_perm" != "$expected_perm" ]; then
            echo " WARNING: $file permissions are insecure (expected $expected_perm)" >> "$REPORT"
            echo "$(date): Insecure permission detected on $file" >> "$LOGS"
        else
            echo " Permissions OK" >> "$REPORT"
        fi
        echo >> "$REPORT"
    else
        echo " $file is missing!" >> "$REPORT"
    fi
done

echo "Security scan completed." >> "$REPORT"
echo " Vault monitoring finished. Report generated."
