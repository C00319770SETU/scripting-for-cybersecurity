#!/bin/bash

grep -q "sqlmap" case/logs/access.log

echo "hello"

if [ $? -eq 0 ]; then
	echo "Scanning tool activity detected"
else
	echo "No scanning tool activity"
fi
