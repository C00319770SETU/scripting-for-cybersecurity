#!/bin/bash

CASE_DIR="case2"
LOG_DIR="$CASE_DIR/logs"
EVIDENCE_DIR="$CASE_DIR/evidence"
ANALYST="analyst"
CASE_REF="CASE-2026-014"

echo "Analyst      : $ANALYST"
echo "Case folder  : $CASE_DIR"
echo "Log folder   : $LOG_DRI"
echo "Evidence     : $EVIDENCE_DIR"
echo ""
echo "Case $CASE_REF is being handled by $ANALYST in the $CASE_DIR directory."
echo ""
echo "Contents of $LOG_DRI:"
ls "$LOG_DRI"
echo ""
echo "Backup file for this case would be: ${CASE_DIR}_backup.tar"

