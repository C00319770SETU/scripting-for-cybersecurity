#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <logfile> <search_term>" >&2
    exit 1
fi

LOGFILE=$1
TERM_ARG=$2

if [ ! -e "$LOGFILE" ]; then
    echo "Error: Log file '$LOGFILE' does not exist." >&2
    exit 2
fi

if [ ! -f "$LOGFILE" ]; then
    echo "Error: '$LOGFILE' is not a regular file." >&2
    exit 3
fi

if [ ! -r "$LOGFILE" ]; then
    echo "Error: '$LOGFILE' is not readable." >&2
    exit 4
fi

if [ -z "$TERM_ARG" ]; then
    echo "Error: Search term cannot be empty." >&2
    exit 5
fi

# Determine if input is an IP Address or Username
if echo "$TERM_ARG" | grep -Eq '^[0-9]+(\.[0-9]+){3}$'; then
    # --- IP ADDRESS PATH ---
    OCCURRENCES=$(grep -cwF "$TERM_ARG" "$LOGFILE")
    
    if [ "$OCCURRENCES" -eq 0 ]; then
        echo "IP $TERM_ARG: Not found in $LOGFILE"
        FOUND=1
    else
        echo "IP $TERM_ARG: Found $OCCURRENCES time(s) in $LOGFILE"
        FOUND=0
    fi

    # Classify Failed Passwords
      FAILS=$(grep -c "Failed password.*$TERM_ARG" "$LOGFILE")
    if [ "$FAILS" -gt 10 ]; then
        echo "  Risk Assessment: HIGH RISK ($FAILS failed login attempts)"
    elif [ "$FAILS" -gt 0 ]; then
        echo "  Risk Assessment: MEDIUM RISK ($FAILS failed login attempts)"
    else
        echo "  Risk Assessment: LOW RISK (0 failed login attempts)"
    fi

    # Check Firewall Log
    if [ -f "case/logs/firewall.log" ]; then
        FW_MATCHES=$(grep -wF "$TERM_ARG" case/logs/firewall.log)
        if [ -n "$FW_MATCHES" ]; then
            echo "  Firewall Log Matches:"
            echo "$FW_MATCHES" | sed 's/^/    /'
        else
            echo "  Firewall Log Matches: None"
        fi
    fi

    # Check IOC List
    if [ -f "intel/iocs.txt" ] && grep -qxF "$TERM_ARG" intel/iocs.txt; then
        echo "  IOC List: MATCHED in intel/iocs.txt"
    else
        echo "  IOC List: Not listed"
    fi

    exit $FOUND

else
    # --- USERNAME PATH ---
    if ! grep -q "for $TERM_ARG " "$LOGFILE"; then
        echo "Username $TERM_ARG: No activity found in $LOGFILE"
        exit 6
    fi

    FAILS=$(grep -c "Failed password for $TERM_ARG " "$LOGFILE")
    ACCEPTS=$(grep -c "Accepted password for $TERM_ARG " "$LOGFILE")

    echo "Username $TERM_ARG Activity in $LOGFILE:"
    echo "  Failed Logins: $FAILS"
    echo "  Accepted Logins: $ACCEPTS"

    # Account Status Check against users.csv
    if [ -f "intel/users.csv" ]; then
        STATUS=$(grep "^$TERM_ARG," intel/users.csv | cut -d',' -f3)
        if [ "$STATUS" = "active" ]; then
            echo "  Account Status: CURRENT"
        elif [ "$STATUS" = "disabled" ] || [ "$STATUS" = "legacy" ]; then
            echo "  Account Status: LEGACY"
        else
            echo "  Account Status: UNKNOWN"
        fi
    fi

    exit 0
fi
