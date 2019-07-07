import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats

# Support vector machine classification of experienced debaters.

# Kernel used: linear.

# Features used: (FP1, FP2, F4) * (alpha, beta, theta)
# (predicted by literature).

# Read dataset to pandas dataframe.
beginners = pd.read_csv("/home/merkel/Downloads/fd_beginners", index_col = 0)

# drop NaN values
beginners = beginners.dropna(axis = 0)

# save all anger moments
anger = beginners.loc[beginners['anger'] == 1]
print(anger.shape)

# save all non-anger momnets
nonanger = beginners.loc[beginners['anger'] == 0]

# sample 1217 rows (number of anger moments)
nonanger_sample = nonanger.sample(n = 1217)
print(nonanger_sample.shape)

data =  pd.concat([anger, nonanger_sample], axis = 0)
print(data)
print(data.shape)

# Save everything but anger class.
x = data[['alpha 1', 'beta 1', 'theta 1', 'alpha 2', 'beta 2', 'theta 2', 'alpha 6', 'beta 6', 'theta 6']]

print(x)

# Save only anger class.
y = data['anger']

from sklearn.svm import SVC
svclassifier = SVC(kernel = 'poly', degree = 1)

# Perform K-fold cross-validation with 10 folds.
from sklearn.model_selection import cross_val_score
scores = cross_val_score(svclassifier, x, y, cv = 10)

# Print accuracy scores.
print("Accuracy: %0.2f (+/- %0.2f)" % (scores.mean(), scores.std() * 2))
