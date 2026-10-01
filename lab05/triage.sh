#!/bin/bash

CASE_DIR="case"
REPORT="triage-report-auto.txt"

read -p "Enter analyst name: " ANALYST
read -p "Enter case reference: " CASE_REF

DATE=$(date)

TOTAL_FILES=$(find "$CASE_DIR" -type f | wc -l)
TOTAL_DIRECTORIES=$(find "$CASE_DIR" -type d | wc -l)
PYTHON_FILES=$(find "$CASE_DIR" -type f -name "*.py" | wc -l)
SHELL_SCRIPTS=$(find "$CASE_DIR" -type f -name "*.sh" | wc -l)
LOG_FILES=$(find "$CASE_DIR" -type f -name "*.log" | wc -l)
CONFIG_FILES=$(find "$CASE_DIR" -type f \( -name "*.conf" -o -name "*.cfg" -o -name "*.ini" \) | wc -l)
EMPTY_FILES=$(find "$CASE_DIR" -type f -empty | wc -l)
ARCHIVES=$(find "$CASE_DIR" -type f \( -name "*.zip" -o -name "*.tar" -o -name "*.gz" -o -name "*.tgz" \) | wc -l)

SCRIPTS=$((PYTHON_FILES + SHELL_SCRIPTS))

echo "LAB 5 TRIAGE REPORT" > "$REPORT"
echo "===================" >> "$REPORT"
echo "Analyst: $ANALYST" >> "$REPORT"
echo "Case Reference: $CASE_REF" >> "$REPORT"
echo "Date: $DATE" >> "$REPORT"
echo "" >> "$REPORT"

echo "Total Files: $TOTAL_FILES" >> "$REPORT"
echo "Total Directories: $TOTAL_DIRECTORIES" >> "$REPORT"
echo "Python Files: $PYTHON_FILES" >> "$REPORT"
echo "Shell Scripts: $SHELL_SCRIPTS" >> "$REPORT"
echo "Log Files: $LOG_FILES" >> "$REPORT"
echo "Configuration Files: $CONFIG_FILES" >> "$REPORT"
echo "Empty Files: $EMPTY_FILES" >> "$REPORT"
echo "Archives: $ARCHIVES" >> "$REPORT"
echo "" >> "$REPORT"

echo "Files containing admin:" >> "$REPORT"
grep -rl "admin" "$CASE_DIR" >> "$REPORT" 2>/dev/null

echo "" >> "$REPORT"
echo "Detected file types:" >> "$REPORT"
file "$CASE_DIR"/evidence/* >> "$REPORT" 2>/dev/null

echo "" >> "$REPORT"
echo "Scripts (Python + shell): $SCRIPTS" >> "$REPORT"
