#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <logfile>" >&2
    exit 1
fi

LOGFILE=$1

if [ ! -f "$LOGFILE" ]; then
    echo "Error: '$LOGFILE' does not exist" >&2
    exit 2
fi

FAILED=$(grep -c "Failed password" "$LOGFILE")

echo "Log file: $LOGFILE"
echo "Failed password events: $FAILED"

echo "Top attacker:"
grep "Failed password" "$LOGFILE" |
    awk '{for(i=1;i<=NF;i++) if($i=="from") print $(i+1)}' |
    sort | uniq -c | sort -nr | head -n 1

echo "Top 3 attackers:"
grep "Failed password" "$LOGFILE" |
    awk '{for(i=1;i<=NF;i++) if($i=="from") print $(i+1)}' |
    sort | uniq -c | sort -nr | head -n 3

echo "Top 3 targeted usernames:"
grep "Failed password" "$LOGFILE" |
    awk '{for(i=1;i<=NF;i++) if($i=="for") print $(i+1)}' |
    sort | uniq -c | sort -nr | head -n 3

exit 0
