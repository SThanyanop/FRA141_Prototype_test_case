# 🚀 Quick Start Guide - Mac Testing Prep

Get up and running with building and testing .app files for FRA141 test cases in minutes!

## 🗺️ Quick Start Flow

The diagram above shows the complete quick start process from setup to success.

## 📋 Prerequisites

Before you start, make sure you have:
- **macOS** (any recent version)
- **Python 3.x** installed
- **Terminal** access

## ⚡ 30-Second Setup

### 1. Install PyInstaller
```bash
pip3 install pyinstaller
```

### 2. Add PyInstaller to PATH (if needed)
```bash
export PATH="$PATH:$HOME/Library/Python/3.9/bin"
```
*Replace `3.9` with your Python version*

### 3. Verify Setup
```bash
./MacTesting/check_requirements.sh
```

You should see: ✅ **All requirements met!**

## 🎯 Quick Actions

### Build All Test Cases (Recommended)
```bash
./MacTesting/build_and_test_all_apps.sh
```
This will:
- Build all 5 test case .app files
- Validate each one automatically
- Show comprehensive results

### Check What's Already Built
```bash
./MacTesting/validate_all_existing_apps.sh
```

### Build Individual Test Case
```bash
cd Test_use/Float/PrepFloat/
./Build_MacOS.sh
```

## 📊 Understanding Results

### Build Results
- ✅ **Build completed successfully** = .app file created
- ❌ **Build failed** = Check error messages

### Validation Scores
- 🎉 **90-100%**: EXCELLENT - Ready to use
- ✅ **75-89%**: GOOD - Minor issues, still functional
- ⚠️ **60-74%**: ACCEPTABLE - May work, some warnings
- ❌ **<60%**: POOR - Significant issues

## 📁 Where to Find Built Apps

After building, .app files are located in:
```
Template/PrepQuestion/Tester/test_case_Question.app
Test_use/Float/PrepFloat/Tester/test_case_Float.app
Test_use/Integer/PrepInteger/Tester/test_case_Integer.app
Test_use/ListFloat/PrepListFloat/Tester/test_case_ListFloat.app
Test_use/ListInteger/PrepListInteger/Tester/test_case_ListInteger.app
```

## 🧪 Testing Your Apps

### Quick Test
```bash
./MacTesting/test_single_app.sh path/to/your/app.app
```

### Comprehensive Test
```bash
./MacTesting/comprehensive_app_validator.sh path/to/your/app.app AppName true
```

### Manual Test
Double-click the .app file in Finder or:
```bash
open path/to/your/app.app
```

## 🆘 Troubleshooting

### PyInstaller Not Found
```bash
# Install PyInstaller
pip3 install pyinstaller

# Add to PATH
echo 'export PATH="$PATH:$HOME/Library/Python/3.9/bin"' >> ~/.zshrc
source ~/.zshrc
```

### Build Fails
1. Check you're in the right directory
2. Verify Python file exists: `ls test_case_*.py`
3. Check detailed logs: `cat MacTesting/build_test_log.txt`

### App Won't Launch
1. Check validation score: should be 60%+
2. Try opening from Terminal: `open YourApp.app`
3. Check Console.app for error messages

### Permission Denied
```bash
chmod +x MacTesting/*.sh
chmod +x */*/Build_MacOS.sh
```

## 📈 Expected Results

After running `./MacTesting/build_and_test_all_apps.sh`, you should see:

```
🏁 FINAL SUMMARY
=============================================================
📊 Build Results:
   Total builds attempted: 5
   Successful builds: 5
   Failed builds: 0

🧪 Test Results:
   Total tests attempted: 5
   Successful tests: 5
   Failed tests: 0

🎉 ALL BUILDS AND TESTS COMPLETED SUCCESSFULLY!
```

## 🎯 Common Use Cases

### I want to build everything
```bash
./MacTesting/build_and_test_all_apps.sh
```

### I want to test existing apps
```bash
./MacTesting/validate_all_existing_apps.sh
```

### I want to build just one test case
```bash
cd Test_use/Float/PrepFloat/
./Build_MacOS.sh
```

### I want detailed validation of one app
```bash
./MacTesting/comprehensive_app_validator.sh Test_use/Float/PrepFloat/Tester/test_case_Float.app Float true
```

### I want to check my system setup
```bash
./MacTesting/check_requirements.sh
```

## 🔧 Advanced Options

### Verbose Validation
Add `true` as the third parameter for detailed output:
```bash
./MacTesting/comprehensive_app_validator.sh app.app AppName true
```

### Check Build Script Syntax
```bash
./MacTesting/test_build_scripts.sh
```

### View Build Logs
```bash
cat MacTesting/build_test_log.txt
```

## 📚 More Information

For detailed documentation, see:
- [`MacTesting/README.md`](MacTesting/README.md) - Complete documentation
- Individual build scripts in each test directory
- Validation tools in `MacTesting/` directory

## 🎉 Success Indicators

You know everything is working when:
- ✅ All builds complete without errors
- ✅ Validation scores are 60%+ (preferably 70%+)
- ✅ .app files launch when double-clicked
- ✅ No critical errors in validation reports

---

**Need help?** Check the troubleshooting section above or review the detailed logs in `MacTesting/build_test_log.txt`
