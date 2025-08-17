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

# TA Replace Float with actual question name
pyinstaller --onefile --windowed test_case_Float.py

# Move the generated app to Tester directory
# TA Replace Float with actual question name
if [ -d "./dist/test_case_Float.app" ]; then
    mv ./dist/test_case_Float.app ./Tester/
    echo "Successfully built and moved test_case_Float.app to Tester directory"
else
    echo "Error: test_case_Float.app not found in dist directory"
    exit 1
fi

# Clean up build directories
rm -rf ./build
rm -rf ./dist

echo "Build completed successfully!"