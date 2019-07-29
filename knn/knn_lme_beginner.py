import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats
from sklearn.model_selection import cross_val_score, GridSearchCV, KFold

# KNN-Classification of EEG data on beginner monks 

# Features used: All beta channels x (alpha, beta, theta)

# Read dataset to pandas dataframe.
beginners = pd.read_csv("/home/merkel/Desktop/beginners.csv", index_col = 0)
experienced = pd.read_csv("/home/merkel/Desktop/experienced.csv", index_col = 0)

# Save all anger moments
anger = beginners.loc[beginners['anger'] == 1]

# Save all non-anger momnets
nonanger = beginners.loc[beginners['anger'] == 0]

# Sample 1269 rows (number of anger moments)
nonanger_sample = nonanger.sample(n = 1217)

# Create data frame containing all data
data =  pd.concat([anger, nonanger_sample], axis = 0)

# Save everything but anger class.
x = data.drop(['anger'], axis = 1)

# Save only beta channels
x = x[x.columns.drop(list(x.filter(regex = 'alpha')))]
x = x[x.columns.drop(list(x.filter(regex = 'theta')))]

# Save only anger class.
y = data['anger']

# Save data to predict
pred = beginners.drop(['anger'], axis = 1)
pred = pred[pred.columns.drop(list(pred.filter(regex = 'alpha')))]
pred = pred[pred.columns.drop(list(pred.filter(regex = 'theta')))]


# Import KNN classifier from sklearn
from sklearn.neighbors import KNeighborsClassifier

# Create KNN-Classifier
knn = KNeighborsClassifier()

# Setup grid-search for K-neighbours hyperparameter in range [1 25]
param_grid = {'n_neighbors': np.arange(1, 25)}

# CFG parameter specifying number of folds for CV
kfold = KFold(n_splits = 10)

# Find best K-nearest neighbour using grid-search given x, y
knn_gscv = GridSearchCV(knn, param_grid, cv = 10)
knn_gscv.fit(x, y)

# Retrieve the number of neighbours
kNeighbors = knn_gscv.best_params_.get('n_neighbors')

# Check top performing n_neighbors value
print(knn_gscv.best_params_)

# Construct new knn with optimal neighbors
knn = KNeighborsClassifier(kNeighbors)
knn.fit(x, y)

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
print("F1: ", (2 * (np.mean(scores['test_precision']*np.mean(scores['test_recall']))))/np.mean(scores['test_precision']+np.mean(scores['test_recall'])), "\n")

# Predict experienced data after training and report anger and non-anger moments
prediction = knn.predict(pred)
anger_moments = 0
for i in prediction:
    if i == 1:
        anger_moments = anger_moments + 1
print("Anger moments: ", anger_moments)
print("Non-anger moments: ", len(prediction) - anger_moments)