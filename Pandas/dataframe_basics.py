# ============================================================
# DATAFRAME BASICS
# ============================================================
import pandas as pd

# [2877] Create a DataFrame from List (Easy)
# Create DataFrame with student_id and age columns
def createDataframe(student_data: List[List[int]]) -> pd.DataFrame:
    return pd.DataFrame(student_data, columns=['student_id', 'age'])

# [2878] Get the Size of a DataFrame (Easy)
# Return [number of rows, number of columns]
def getDataframeSize(players: pd.DataFrame) -> List[int]:
    return list(players.shape)

# [2879] Display the First Three Rows (Easy)
# Key: .head(n) for Pandas, NOT .show(n) which is PySpark
def selectFirstRows(employees: pd.DataFrame) -> pd.DataFrame:
    return employees.head(3)

# [2880] Select Data (Easy)
# Key: df.loc[row condition, [columns]] to filter rows and select columns in one step
def selectData(students: pd.DataFrame) -> pd.DataFrame:
    return students.loc[students['student_id'] == 101, ['name', 'age']]

# [2881] Create a New Column (Easy)
# Key: df['new_col'] = df['existing_col'] * n to add a new column
def createBonusColumn(employees: pd.DataFrame) -> pd.DataFrame:
    employees['bonus'] = employees['salary'] * 2
    return employees

# [2882] Drop Duplicate Rows (Easy)
# Key: drop_duplicates(subset=['col'], keep='first') to remove duplicates by column
def dropDuplicateEmails(customers: pd.DataFrame) -> pd.DataFrame:
    return customers.drop_duplicates(subset=['email'], keep='first')

# [2883] Drop Missing Data (Easy)
# Key: dropna(subset=['col']) to remove rows with missing values in specific column
def dropMissingData(students: pd.DataFrame) -> pd.DataFrame:
    return students.dropna(subset=['name'])

# [2884] Modify Columns (Easy)
# Key: df['col'] = df['col'] * n to modify an existing column in place
def modifySalaryColumn(employees: pd.DataFrame) -> pd.DataFrame:
    employees['salary'] = employees['salary'] * 2
    return employees

# [2885] Rename Columns (Easy)
# Key: df.rename(columns={'old': 'new', ...}) to rename multiple columns at once
def renameColumns(students: pd.DataFrame) -> pd.DataFrame:
    return students.rename(columns={
        'id': 'student_id',
        'first': 'first_name',
        'last': 'last_name',
        'age': 'age_in_years'
    })

# [2886] Change Data Type (Easy)
# Key: df['col'].astype(type) to convert column data type
# Common types: int, float, str, bool
def changeDatatype(students: pd.DataFrame) -> pd.DataFrame:
    students['grade'] = students['grade'].astype(int)
    return students

# [2887] Fill Missing Data (Easy)
# Key: df['col'].fillna(value) to fill missing values
# Compare: fillna() fills NaN, dropna() removes rows with NaN
def fillMissingValues(products: pd.DataFrame) -> pd.DataFrame:
    products['quantity'] = products['quantity'].fillna(0)
    return products
