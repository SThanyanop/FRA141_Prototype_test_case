# Quick Start Guide - MacOS App Build & Distribution

## Template Setup (One-time)

### 1. Create Template Branch from Main
```bash
git checkout main
git pull origin main
git checkout -b template-setup
```

### 2. Prepare Template Files
- Template located in: `/Template/PrepQuestion/`
- Contains: `Build_MacOS.sh`, `test_case_Question.py`, `QUICK_START.md`

## Development Workflow

### 1. Build the App in Prep Folder
```bash
# Navigate to your prep folder (e.g., PrepListFloat)
cd Test_use/[QuestionType]/Prep[QuestionName]/

# Run build script
./Build_MacOS.sh
```
This creates `test_case_[QuestionName].app` in the `./Tester/` directory.

### 2. Test the App Locally
```bash
# Run the app to see terminal output
./Tester/test_case_[QuestionName].app/Contents/MacOS/test_case_[QuestionName]
```

### 3. Create Quiz Distribution Branch from Main

#### Switch to main and create new quiz branch:
```bash
# Navigate to repository root
cd ../../..

# Switch to main branch and get latest changes
git checkout main
git pull origin main

# Create new branch from main for quiz distribution
git checkout -b quiz/[question-name]
```

#### Create Quiz folder and move the app:
```bash
# Create Quiz directory at repository root
mkdir -p Quiz

# Move the built app from Prep folder to Quiz folder
# Example: mv Test_use/ListFloat/PrepListFloat/Tester/test_case_ListFloat.app Quiz/
mv Test_use/[QuestionType]/Prep[QuestionName]/Tester/test_case_[QuestionName].app Quiz[QuestionName]/
```

#### Commit and push to quiz branch:
```bash
git add Quiz/test_case_[QuestionName].app
git commit -m "Add test_case_[QuestionName].app for quiz distribution"
git push -u origin quiz/[question-name]
```

## Branch Structure
```
main
├── template-setup          # Template preparation
├── mac-testing-prep       # Development/testing
└── quiz/[question-name]   # Quiz distribution (from main)
```

## File Structure After Distribution
```
Repository Root/
├── Template/              # Templates (template-setup branch)
├── Test_use/             # Development (mac-testing-prep branch)
└── Quiz/                 # Distribution (quiz branches from main)
    └── test_case_[QuestionName].app
```

## Usage for Students
Students can run the distributed app with:
```bash
./test_case_[QuestionName].app/Contents/MacOS/test_case_[QuestionName]
```