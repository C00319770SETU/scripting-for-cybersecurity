#!/bin/bash

read -p "Enter a username to look up: " TARGET_USER
read -p "Enter a department: " DEPARTMENT

echo "Searching for user: $TARGET_USER"
echo "Searching for department: $DEPARTMENT"

grep "$TARGET_USER" intel/users.csv | grep "$DEPARTMENT"

