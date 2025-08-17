# Mac Testing Prep Build Files

This directory contains the corrected Mac build scripts and templates for the FRA141 Prototype test cases.

## What Was Fixed

The original `Build_MacOS.sh` files throughout the project were using Windows PowerShell syntax instead of proper bash/shell commands for macOS. This branch (`mac-testing-prep`) contains the corrected versions.

### Original Issues:
- Used PowerShell `move` command instead of bash `mv`
- Used Windows path syntax (`.\dist\` instead of `./dist/`)
- Missing proper bash shebang (`#!/bin/bash`)
- No error handling or status messages
- Missing executable permissions

### Fixed Features:
- ✅ Proper bash syntax and commands
- ✅ Cross-platform path handling
- ✅ Error handling with exit codes
- ✅ Status messages for better debugging
- ✅ Automatic cleanup of build directories
- ✅ Executable permissions set correctly

## Files Updated

The following `Build_MacOS.sh` files have been corrected:

1. `Template/PrepQuestion/Build_MacOS.sh`
2. `Test_use/Float/PrepFloat/Build_MacOS.sh`
3. `Test_use/Integer/PrepInteger/Build_MacOS.sh`
4. `Test_use/ListFloat/PrepListFloat/Build_MacOS.sh`
5. `Test_use/ListInteger/PrepListInteger/Build_MacOS.sh`

## Template File

A template file `Build_MacOS_Template.sh` has been created in this directory that can be used for future test cases. Simply replace `QUESTION_NAME` with the appropriate question name.

## Usage

To use any of the corrected build scripts:

1. Navigate to the appropriate directory (e.g., `Test_use/Float/PrepFloat/`)
2. Run the build script: `./Build_MacOS.sh`

The script will:
1. Clean up any previous build artifacts
2. Create the `Tester` directory if needed
3. Build the Python application using PyInstaller
4. Move the generated `.app` file to the `Tester` directory
5. Clean up temporary build files
6. Display success/error messages

## Requirements

- Python with PyInstaller installed
- macOS environment
- Executable permissions on the build scripts (already set)

## Branch Information

- Branch: `mac-testing-prep`
- Created for: Mac testing preparation and build file corrections
- Status: Ready for testing and merging

## Testing

To test the corrected build scripts, try building any of the test cases:

```bash
cd Test_use/Float/PrepFloat/
./Build_MacOS.sh
```

The script should complete without errors and create the appropriate `.app` file in the `Tester` directory.
