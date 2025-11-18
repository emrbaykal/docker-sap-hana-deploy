#!/bin/bash
echo "Simple syntax test..."
if bash -n hana_full_report.sh 2>&1; then
    echo "Syntax OK"
else
    echo "Syntax ERROR"
fi