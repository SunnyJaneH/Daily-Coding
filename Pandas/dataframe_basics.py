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
