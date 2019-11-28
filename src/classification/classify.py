import os, sys
from scipy.io import loadmat
import numpy as np
import pipeline
from tqdm import tqdm
from glob import glob
import pandas as pd

folders = glob('../../data/*')

dfs = []
print('program start: iterating')
for folder in folders:
    print('processing subject: ' + folder)
    files = glob(folder+'/*.mat')
    neg_features = loadmat(files[0])['freq_neg_beta_gamma']
    pos_features = loadmat(files[1])['freq_pos_beta_gamma']
    y_pos = np.ones(pos_features.shape[0])
    y_neg = np.zeros(pos_features.shape[0])
    X = np.vstack([pos_features, neg_features])
    y = np.concatenate([y_pos, y_neg])

    head_tail = os.path.split(folder)
    clf_scores = pipeline.cross_validation(X, y, cv=10)
    df_scores = {}
    for score in clf_scores:
        df_scores[score] = clf_scores[score][2]
    df_scores['Subject'] = [head_tail[1]] * len(clf_scores[score][2])
    df_scores['feature_size'] = [X.shape for i in range(len(clf_scores[score][2]))]
    df = pd.DataFrame(df_scores)
    dfs.append(df)

df = pd.concat(dfs, axis=0)
df.to_csv('../../output/classify_results.csv', index=False)
