#!/bin/bash
# Test script syntax
echo "Testing script syntax..."
bash -n ./hana_full_report.sh
if [ $? -eq 0 ]; then
    echo "✓ Syntax check passed!"
    echo "Testing help function..."
    ./hana_full_report.sh --help
else
    echo "✗ Syntax errors found!"
fi