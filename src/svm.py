import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats

# Support vector machine classification of experienced/inexperienced debaters.

# Kernel used: radial basis function

# Features used: (FP1, FP2, F7, F4, T8, CP6, P4) * (alpha, beta, theta)
# (found significant by Linear-Mixed-Effects model).

# Read dataset to pandas dataframe.
beginners = pd.read_csv("/home/merkel/Desktop/experienced.csv", index_col = 0)

# drop NaN values
beginners = beginners.dropna(axis = 0)

# save all anger moments
anger = beginners.loc[beginners['anger'] == 1]
print(anger.shape)
print(anger.head())

# save all non-anger moments
nonanger = beginners.loc[beginners['anger'] == 0]

# sample 1269 rows (number of anger moments)
nonanger_sample = nonanger.sample(n = 1217)
print(nonanger_sample.shape)

data =  pd.concat([anger, nonanger_sample], axis = 0)
# print(data)
# print(data.shape)

# Save everything but anger class.
x = data[['alpha 1', 'beta 1', 'theta 1', 'alpha 2', 'beta 2', 'theta 2', 'alpha 4', 'beta 4', 'theta 4', 'alpha 6', 'beta 6', 'theta 6', 'alpha 16', 'beta 16', 'theta 16']];


# Save only anger class.
y = data['anger']

from sklearn.svm import SVC
svclassifier = SVC(kernel = 'sigmoid')

# Perform K-fold cross-validation with 10 folds
from sklearn.model_selection import cross_validate
scores = cross_validate(svclassifier, x, y, cv = 10,
                        scoring = ('accuracy', 'precision', 'recall', 'f1'),
                        return_train_score = True)

# Model performance on Training set (already seen by classifier)
print("=== Training set === ")
print("Accuracy: ", np.mean(scores['train_accuracy']))
print("Precision: ", np.mean(scores['train_precision']))
print("Recall: ", np.mean(scores['train_recall']))
print("F1: ", (2 * (np.mean(scores['train_precision']*np.mean(scores['train_recall']))))/np.mean(scores['train_precision']+np.mean(scores['train_recall'])))

# Model performance on Testing set (never-seen before by classifier)
print("=== Testing set === ")
print("Accuracy: ", np.mean(scores['test_accuracy']))
print("Precision: ", np.mean(scores['test_precision']))
print("Recall: ", np.mean(scores['test_recall']))
print("F1: ", (2 * (np.mean(scores['test_precision']*np.mean(scores['test_recall']))))/np.mean(scores['test_precision']+np.mean(scores['test_recall'])))