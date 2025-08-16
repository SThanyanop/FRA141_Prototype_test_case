if(Test-Path -path .\build\) {
    Remove-Item -Path .\build -Recurse
}

if(Test-Path -path .\dist\) {
    Remove-Item -Path .\dist -Recurse
}

if(!(Test-Path -path .\Tester)) {
    mkdir .\Tester
}

# TA Replace Question with Question name
pyinstaller --onefile test_case_ListFloat.py

# TA Replace Question with Question name
move .\dist\test_case_ListFloat.exe .\Tester -Force

Remove-Item .\build -Recurse -Force
Remove-Item .\dist -Recurse -Force