#!/bin/bash

# Test script to verify all MacOS build scripts are properly formatted
# This script checks syntax without actually running the builds

echo "Testing MacOS Build Scripts Syntax..."
echo "====================================="

BUILD_SCRIPTS=(
    "Template/PrepQuestion/Build_MacOS.sh"
    "Test_use/Float/PrepFloat/Build_MacOS.sh"
    "Test_use/Integer/PrepInteger/Build_MacOS.sh"
    "Test_use/ListFloat/PrepListFloat/Build_MacOS.sh"
    "Test_use/ListInteger/PrepListInteger/Build_MacOS.sh"
)

SCRIPT_DIR="/Users/worakanlasudee/Documents/GitHub/FRA141_Prototype_test_case"
FAILED_COUNT=0

for script in "${BUILD_SCRIPTS[@]}"; do
    FULL_PATH="$SCRIPT_DIR/$script"
    echo -n "Testing $script... "
    
    if [ ! -f "$FULL_PATH" ]; then
        echo "❌ FILE NOT FOUND"
        ((FAILED_COUNT++))
        continue
    fi
    
    if [ ! -x "$FULL_PATH" ]; then
        echo "❌ NOT EXECUTABLE"
        ((FAILED_COUNT++))
        continue
    fi
    
    # Check bash syntax
    if bash -n "$FULL_PATH" 2>/dev/null; then
        echo "✅ SYNTAX OK"
    else
        echo "❌ SYNTAX ERROR"
        ((FAILED_COUNT++))
    fi
done

echo ""
echo "====================================="
if [ $FAILED_COUNT -eq 0 ]; then
    echo "✅ All build scripts passed syntax checks!"
    exit 0
else
    echo "❌ $FAILED_COUNT build scripts failed checks!"
    exit 1
fi
