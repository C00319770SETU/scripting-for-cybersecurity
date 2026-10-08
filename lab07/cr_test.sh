#!/bin/bash

VAR=$'admin\r'

VAR=$(echo "$VAR" | tr -d '\r')

echo "[$VAR]"
