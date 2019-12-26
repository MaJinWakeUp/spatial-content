#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Thu Oct 11 15:58:15 2018

@author: mj
"""
from sklearn.feature_extraction.text import TfidfTransformer
from sklearn.feature_extraction.text import CountVectorizer
import numpy as np
import scipy.io as sio
import codecs

dataset="vg";

corpus = [];
file = open("../baseline/captions_"+dataset+".txt");
line = file.readline();
while line:
    corpus.append(line);
    line = file.readline();
    
file.close();

vectorizer = CountVectorizer(min_df=0.0001,max_df=0.9,stop_words='english',analyzer='word');#min_df,max_df
transformer = TfidfTransformer();
X = transformer.fit_transform(vectorizer.fit_transform(corpus));
word = vectorizer.get_feature_names();
data_mat = X.toarray()

num_im = data_mat.shape[0];

query=sio.loadmat('../data/qidx_'+dataset+'.mat');
qidx=query['qidx'].flatten();
qidx=qidx.astype(int)-1;
q_mat = data_mat[qidx,:];
simscore = np.dot(q_mat,data_mat.T);
    
#qidx = [];
#simscore=[];
#for i in range(num_im):
#    cur_id = np.random.randint(num_im);
#    q_mat = data_mat[cur_id,:];
#    cur_simscore = np.dot(q_mat,data_mat.T);
#    if sum(cur_simscore>0.3)<100:
#        qidx.append(cur_id)
#        simscore.append(cur_simscore)
#    if len(qidx)==500:
#        break

#qidx=np.array(qidx)
#simscore=np.array(simscore)

#sio.savemat('../data/qidx_'+dataset+'.mat',{"qidx":qidx+1});
sio.savemat('../data/simscore_'+dataset+'.mat',{"simscore":simscore});