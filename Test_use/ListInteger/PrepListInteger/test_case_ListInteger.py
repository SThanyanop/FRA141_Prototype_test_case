# Problem #

Question = 'ListInteger'  # Have to match the name of the function in Question.py

'''
Write dow poblem here
'''

# Default Import #

# import random
# import os
# import sys
# import unittest
# import importlib
# from unittest.mock import patch

import random
import os
import sys
import unittest
import importlib
from unittest.mock import patch

##########################################################################

# Default random Generator for test cases #

# Get random integer in range [min_value, max_value] by default min_value is 1
def GenerateRandomInt(max_value, min_value=1):
    return random.randint(min_value, max_value)


# Get random float in range [min_value, max_value] by default min_value is 0.0
def GenerateRandomFloat(max_value,min_value=0.0):
    return random.uniform(min_value, max_value)


# Generate random list of integers by default length is 5 and min_value is 1
def GenerateRandomIntList(max_value, min_value=1,length=5):
    return [GenerateRandomInt(max_value, min_value) for _ in range(length)]


# Generate random list of unique integers by default length is 5 and min_value is 1
def GenerateRandomUniqueIntList(max_value, min_value=1, length=5):
    if length > (max_value - min_value + 1):
        raise ValueError("Range too small for unique values.")
    return random.sample(range(min_value, max_value + 1), length)


# Generate random list of floats by default length is 5 and min_value is 0.0
def GenerateRandomFloatList(max_value, min_value=0.0,length=5):
    return [GenerateRandomFloat(max_value, min_value) for _ in range(length)]


# Generate random list of unique floats by default length is 5 and min_value is 0.0
def GenerateRandomUniqueFloatList(max_value, min_value=0.0, length=5):
    if length > int(max_value - min_value):
        raise ValueError("Range too small for unique values.")
    unique_floats = set()
    while len(unique_floats) < length:
        unique_floats.add(GenerateRandomFloat(max_value, min_value))
    return list(unique_floats)


# Generate random 2D list of integers by default row=5, col=5 and min_value is 1
def GenerateRandom2DList(max_value, min_value=1, row=5, col=5):
    return [[GenerateRandomInt(max_value, min_value) for _ in range(col)] for _ in range(row)]


# Generate random 2D list of floats by default row=5, col=5 and min_value is 0.0
def GenerateRandom2DFloatList(max_value, min_value=0.0, row=5, col=5):
    return [[GenerateRandomFloat(max_value, min_value) for _ in range(col)] for _ in range(row)]


# Generate random Character from a-z
def GenerateRandomlowerCharacter():
    return chr(random.randint(ord('a'), ord('z')))


# Generate random Character from A-Z
def GenerateRandomupperCharacter():
    return chr(random.randint(ord('A'), ord('Z')))


# Generate random Character Number from 0-9
def GenerateRandomDigitCharacter():
    return str(random.randint(0, 9))

##########################################################################

# Additional custom random Generators are build here #


##########################################################################



# Solution #
# Write the solution here
# Always check the solution with the test cases below and make sure it works fine

# immpart needed libraries #
# import math   #whether creating a factorial function or importing math, both work with the test cases

def ListInteger_test(x,y): # Solution name should match the function name in Question.py but with _test suffix
    for i in x:
        y.append(i)
    y.sort()
    return y


##########################################################################

# Test cases basic #

# Old script : separatly assigned basic test cases for each test case
# testcase_basic1 = (4,)
# testcase_basic2 = (5,) 

#new script : uses list to store basic test cases
basic_testcase = []

# Add basic test cases #
# Must have at least 2-3 basic test cases that can manually verify

basic_testcase.append(([1, 3, 5, 7], [2, 4, 6, 8])) # Example of a basic test case
basic_testcase.append(([10, 20, 30], [5, 15, 25]))
basic_testcase.append(([2, 4, 6], [1, 3, 5]))
# Generate random basic test cases #
for i in range(0, 10): # Feel free to change the range
    basic_testcase.append((GenerateRandomIntList(100),GenerateRandomIntList(100))) # Feel free to change the max_value and min_value

##########################################################################

# Old script : separatly assigned advance test cases for each test case
# Test cases advance #
# testcase_advance1 = (100,) 
# testcase_advance2 = (7,) 
# testcase_advance3 = (999,) 

#New script : uses list to store advance test cases
advance_testcase = []

# Add advance test cases #
# Must have at least 2-3 advance test cases that can manually verify

advance_testcase.append(([1, 2, 3, 4, 5], [6, 7, 8, 9, 10])) # Example of an advance test case
advance_testcase.append(([10, 20, 30, 40], [5, 15, 25, 35]))
advance_testcase.append(([2, 4, 6, 8], [1, 3, 5, 7]))

# Generate random advance test cases #
for i in range(0, 12): # Feel free to change the range
    advance_testcase.append((GenerateRandomIntList(1000,0,GenerateRandomInt(10)),GenerateRandomIntList(1000,0,GenerateRandomInt(10)))) # Feel free to change the max_value and min_value

##########################################################################

# -------------------------- # Mocking and Testing Script # -------------------------- #
# TA and Super TA have to inform the Instructor about the changes made in this script #
# Always keep the old script commented out for reference after editing the script below
# After editing this script, run the test_case_Question.py file to check if everything is working fine
# Do not push or commit this script to the repository after editing. Please pull request the Instructor to review the changes
# ------------------------------------------------------------------------------------ #

# ตั้งค่าที่อยู่ของสคริปต์
script_dir = os.path.dirname(os.path.abspath(sys.argv[0]))
sys.path.append(script_dir)

# Old script 
# n = 2 # <----insert number of basic test case 
# m = 3 # <----insert number of advance test case

# New script
n = len(basic_testcase)   # <---- number of basic test case auto detect
m = len(advance_testcase) # <---- number of advance test case auto detect

filename = Question        # <---- insert function name
filename_test = filename + '_test'

# สร้างโฟลเดอร์ใหม่สำหรับเก็บไฟล์ mock
mock_folder = os.path.join(script_dir, 'mock_files')
if not os.path.exists(mock_folder):
    os.makedirs(mock_folder)

# เช็คลิสต์ของไลบรารีที่ต้องการตรวจสอบ
restricted_libraries = ['logging', 'sys', 'Console', 'display', 'HTML', 'pdb', 'pandas', 'numpy', 'patch'] # <--- library ที่ไม่อนุญาตให้ใช้งาน

# อ่านเนื้อหาของไฟล์เป็นบรรทัดๆ
with open(f'{filename}.py', 'r') as f:
    file_content = f.readlines()

mocked_content = []
in_function = False  # ตัวแปรนี้จะใช้เพื่อตรวจจับว่าเรากำลังอยู่ในฟังก์ชันหรือไม่

# ลบเฉพาะบรรทัดว่าง
file_content = [line for line in file_content if line.strip()]

for line in file_content:
    stripped_line = line.strip()

    # ตรวจสอบว่าบรรทัดนั้นเป็นการ import หรือไม่ (ไม่ใส่ # ที่บรรทัดนี้)
    if stripped_line.startswith('import') or stripped_line.startswith('from'):
        mocked_content.append(line)
        continue

    # ถ้าบรรทัดเริ่มต้นด้วย 'def ' แปลว่าเรากำลังเริ่มฟังก์ชัน
    if stripped_line.startswith('def '):
        in_function = True
        mocked_content.append(line)
        continue

    # ถ้าบรรทัดเป็นค่าว่างๆ หรือเป็นบรรทัดที่คอมเมนต์อยู่แล้ว ให้ข้ามไป
    if not stripped_line or stripped_line.startswith('#'):
        mocked_content.append(line)
        continue

    # ถ้าเจอการปิดฟังก์ชัน (เช็คจากการย่อหน้า) ให้ตั้งค่า in_function เป็น False
    if in_function and line.startswith(' '):
        mocked_content.append(line)
        continue
    else:
        in_function = False  # ฟังก์ชันสิ้นสุดแล้ว

    # ใส่ # ถ้าเราอยู่นอกฟังก์ชันและไม่ใช่ import หรือ from
    if not in_function:
        line = '# ' + line

    mocked_content.append(line)

# เขียนผลลัพธ์ใหม่กลับไปที่ไฟล์ (ในโฟลเดอร์ mock_files)
mock_file_path = os.path.join(mock_folder, f'{filename}_mock.py')
with open(mock_file_path, 'w') as f:
    f.writelines(mocked_content)

# นำเข้าโมดูลที่แก้ไขแล้ว
prob = importlib.import_module(f'mock_files.{filename}_mock')

# all testcase were build from here
list_testcase_basic = ["testcase_basic{}".format(i + 1) for i in range(n)]
list_testcase_advance = ["testcase_advance{}".format(i + 1) for i in range(m)]

# ฟังก์ชันตรวจสอบการนำเข้าไลบรารี
def check_imports(filename, libraries):
    found_libs = []
    with open(filename + '.py', 'r') as f:
        content = f.readlines()
        for line in content:
            for lib in libraries:
                # ตรวจสอบว่ามีการนำเข้าหรือไม่ โดยไม่สนใจการคอมเมนต์
                if f'import {lib}' in line and not line.strip().startswith('#'):
                    found_libs.append(lib)
                if f'from {lib}' in line and not line.strip().startswith('#'):
                    found_libs.append(lib)
    return found_libs


class TestMethods(unittest.TestCase):
    def test_case(self):
        # ตรวจสอบการนำเข้าไลบรารีใน SqrtFunction.py
        found_libs = check_imports(filename, restricted_libraries)
        if found_libs:
            libs = ', '.join(found_libs)
            print('\n')
            self.skipTest(f'Test skipped because the following libraries is(are) imported: {libs}. Please remove these librarie(s)!!!')

        # Mock ฟังก์ชัน print ทั้งหมดใน def ใน SqrtFunction.py

        #New script : count the correct answer of test cases
        
        CorrectBasic = 0
        CorrectAdvance = 0

        with patch(f'mock_files.{filename}_mock.print'):  # บล็อกการเรียก print
            print('\n')
            print(70*'-')
            for i in range(n):

                # Old script : separatly evaluates basic test cases for each test case
                # output = eval("prob.{}{}".format(filename, eval(list_testcase_basic[i])))
                # testcase_output = eval("{}{}".format(filename_test, eval(list_testcase_basic[i])))

                # New script : evaluates the basic test cases from the list
                output = eval("prob.{}{}".format(filename, basic_testcase[i]))
                testcase_output = eval("{}{}".format(filename_test, basic_testcase[i]))

                with self.subTest():
                    try:
                        self.assertEqual(output, testcase_output)
                        print(f"Basic Test case {i + 1}: Pass")
                        # New script : count the correct answer of test cases
                        CorrectBasic += 1
                    except:
                        print(f"Basic Test case {i + 1}: Error")
            print(70*'-')

            for i in range(m):

                # Old script : separatly evaluates advance test cases for each test case
                # output = eval("prob.{}{}".format(filename, eval(list_testcase_advance[i])))
                # testcase_output = eval("{}{}".format(filename_test, eval(list_testcase_advance[i])))

                # New script : evaluates the advance test cases from the list
                output = eval("prob.{}{}".format(filename, advance_testcase[i]))
                testcase_output = eval("{}{}".format(filename_test, advance_testcase[i]))

                with self.subTest():
                    try:
                        self.assertEqual(output, testcase_output)
                        print(f"Advance Test case {i + 1}: Pass")
                        # New script : count the correct answer of test cases
                        CorrectAdvance += 1
                    except:
                        print(f"Advance Test case {i + 1}: Error")

            # New script Print the summary of test cases #
            print(70*'-')
            print(f"Total Basic Test cases: {n}, Correct: {CorrectBasic}")
            print(f"Total Advance Test cases: {m}, Correct: {CorrectAdvance}")
            print(70*'-')
            if( CorrectBasic == n and CorrectAdvance == m):
                print(f"{filename} : Passed")
            else:
                print(f"{filename} : Failed")      
            print(70*'-')

if __name__ == '__main__':
    unittest.main(verbosity=2)
    importlib.reload(sys.modules[filename])

# #Command for generat .exe file in cmd --->  pyinstaller --onefile test_case_SqrtFunction.py