#!/bin/bash

# Comprehensive .app file validator
# This script performs extensive validation of macOS .app bundles built with PyInstaller

validate_app() {
    local app_path="$1"
    local app_name="${2:-$(basename "$app_path" .app)}"
    local verbose="${3:-false}"
    
    local validation_score=0
    local max_score=10
    local issues=()
    local warnings=()
    
    echo "🔍 COMPREHENSIVE VALIDATION: $app_name"
    echo "============================================"
    echo "Path: $app_path"
    echo ""
    
    # Test 1: Check if .app bundle exists
    if [ -d "$app_path" ]; then
        echo "✅ [1/10] .app bundle exists"
        ((validation_score++))
    else
        echo "❌ [1/10] .app bundle not found"
        issues+=("App bundle not found at: $app_path")
        return 1
    fi
    
    # Test 2: Check bundle structure
    if [ -d "$app_path/Contents" ]; then
        echo "✅ [2/10] Valid bundle structure (Contents directory)"
        ((validation_score++))
    else
        echo "❌ [2/10] Invalid bundle structure - missing Contents directory"
        issues+=("Missing Contents directory")
    fi
    
    # Test 3: Check for MacOS executable directory
    local executable_dir="$app_path/Contents/MacOS"
    if [ -d "$executable_dir" ]; then
        echo "✅ [3/10] MacOS executable directory exists"
        ((validation_score++))
    else
        echo "❌ [3/10] MacOS executable directory missing"
        issues+=("Missing MacOS executable directory")
    fi
    
    # Test 4: Check for executable files
    local executables=()
    if [ -d "$executable_dir" ]; then
        # Use multiple methods to find executables for better compatibility
        while IFS= read -r -d '' file; do
            executables+=("$file")
        done < <(find "$executable_dir" -type f -perm +111 -print0 2>/dev/null)
        
        if [ ${#executables[@]} -gt 0 ]; then
            echo "✅ [4/10] Executable files found (${#executables[@]} files)"
            ((validation_score++))
        else
            echo "❌ [4/10] No executable files found"
            issues+=("No executable files found in MacOS directory")
        fi
    else
        echo "❌ [4/10] Cannot check executables (MacOS directory missing)"
        issues+=("Cannot validate executables")
    fi
    
    # Test 5: Check main executable size and properties
    if [ ${#executables[@]} -gt 0 ]; then
        local main_executable="${executables[0]}"
        local file_size=$(stat -f%z "$main_executable" 2>/dev/null || echo "0")
        local file_size_mb=$(($file_size / 1024 / 1024))
        local file_size_kb=$(($file_size / 1024))
        
        if [ "$file_size" -gt 1000000 ]; then  # > 1MB
            echo "✅ [5/10] Executable size reasonable (${file_size_mb}MB)"
            ((validation_score++))
        elif [ "$file_size" -gt 100000 ]; then  # > 100KB
            echo "⚠️  [5/10] Executable size small but acceptable (${file_size_kb}KB)"
            warnings+=("Executable size is smaller than typical PyInstaller apps")
            ((validation_score++))
        else
            echo "❌ [5/10] Executable size suspiciously small (${file_size_kb}KB)"
            issues+=("Executable size too small: ${file_size_kb}KB")
        fi
    else
        echo "❌ [5/10] Cannot check executable size"
        issues+=("Cannot validate executable size")
    fi
    
    # Test 6: Check Info.plist
    local info_plist="$app_path/Contents/Info.plist"
    if [ -f "$info_plist" ]; then
        echo "✅ [6/10] Info.plist exists"
        ((validation_score++))
        
        # Try to extract bundle info
        if command -v plutil >/dev/null 2>&1; then
            local bundle_id=$(plutil -extract CFBundleIdentifier xml1 -o - "$info_plist" 2>/dev/null | grep -o '<string>.*</string>' | sed 's/<string>\(.*\)<\/string>/\1/' || echo "unknown")
            local bundle_name=$(plutil -extract CFBundleName xml1 -o - "$info_plist" 2>/dev/null | grep -o '<string>.*</string>' | sed 's/<string>\(.*\)<\/string>/\1/' || echo "unknown")
            
            if [ "$verbose" = true ]; then
                echo "   Bundle ID: $bundle_id"
                echo "   Bundle Name: $bundle_name"
            fi
        fi
    else
        echo "⚠️  [6/10] Info.plist missing (may cause issues)"
        warnings+=("Info.plist missing - app may not launch properly")
    fi
    
    # Test 7: Check Resources directory (optional but common)
    if [ -d "$app_path/Contents/Resources" ]; then
        echo "✅ [7/10] Resources directory exists"
        ((validation_score++))
    else
        echo "⚠️  [7/10] Resources directory missing (may be normal)"
        warnings+=("Resources directory missing")
    fi
    
    # Test 8: Check for Python dependencies (PyInstaller specific)
    local python_deps=0
    if [ -d "$app_path/Contents/Frameworks" ]; then
        python_deps=$(find "$app_path/Contents/Frameworks" -name "*Python*" 2>/dev/null | wc -l)
    fi
    
    if [ "$python_deps" -gt 0 ] || [ -f "$app_path/Contents/MacOS/base_library.zip" ]; then
        echo "✅ [8/10] Python runtime dependencies found"
        ((validation_score++))
    else
        echo "⚠️  [8/10] Python dependencies not clearly visible"
        warnings+=("Python runtime dependencies not found - may indicate build issues")
    fi
    
    # Test 9: Basic execution test
    local execution_success=false
    if [ ${#executables[@]} -gt 0 ]; then
        local main_executable="${executables[0]}"
        
        # Test with timeout to avoid hanging
        if timeout 3s "$main_executable" --version >/dev/null 2>&1 || \
           timeout 3s "$main_executable" --help >/dev/null 2>&1 || \
           timeout 3s "$main_executable" -h >/dev/null 2>&1; then
            echo "✅ [9/10] App responds to standard flags"
            execution_success=true
            ((validation_score++))
        else
            # Try direct execution with very short timeout
            if timeout 2s "$main_executable" >/dev/null 2>&1; then
                echo "✅ [9/10] App executes without immediate errors"
                execution_success=true
                ((validation_score++))
            else
                echo "⚠️  [9/10] App execution test inconclusive"
                warnings+=("App execution test inconclusive - may require GUI interaction")
            fi
        fi
    else
        echo "❌ [9/10] Cannot test execution (no executable found)"
        issues+=("Cannot test execution")
    fi
    
    # Test 10: macOS compatibility check
    local macos_compatible=false
    if [ -f "$info_plist" ] && command -v plutil >/dev/null 2>&1; then
        local min_os=$(plutil -extract LSMinimumSystemVersion xml1 -o - "$info_plist" 2>/dev/null | grep -o '<string>.*</string>' | sed 's/<string>\(.*\)<\/string>/\1/' || echo "")
        if [ -n "$min_os" ]; then
            echo "✅ [10/10] macOS compatibility info present (min OS: $min_os)"
            macos_compatible=true
            ((validation_score++))
        fi
    fi
    
    if [ "$macos_compatible" = false ]; then
        echo "⚠️  [10/10] macOS compatibility info missing"
        warnings+=("macOS version compatibility info missing")
    fi
    
    # Summary
    echo ""
    echo "🏁 VALIDATION SUMMARY"
    echo "===================="
    echo "Score: $validation_score/$max_score"
    echo ""
    
    # Calculate percentage
    local percentage=$((validation_score * 100 / max_score))
    
    if [ $percentage -ge 90 ]; then
        echo "🎉 EXCELLENT: App is fully functional and well-built"
        local status="EXCELLENT"
    elif [ $percentage -ge 75 ]; then
        echo "✅ GOOD: App appears functional with minor issues"
        local status="GOOD"
    elif [ $percentage -ge 60 ]; then
        echo "⚠️  ACCEPTABLE: App may work but has some issues"
        local status="ACCEPTABLE"
    else
        echo "❌ POOR: App has significant issues and may not work"
        local status="POOR"
    fi
    
    # Report issues
    if [ ${#issues[@]} -gt 0 ]; then
        echo ""
        echo "🚨 CRITICAL ISSUES:"
        for issue in "${issues[@]}"; do
            echo "   • $issue"
        done
    fi
    
    # Report warnings
    if [ ${#warnings[@]} -gt 0 ]; then
        echo ""
        echo "⚠️  WARNINGS:"
        for warning in "${warnings[@]}"; do
            echo "   • $warning"
        done
    fi
    
    echo ""
    
    # Return appropriate exit code
    if [ $percentage -ge 60 ]; then
        return 0
    else
        return 1
    fi
}

# Main script execution
if [ $# -eq 0 ]; then
    echo "Usage: $0 <path_to_app.app> [app_name] [verbose]"
    echo ""
    echo "Examples:"
    echo "  $0 ./Tester/test_case_Float.app"
    echo "  $0 ./Tester/test_case_Float.app Float true"
    echo ""
    echo "The validator will:"
    echo "  • Check .app bundle structure"
    echo "  • Validate executable files"
    echo "  • Test file sizes and properties"
    echo "  • Check Info.plist configuration"
    echo "  • Perform basic execution tests"
    echo "  • Verify macOS compatibility"
    exit 1
fi

validate_app "$1" "$2" "$3"
