#!/bin/bash

# Clean up previous builds
if [ -d "./build" ]; then
    rm -rf ./build
fi

if [ -d "./dist" ]; then
    rm -rf ./dist
fi

# Create Tester directory if it doesn't exist
if [ ! -d "./Tester" ]; then
    mkdir -p ./Tester
fi

# TA Replace Integer with actual question name
pyinstaller --onefile --windowed test_case_Integer.py

# Move the generated app to Tester directory
# TA Replace Integer with actual question name
if [ -d "./dist/test_case_Integer.app" ]; then
    mv ./dist/test_case_Integer.app ./Tester/
    echo "Successfully built and moved test_case_Integer.app to Tester directory"
else
    echo "Error: test_case_Integer.app not found in dist directory"
    exit 1
fi

# Clean up build directories
rm -rf ./build
rm -rf ./dist

echo "Build completed successfully!"