#!/bin/bash

# Script to check if all requirements are met for building .app files

echo "🔍 Checking requirements for building .app files"
echo "================================================"

REQUIREMENTS_MET=true

# Check Python
echo "1. Checking Python installation..."
if command -v python3 >/dev/null 2>&1; then
    PYTHON_VERSION=$(python3 --version 2>&1)
    echo "   ✅ Python found: $PYTHON_VERSION"
elif command -v python >/dev/null 2>&1; then
    PYTHON_VERSION=$(python --version 2>&1)
    echo "   ✅ Python found: $PYTHON_VERSION"
else
    echo "   ❌ Python not found"
    REQUIREMENTS_MET=false
fi

# Check PyInstaller
echo "2. Checking PyInstaller installation..."
if command -v pyinstaller >/dev/null 2>&1; then
    PYINSTALLER_VERSION=$(pyinstaller --version 2>&1)
    echo "   ✅ PyInstaller found: $PYINSTALLER_VERSION"
else
    echo "   ❌ PyInstaller not found"
    echo "   💡 Install with: pip install pyinstaller"
    REQUIREMENTS_MET=false
fi

# Check pip
echo "3. Checking pip installation..."
if command -v pip3 >/dev/null 2>&1; then
    echo "   ✅ pip3 found"
elif command -v pip >/dev/null 2>&1; then
    echo "   ✅ pip found"
else
    echo "   ❌ pip not found"
    REQUIREMENTS_MET=false
fi

# Check if we can write to directories
echo "4. Checking directory permissions..."
TEST_DIRS=(
    "Template/PrepQuestion"
    "Test_use/Float/PrepFloat"
    "Test_use/Integer/PrepInteger"
    "Test_use/ListFloat/PrepListFloat"
    "Test_use/ListInteger/PrepListInteger"
)

BASE_DIR="/Users/worakanlasudee/Documents/GitHub/FRA141_Prototype_test_case"
for dir in "${TEST_DIRS[@]}"; do
    if [ -d "$BASE_DIR/$dir" ]; then
        if [ -w "$BASE_DIR/$dir" ]; then
            echo "   ✅ $dir - writable"
        else
            echo "   ❌ $dir - not writable"
            REQUIREMENTS_MET=false
        fi
    else
        echo "   ❌ $dir - directory not found"
        REQUIREMENTS_MET=false
    fi
done

# Check available disk space
echo "5. Checking available disk space..."
AVAILABLE_SPACE=$(df -h "$BASE_DIR" | awk 'NR==2 {print $4}')
echo "   Available space: $AVAILABLE_SPACE"

# Summary
echo ""
echo "🏁 REQUIREMENTS SUMMARY"
echo "======================"

if [ "$REQUIREMENTS_MET" = true ]; then
    echo "✅ All requirements met!"
    echo "🚀 Ready to build .app files"
    echo ""
    echo "To build all .app files, run:"
    echo "   ./MacTesting/build_and_test_all_apps.sh"
    echo ""
    echo "To test a single .app file, run:"
    echo "   ./MacTesting/test_single_app.sh path/to/app.app"
    exit 0
else
    echo "❌ Some requirements are missing"
    echo "Please fix the issues above before building .app files"
    echo ""
    echo "Common fixes:"
    echo "- Install PyInstaller: pip install pyinstaller"
    echo "- Install Python if missing"
    echo "- Fix directory permissions if needed"
    exit 1
fi
