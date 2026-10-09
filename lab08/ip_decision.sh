#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <ip_address>" >&2
    exit 1
fi

IP=$1

./check_ip.sh case/logs/firewall.log "$IP" > /dev/null
RESULT=$?

if [ "$RESULT" -eq 0 ]; then
    echo "Decision: $IP is known to the firewall."
    echo "Firewall Entries:"
    grep -wF "$IP" case/logs/firewall.log

elif [ "$RESULT" -eq 3 ]; then
    echo "Decision: the firewall never saw $IP."

else
    echo "Decision: could not complete the check (exit code $RESULT)."
    exit "$RESULT"
fi
