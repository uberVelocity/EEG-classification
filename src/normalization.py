import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats

# Normalizes data by computing the z-score within participants and exports
# the data to CSV to be used by classifiers.

# Read dataset to pandas dataframe.
data = pd.read_csv('/home/merkel/Desktop/final_data_clean.csv')

# Create new dataframe to store resulting z-scores
new_df = pd.DataFrame()

# Get each participants' id
participants = data['id'].unique()

# Use the id to segment data into participants and compute z-score
for participant in participants:
    # Get participant with all of his data
    df = data.loc[data['id'] == participant]
    
    # Rid data of NaN values
    df = df.dropna(axis = 0)

    # Compute z-score of every data column from participants
    df.iloc[:, 4:100] = stats.zscore(df.iloc[:, 4:100])

    # Save result in new data frame
    new_df = pd.concat([new_df, df])
    print(new_df.shape)

    # Participant dealt with
    print('### Participant ', participant, ' finished ###')

# Print new data to make sure everything computed correctly
print(new_df)

# Separate beginners from experienced
experienced = new_df.loc[new_df['isExp'] == 1]
beginners = new_df.loc[new_df['isExp'] == 0]
print(experienced.shape)
print(beginners.shape)


# Export data to csv file
# export_csv = new_df.to_csv(r'/home/merkel/Desktop/final_data_normalized.csv')

export_csv = beginners.to_csv(r'/home/merkel/Desktop/beginners.csv')
export_csv = experienced.to_csv(r'/home/merkel/Desktop/experienced.csv')
