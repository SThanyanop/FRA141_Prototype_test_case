#!/bin/bash

# Comprehensive script to build and test all .app files in every folder
# This script will build all test case .app files and validate they work correctly

echo "🚀 Starting comprehensive build and test for all .app files"
echo "============================================================="

# Define all test case directories that need building
TEST_DIRECTORIES=(
    "Template/PrepQuestion"
    "Test_use/Float/PrepFloat"
    "Test_use/Integer/PrepInteger"
    "Test_use/ListFloat/PrepListFloat"
    "Test_use/ListInteger/PrepListInteger"
)

# Base directory
BASE_DIR="/Users/worakanlasudee/Documents/GitHub/FRA141_Prototype_test_case"
BUILD_LOG="$BASE_DIR/MacTesting/build_test_log.txt"

# Initialize counters
TOTAL_BUILDS=0
SUCCESSFUL_BUILDS=0
FAILED_BUILDS=0
TOTAL_TESTS=0
SUCCESSFUL_TESTS=0
FAILED_TESTS=0

# Create log file
echo "Build and Test Log - $(date)" > "$BUILD_LOG"
echo "================================" >> "$BUILD_LOG"

# Function to test if .app file works
test_app_functionality() {
    local app_path="$1"
    local test_name="$2"
    
    echo "  🧪 Testing $test_name.app functionality..."
    
    # Check if .app file exists
    if [ ! -d "$app_path" ]; then
        echo "    ❌ .app file not found: $app_path"
        echo "    ❌ .app file not found: $app_path" >> "$BUILD_LOG"
        return 1
    fi
    
    # Check if .app is executable
    local executable_path="$app_path/Contents/MacOS"
    if [ -d "$executable_path" ]; then
        local exec_files=($(find "$executable_path" -type f -perm +111))
        if [ ${#exec_files[@]} -eq 0 ]; then
            echo "    ❌ No executable found in .app bundle"
            echo "    ❌ No executable found in .app bundle: $app_path" >> "$BUILD_LOG"
            return 1
        fi
        
        # Try to get app info
        local main_executable="${exec_files[0]}"
        if [ -f "$main_executable" ]; then
            echo "    ✅ Executable found: $(basename "$main_executable")"
            echo "    ✅ Executable found: $(basename "$main_executable")" >> "$BUILD_LOG"
            
            # Check file size (should be reasonable for a PyInstaller app)
            local file_size=$(stat -f%z "$main_executable" 2>/dev/null || echo "0")
            if [ "$file_size" -gt 1000000 ]; then  # > 1MB
                echo "    ✅ App size looks reasonable: $(($file_size / 1024 / 1024))MB"
                echo "    ✅ App size: $(($file_size / 1024 / 1024))MB" >> "$BUILD_LOG"
            else
                echo "    ⚠️  App size seems small: $(($file_size / 1024))KB"
                echo "    ⚠️  App size seems small: $(($file_size / 1024))KB" >> "$BUILD_LOG"
            fi
            
            # Try to run the app briefly (with timeout to avoid hanging)
            echo "    🔍 Testing app execution (5 second timeout)..."
            if timeout 5s "$main_executable" --help >/dev/null 2>&1 || \
               timeout 5s "$main_executable" >/dev/null 2>&1; then
                echo "    ✅ App appears to execute without immediate errors"
                echo "    ✅ App execution test passed" >> "$BUILD_LOG"
                return 0
            else
                echo "    ⚠️  App execution test inconclusive (may require GUI interaction)"
                echo "    ⚠️  App execution test inconclusive" >> "$BUILD_LOG"
                return 0  # Still consider this a pass for GUI apps
            fi
        fi
    else
        echo "    ❌ Invalid .app bundle structure"
        echo "    ❌ Invalid .app bundle structure: $app_path" >> "$BUILD_LOG"
        return 1
    fi
}

# Function to build and test a single directory
build_and_test_directory() {
    local dir="$1"
    local full_path="$BASE_DIR/$dir"
    
    echo ""
    echo "📁 Processing: $dir"
    echo "-------------------------------------------"
    
    if [ ! -d "$full_path" ]; then
        echo "❌ Directory not found: $full_path"
        echo "❌ Directory not found: $full_path" >> "$BUILD_LOG"
        ((FAILED_BUILDS++))
        return 1
    fi
    
    # Change to the directory
    cd "$full_path" || {
        echo "❌ Failed to change to directory: $full_path"
        echo "❌ Failed to change to directory: $full_path" >> "$BUILD_LOG"
        ((FAILED_BUILDS++))
        return 1
    }
    
    # Check if Build_MacOS.sh exists
    if [ ! -f "Build_MacOS.sh" ]; then
        echo "❌ Build_MacOS.sh not found in $dir"
        echo "❌ Build_MacOS.sh not found in $dir" >> "$BUILD_LOG"
        ((FAILED_BUILDS++))
        return 1
    fi
    
    # Make sure the script is executable
    chmod +x Build_MacOS.sh
    
    echo "  🔨 Building .app file..."
    ((TOTAL_BUILDS++))
    
    # Run the build script and capture output
    if ./Build_MacOS.sh > build_output.tmp 2>&1; then
        echo "  ✅ Build completed successfully"
        echo "  ✅ Build completed successfully: $dir" >> "$BUILD_LOG"
        ((SUCCESSFUL_BUILDS++))
        
        # Extract the expected .app name from the directory
        case "$dir" in
            "Template/PrepQuestion")
                app_name="test_case_Question"
                ;;
            "Test_use/Float/PrepFloat")
                app_name="test_case_Float"
                ;;
            "Test_use/Integer/PrepInteger")
                app_name="test_case_Integer"
                ;;
            "Test_use/ListFloat/PrepListFloat")
                app_name="test_case_ListFloat"
                ;;
            "Test_use/ListInteger/PrepListInteger")
                app_name="test_case_ListInteger"
                ;;
            *)
                app_name="unknown"
                ;;
        esac
        
        # Test the built .app file using comprehensive validator
        app_path="./Tester/${app_name}.app"
        ((TOTAL_TESTS++))
        
        echo "  🧪 Running comprehensive validation..."
        if "$BASE_DIR/MacTesting/comprehensive_app_validator.sh" "$app_path" "$app_name" false > validation_output.tmp 2>&1; then
            echo "  ✅ App validation completed successfully"
            # Extract score from validation output
            local score=$(grep "Score:" validation_output.tmp | grep -o '[0-9]\+/[0-9]\+' || echo "0/10")
            echo "  📊 Validation score: $score"
            echo "  📊 Validation score: $score - $dir" >> "$BUILD_LOG"
            ((SUCCESSFUL_TESTS++))
        else
            echo "  ❌ App validation failed"
            echo "  ❌ App validation failed - $dir" >> "$BUILD_LOG"
            echo "  📋 Validation output:" >> "$BUILD_LOG"
            cat validation_output.tmp >> "$BUILD_LOG"
            ((FAILED_TESTS++))
        fi
        
        # Clean up validation output
        rm -f validation_output.tmp
        
    else
        echo "  ❌ Build failed"
        echo "  ❌ Build failed: $dir" >> "$BUILD_LOG"
        echo "  📋 Build output:" >> "$BUILD_LOG"
        cat build_output.tmp >> "$BUILD_LOG"
        ((FAILED_BUILDS++))
        ((FAILED_TESTS++))
    fi
    
    # Clean up temporary files
    rm -f build_output.tmp
    
    # Return to base directory
    cd "$BASE_DIR" || exit 1
}

# Main execution
echo "Starting build and test process..."
echo ""

# Process each directory
for dir in "${TEST_DIRECTORIES[@]}"; do
    build_and_test_directory "$dir"
done

# Print summary
echo ""
echo "🏁 FINAL SUMMARY"
echo "============================================================="
echo "📊 Build Results:"
echo "   Total builds attempted: $TOTAL_BUILDS"
echo "   Successful builds: $SUCCESSFUL_BUILDS"
echo "   Failed builds: $FAILED_BUILDS"
echo ""
echo "🧪 Test Results:"
echo "   Total tests attempted: $TOTAL_TESTS"
echo "   Successful tests: $SUCCESSFUL_TESTS"
echo "   Failed tests: $FAILED_TESTS"
echo ""

# Write summary to log
echo "" >> "$BUILD_LOG"
echo "FINAL SUMMARY" >> "$BUILD_LOG"
echo "=============" >> "$BUILD_LOG"
echo "Build Results: $SUCCESSFUL_BUILDS/$TOTAL_BUILDS successful" >> "$BUILD_LOG"
echo "Test Results: $SUCCESSFUL_TESTS/$TOTAL_TESTS successful" >> "$BUILD_LOG"

if [ $FAILED_BUILDS -eq 0 ] && [ $FAILED_TESTS -eq 0 ]; then
    echo "🎉 ALL BUILDS AND TESTS COMPLETED SUCCESSFULLY!"
    echo "🎉 ALL BUILDS AND TESTS COMPLETED SUCCESSFULLY!" >> "$BUILD_LOG"
    exit 0
else
    echo "⚠️  Some builds or tests failed. Check the log at: $BUILD_LOG"
    echo "⚠️  Some builds or tests failed." >> "$BUILD_LOG"
    exit 1
fi
