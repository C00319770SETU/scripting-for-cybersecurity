#!/bin/bash

read -p "Enter a username: " USERNAME

if [ -z "$USERNAME" ]; then
    echo "Error: no username entered" >&2
    exit 1
fi

if grep -q "^$USERNAME," intel/users.csv; then
    echo "$USERNAME: CURRENT account"

    LINE=$(grep "^$USERNAME," intel/users.csv)
    ROLE=$(echo "$LINE" | cut -d',' -f3)
    STATUS=$(echo "$LINE" | cut -d',' -f4)

    echo "Role: $ROLE"
    echo "Status: $STATUS"

    ACCOUNT_TYPE="CURRENT"

elif grep -qx "$USERNAME" case/backups/users.old; then
    echo "$USERNAME: LEGACY account (only in the old backup list)"
    ACCOUNT_TYPE="LEGACY"

else
    echo "$USERNAME: UNKNOWN account (in neither list)"
    ACCOUNT_TYPE="UNKNOWN"
fi

FAILED=$(grep -c "Failed password for $USERNAME " case/logs/auth.log)
ACCEPTED=$(grep -c "Accepted password for $USERNAME " case/logs/auth.log)

echo "Failed logins: $FAILED"
echo "Accepted logins: $ACCEPTED"

if [ "$FAILED" -eq 0 ]; then
    echo "Risk: NONE (no failed attempts)"
elif [ "$FAILED" -lt 5 ]; then
    echo "Risk: LOW ($FAILED failed attempts)"
elif [ "$FAILED" -lt 15 ]; then
    echo "Risk: MEDIUM ($FAILED failed attempts)"
else
    echo "Risk: HIGH ($FAILED failed attempts)"
fi

if [ "$ACCOUNT_TYPE" = "CURRENT" ]; then

    if [ "$STATUS" = "disabled" ] && [ "$ACCEPTED" -gt 0 ]; then
        echo "WARNING: disabled current account has accepted login"
    fi

    if [ "$ACCEPTED" -gt 0 ] && grep -q "^$USERNAME:" case/evidence/passwords.txt; then
        echo "WARNING: current account has accepted logins and plaintext credentials are present"
    fi

elif [ "$ACCOUNT_TYPE" = "LEGACY" ] || [ "$ACCOUNT_TYPE" = "UNKNOWN" ]; then

    if [ "$FAILED" -gt 0 ]; then
        echo "WARNING: $ACCOUNT_TYPE account was targeted by failed logins"
    fi

fi

if [ "$ACCOUNT_TYPE" = "CURRENT" ]; then
    exit 0
elif [ "$ACCOUNT_TYPE" = "LEGACY" ]; then
    exit 2
else
    exit 3
fi
