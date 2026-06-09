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
# Key: df.loc[行条件, [列名]] — 一步过滤行+选列
def selectData(students: pd.DataFrame) -> pd.DataFrame:
    return students.loc[students['student_id'] == 101, ['name', 'age']]

# [2881] Create a New Column (Easy)
# Key: df['新列'] = df['已有列'] * 倍数
def createBonusColumn(employees: pd.DataFrame) -> pd.DataFrame:
    employees['bonus'] = employees['salary'] * 2
    return employees
