import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats
from sklearn.model_selection import cross_val_score, GridSearchCV, KFold

# KNN-Classification of EEG data on experienced monks

# Features used from literature: (FP1, FP2, F7, F4, T8, CP6, P4) x (alpha, beta, theta)

# Read dataset to pandas dataframe.
experienced = pd.read_csv("/home/merkel/Desktop/experienced.csv", index_col = 0)

# Save all anger moments
anger = experienced.loc[experienced['anger'] == 1]

# Save all non-anger momnets
nonanger = experienced.loc[experienced['anger'] == 0]

# Sample equal number of non-anger moments rows (number of anger moments)
nonanger_sample = nonanger.sample(n = 1217)

# Create data frame containing all data
data =  pd.concat([anger, nonanger_sample], axis = 0)

# Save feature vector
x = data[['alpha 1', 'beta 1', 'theta 1', 'alpha 2', 'beta 2', 'theta 2', 'alpha 3', 'theta 3', 'alpha 6', 'beta 6', 'theta 6', 'alpha 21', 'beta 21', 'theta 21', 'alpha 16', 'beta 16', 'theta 16', 'alpha 26', 'beta 26', 'theta 26']];

# Save only anger class.
y = data['anger']

# Import KNN classifier from sklearn
from sklearn.neighbors import KNeighborsClassifier

# Create KNN-Classifier
knn = KNeighborsClassifier()

# Setup grid-search for K-neighbours hyperparamter in range [1 25]
param_grid = {'n_neighbors': np.arange(1, 25)}

# CFG parameter specifying number of folds for CV
kfold = KFold(n_splits = 10)

# Find best k-nearest neighbour using grid-search given x, y
knn_gscv = GridSearchCV(knn, param_grid, cv = 10)
knn_gscv.fit(x, y)

# Retrieve the number of neighbours
kNeighbors = knn_gscv.best_params_.get('n_neighbors')

# Check top performing k-neighbours value
print(knn_gscv.best_params_)

# construct new knn with optimal neighbors
knn = KNeighborsClassifier(kNeighbors)

# Evaluate model performance in terms of Accuracy, Precision, Recall, F1
# Use cross-validation k-folds method where k = 10
from sklearn.model_selection import cross_validate
scores = cross_validate(knn, x, y, cv = 10,
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