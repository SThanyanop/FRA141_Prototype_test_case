#!/bin/bash

# Script to validate all existing .app files in the project
# This is useful for testing .app files that have already been built

echo "🔍 VALIDATING ALL EXISTING .APP FILES"
echo "======================================"

BASE_DIR="/Users/worakanlasudee/Documents/GitHub/FRA141_Prototype_test_case"
VALIDATOR="$BASE_DIR/MacTesting/comprehensive_app_validator.sh"

# Find all .app files in the project
APP_FILES=($(find "$BASE_DIR" -name "*.app" -type d 2>/dev/null))

if [ ${#APP_FILES[@]} -eq 0 ]; then
    echo "❌ No .app files found in the project"
    echo ""
    echo "To build .app files, run:"
    echo "   ./MacTesting/build_and_test_all_apps.sh"
    exit 1
fi

echo "Found ${#APP_FILES[@]} .app file(s) to validate:"
for app in "${APP_FILES[@]}"; do
    echo "  • $(basename "$app")"
done
echo ""

# Validation counters
TOTAL_VALIDATIONS=0
SUCCESSFUL_VALIDATIONS=0
FAILED_VALIDATIONS=0

# Summary arrays
declare -a VALIDATION_RESULTS
declare -a VALIDATION_SCORES

# Validate each .app file
for app_path in "${APP_FILES[@]}"; do
    app_name=$(basename "$app_path" .app)
    relative_path=${app_path#$BASE_DIR/}
    
    echo "🧪 Validating: $app_name"
    echo "   Path: $relative_path"
    echo "   $(printf '%.0s-' {1..50})"
    
    ((TOTAL_VALIDATIONS++))
    
    if "$VALIDATOR" "$app_path" "$app_name" false; then
        echo "   ✅ Validation passed"
        ((SUCCESSFUL_VALIDATIONS++))
        
        # Extract score for summary
        score_output=$("$VALIDATOR" "$app_path" "$app_name" false 2>/dev/null | grep "Score:" | grep -o '[0-9]\+/[0-9]\+' || echo "0/10")
        VALIDATION_RESULTS+=("✅ $app_name: $score_output")
        VALIDATION_SCORES+=("$score_output")
    else
        echo "   ❌ Validation failed"
        ((FAILED_VALIDATIONS++))
        VALIDATION_RESULTS+=("❌ $app_name: FAILED")
        VALIDATION_SCORES+=("0/10")
    fi
    
    echo ""
done

# Summary
echo "🏁 VALIDATION SUMMARY"
echo "===================="
echo "Total validations: $TOTAL_VALIDATIONS"
echo "Successful: $SUCCESSFUL_VALIDATIONS"
echo "Failed: $FAILED_VALIDATIONS"
echo ""

echo "📊 DETAILED RESULTS:"
for result in "${VALIDATION_RESULTS[@]}"; do
    echo "   $result"
done

# Calculate average score
if [ ${#VALIDATION_SCORES[@]} -gt 0 ]; then
    total_score=0
    total_max=0
    
    for score in "${VALIDATION_SCORES[@]}"; do
        current=$(echo "$score" | cut -d'/' -f1)
        max=$(echo "$score" | cut -d'/' -f2)
        total_score=$((total_score + current))
        total_max=$((total_max + max))
    done
    
    if [ $total_max -gt 0 ]; then
        average_percentage=$((total_score * 100 / total_max))
        echo ""
        echo "📈 OVERALL PERFORMANCE:"
        echo "   Average score: $total_score/$total_max (${average_percentage}%)"
        
        if [ $average_percentage -ge 90 ]; then
            echo "   🎉 EXCELLENT: All apps are performing very well!"
        elif [ $average_percentage -ge 75 ]; then
            echo "   ✅ GOOD: Apps are generally functional with minor issues"
        elif [ $average_percentage -ge 60 ]; then
            echo "   ⚠️  ACCEPTABLE: Apps may work but need improvement"
        else
            echo "   ❌ POOR: Apps have significant issues that need attention"
        fi
    fi
fi

echo ""

# Recommendations
if [ $FAILED_VALIDATIONS -gt 0 ]; then
    echo "💡 RECOMMENDATIONS:"
    echo "   • Review failed validations above"
    echo "   • Rebuild failed .app files using: ./MacTesting/build_and_test_all_apps.sh"
    echo "   • Check individual apps with: ./MacTesting/comprehensive_app_validator.sh path/to/app.app [name] true"
    exit 1
else
    echo "🎉 All .app files passed validation!"
    echo ""
    echo "💡 NEXT STEPS:"
    echo "   • Test apps manually to ensure they work as expected"
    echo "   • Distribute .app files for testing"
    echo "   • Consider code signing for distribution"
    exit 0
fi
