#!/bin/bash

if [ "$#" -ne 1 ] || [ -z "$1" ]; then
    echo "Usage: $0 <file>" >&2
    exit 1
fi

FILE=$1

if [ ! -f "$FILE" ]; then
    echo "Error: '$FILE' is not a regular file."
    exit 2
fi

if [ ! -r "$FILE" ]; then
    echo "Error: '$FILE' is not readable."
    exit 3
fi

if [ ! -s "$FILE" ]; then
    echo "Error: '$FILE' is empty."
    exit 4
fi

echo "$FILE is a readable, non-empty regular file."
exit 0
