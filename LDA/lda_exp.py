import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis as LDA
from sklearn.model_selection import cross_val_score

# LDA-Classification of EEG data on experienced monks 

# Read dataset to pandas dataframe.
beginners = pd.read_csv("beginners.csv", index_col = 0)
experienced = pd.read_csv("experienced.csv", index_col = 0)

# Save all anger moments
anger = experienced.loc[experienced['anger'] == 1]

# Save all non-anger momnets
nonanger = experienced.loc[experienced['anger'] == 0]

# Sample 1269 rows (number of anger moments)
nonanger_sample = nonanger.sample(n = 1217)

# Create data frame containing all data
data =  pd.concat([anger, nonanger_sample], axis = 0)

# Save feature vector
x = data[['alpha 1', 'beta 1', 'theta 1', 'alpha 2', 'beta 2', 'theta 2', 'alpha 3', 'theta 3', 'alpha 6', 'beta 6', 'theta 6', 'alpha 21', 'beta 21', 'theta 21', 'alpha 16', 'beta 16', 'theta 16', 'alpha 26', 'beta 26', 'theta 26']];

# Save only anger class.
y = data['anger']

# Save data to predict
pred = beginners[['alpha 1', 'beta 1', 'theta 1', 'alpha 2', 'beta 2', 'theta 2', 'alpha 3', 'theta 3', 'alpha 6', 'beta 6', 'theta 6', 'alpha 21', 'beta 21', 'theta 21', 'alpha 16', 'beta 16', 'theta 16', 'alpha 26', 'beta 26', 'theta 26']];
pred2 = experienced[['alpha 1', 'beta 1', 'theta 1', 'alpha 2', 'beta 2', 'theta 2', 'alpha 3', 'theta 3', 'alpha 6', 'beta 6', 'theta 6', 'alpha 21', 'beta 21', 'theta 21', 'alpha 16', 'beta 16', 'theta 16', 'alpha 26', 'beta 26', 'theta 26']];

#Create LDA classifier
lda = LDA()
lda.fit(x, y)

# Evaluate model performance in terms of Accuracy, Precision, Recall, F1
# Use standard 10 folds cross validation
from sklearn.model_selection import cross_validate
scores = cross_validate(LDA(), x, y, cv = 10,
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
prediction = lda.predict(pred)
anger_moments = 0
for i in prediction:
    if i == 1:
        anger_moments = anger_moments + 1
print("Anger moments in beg. data: ", anger_moments)
print("Non-anger moments in beg. data: ", len(prediction) - anger_moments)

# Predict experienced data after training and report anger and non-anger moments
prediction2 = lda.predict(pred2)
anger_moments = 0
for i in prediction2:
    if i == 1:
        anger_moments = anger_moments + 1
print("Anger moments in exp. data: ", anger_moments)
print("Non-anger moments in exp. data: ", len(prediction2) - anger_moments)