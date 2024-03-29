import os, sys
from scipy.io import loadmat
from tqdm import tqdm

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

from matplotlib.colors import ListedColormap
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC, LinearSVC
from sklearn.gaussian_process.kernels import RBF
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier, AdaBoostClassifier
from sklearn.discriminant_analysis import QuadraticDiscriminantAnalysis, LinearDiscriminantAnalysis
from sklearn.linear_model import LogisticRegression
from sklearn.utils import shuffle
from sklearn.model_selection import KFold

from sklearn.model_selection import KFold, GridSearchCV
from sklearn import metrics
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.linear_model import LogisticRegressionCV

def general_preprocessing(X, y):
    '''
    This function takes in input of the original dataset X and y
    and do the following preprocessing:
    1. Randomly shuffle the dataset
    2. split the dataset into training and testing randomly
    3. Perform standardization and normalization
    Outputs:
    the training and testing datset
    '''
    X, y = shuffle(X, y, random_state=0)
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.25)
    scaler = StandardScaler()
    scaler.fit(X_train)
    X_train = scaler.transform(X_train)
    X_test = scaler.transform(X_test)
    return X_train, X_test, y_train, y_test

def cv_run(X, y, kf, clf):
    cv_scores = []
    for train_index, test_index in kf.split(X):
        X_train, X_test = X[train_index], X[test_index]
        y_train, y_test = y[train_index], y[test_index]
        clf.fit(X_train, y_train)
        cv_scores.append(clf.score(X_test, y_test))
    return cv_scores

def cross_validation(X, y, cv=5, bootstrap_shuffle=None):
    '''
    Run cross validation of different models with default parameters:
    1. Logistic Regression
    2. Random Forest
    3. AdaBoost
    4. GradientBoosting
    5. QDA
    6. LDA
    7. LinearSVM
    8. SVM RBF kernels
    '''
    clfs = {'LR': LogisticRegression(),
           'RF': RandomForestClassifier(),
           'ADA': AdaBoostClassifier(),
           'GB': GradientBoostingClassifier(),
           'QDA': QuadraticDiscriminantAnalysis(),
           'LDA': LinearDiscriminantAnalysis(),
           'LinearSVM': LinearSVC(),
           'RBFSVM': SVC()}

    X, y = shuffle(X, y, random_state=0)

    if bootstrap_shuffle:
        # Run bootstraping by random shuffling
        clf_scores = {}
        for clf in clfs:
            bootstrap_scores = []
            print('Running '+ clf)
            for i in tqdm(range(bootstrap_shuffle)):
                np.random.shuffle(y)
                kf = KFold(n_splits=cv)
                this_score = np.mean(cv_run(X, y, kf, clfs[clf]))
                bootstrap_scores.append(this_score)
            clf_scores[clf]= (np.mean(bootstrap_scores), np.std(bootstrap_scores), bootstrap_scores)
    else:
        # Run classification
        clf_scores = {};
        for clf in clfs:
            kf = KFold(n_splits=cv)
            cv_scores = cv_run(X, y, kf, clfs[clf])
            clf_scores[clf] = (np.mean(cv_scores), np.std(cv_scores), cv_scores)
    return clf_scores
