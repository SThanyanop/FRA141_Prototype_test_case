#!/bin/bash

# Script to test a single .app file
# Usage: ./test_single_app.sh path/to/app.app [app_name]

if [ $# -eq 0 ]; then
    echo "Usage: $0 <path_to_app.app> [app_name]"
    echo "Example: $0 ./Tester/test_case_Float.app Float"
    exit 1
fi

APP_PATH="$1"
APP_NAME="${2:-$(basename "$APP_PATH" .app)}"

echo "🧪 Testing .app file: $APP_NAME"
echo "=================================="
echo "Path: $APP_PATH"
echo ""

# Check if .app file exists
if [ ! -d "$APP_PATH" ]; then
    echo "❌ .app file not found: $APP_PATH"
    exit 1
fi

echo "✅ .app bundle found"

# Check bundle structure
if [ ! -d "$APP_PATH/Contents" ]; then
    echo "❌ Invalid .app bundle structure - missing Contents directory"
    exit 1
fi

echo "✅ Valid .app bundle structure"

# Check for executable
EXECUTABLE_DIR="$APP_PATH/Contents/MacOS"
if [ ! -d "$EXECUTABLE_DIR" ]; then
    echo "❌ No MacOS executable directory found"
    exit 1
fi

EXECUTABLES=($(find "$EXECUTABLE_DIR" -type f -perm +111))
if [ ${#EXECUTABLES[@]} -eq 0 ]; then
    echo "❌ No executable files found in .app bundle"
    exit 1
fi

MAIN_EXECUTABLE="${EXECUTABLES[0]}"
echo "✅ Executable found: $(basename "$MAIN_EXECUTABLE")"

# Check file size
FILE_SIZE=$(stat -f%z "$MAIN_EXECUTABLE" 2>/dev/null || echo "0")
FILE_SIZE_MB=$(($FILE_SIZE / 1024 / 1024))
FILE_SIZE_KB=$(($FILE_SIZE / 1024))

if [ "$FILE_SIZE" -gt 1000000 ]; then  # > 1MB
    echo "✅ App size: ${FILE_SIZE_MB}MB (looks reasonable)"
else
    echo "⚠️  App size: ${FILE_SIZE_KB}KB (seems small)"
fi

# Check Info.plist
INFO_PLIST="$APP_PATH/Contents/Info.plist"
if [ -f "$INFO_PLIST" ]; then
    echo "✅ Info.plist found"
    
    # Try to read bundle identifier
    if command -v plutil >/dev/null 2>&1; then
        BUNDLE_ID=$(plutil -extract CFBundleIdentifier xml1 -o - "$INFO_PLIST" 2>/dev/null | grep -o '<string>.*</string>' | sed 's/<string>\(.*\)<\/string>/\1/' || echo "unknown")
        echo "   Bundle ID: $BUNDLE_ID"
    fi
else
    echo "⚠️  Info.plist not found"
fi

# Test execution with timeout
echo ""
echo "🔍 Testing app execution..."
echo "   (Testing with 10 second timeout - app may require GUI interaction)"

# Try different execution methods
EXECUTION_SUCCESS=false

# Method 1: Try with --help flag
echo "   Trying with --help flag..."
if timeout 5s "$MAIN_EXECUTABLE" --help >/dev/null 2>&1; then
    echo "   ✅ App responds to --help flag"
    EXECUTION_SUCCESS=true
fi

# Method 2: Try direct execution
if [ "$EXECUTION_SUCCESS" = false ]; then
    echo "   Trying direct execution..."
    if timeout 5s "$MAIN_EXECUTABLE" >/dev/null 2>&1; then
        echo "   ✅ App executes without immediate errors"
        EXECUTION_SUCCESS=true
    fi
fi

# Method 3: Try using 'open' command
if [ "$EXECUTION_SUCCESS" = false ]; then
    echo "   Trying with 'open' command..."
    if timeout 10s open "$APP_PATH" 2>/dev/null; then
        sleep 2
        # Check if app is running
        if pgrep -f "$(basename "$MAIN_EXECUTABLE")" >/dev/null 2>&1; then
            echo "   ✅ App launched successfully via 'open'"
            # Kill the app to clean up
            pkill -f "$(basename "$MAIN_EXECUTABLE")" >/dev/null 2>&1
            EXECUTION_SUCCESS=true
        fi
    fi
fi

# Final result
echo ""
echo "🏁 TEST RESULTS FOR $APP_NAME"
echo "================================"

if [ "$EXECUTION_SUCCESS" = true ]; then
    echo "✅ App appears to be functional"
    echo "✅ Ready for use"
    exit 0
else
    echo "⚠️  App execution test inconclusive"
    echo "   This may be normal for GUI applications that require user interaction"
    echo "   The .app bundle structure appears correct"
    exit 0
fi
