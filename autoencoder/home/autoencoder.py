from keras.layers import Input, Dense
from keras.models import Model
from keras import regularizers
from keras.datasets import mnist
from keras import backend as K
import numpy as np
import matplotlib.pyplot as plt
import pickle
import random
from random import sample 
from keras.models import Sequential
from keras.layers import Dense, Activation
import keras
from sklearn.model_selection import train_test_split
from keras.utils import plot_model
from matplotlib import pyplot
import os
import scipy.io
import pandas as pd
from sklearn.manifold import TSNE
import sys
from sklearn.cluster import KMeans
import subprocess
import tensorflow as tsf
import keras
import datetime
from keras.callbacks import EarlyStopping
from shutil import copyfile
import matplotlib.cm as cm    
import stat
import os.path
import math
os.chdir("/scratch")

#lr=0.01, beta_1=0.9, beta_2=0.999, epsilon=1e-08, decay=0.0), loss='mean_squared_error'
if np.asarray(sys.argv).shape[0] ==1:
    bias="TF"
    #bias="mirna"
    #bias="KEGG"
    #permutation=2
    index=1
    nEpochs=1000
    patiencePercentage=5
    projectName="prova"
    matrix="setA.csv"
    sep=","
    bName="merged_rel.txt"
    lrVar=0.01
    beta_1Var=0.9
    beta_2Var=0.999
    epsilonVar=1e-08
    decayVar=0.0
    lossVar='mean_squared_error'
else:
    matrix=sys.argv[1]
    sep=sys.argv[2]
    bias=sys.argv[3]
    #permutation=int(sys.argv[4])
    index=int(sys.argv[4])
    nEpochs=int(sys.argv[5])
    patiencePercentage=int(sys.argv[6])
    projectName=sys.argv[7]
    random.seed(sys.argv[8])
    bName=sys.argv[9]
    lrVar=float(sys.argv[10])
    beta_1Var=float(sys.argv[11])
    beta_2Var=float(sys.argv[12])
    epsilonVar=float(sys.argv[13])
    decayVar=float(sys.argv[14])
    lossVar=sys.argv[15]
print("matrixName "+matrix)
print("sep "+sep)
print("bias "+bias)
print("nEpochs "+str(nEpochs))
print("patiencePercentage "+str(patiencePercentage))
print("projectName "+projectName)
print("bName "+bName)
if sep == "tab":
    sep="\t"
mat=pd.read_csv(matrix,index_col=0,sep=sep)
#PULIZIA
mat=mat.drop(mat.index[np.where(mat.T.sum()<=10)])
#FINE PULIZIA
Atac=mat.T

if bias == "TF":
    tfName="/home/tf.txt"
    tf=pd.read_csv(tfName,sep="\t",header=0)
    transcriptionFactors=np.unique(tf.iloc[:,0])
    relationMatrix=pd.DataFrame(np.zeros((Atac.columns.shape[0],transcriptionFactors.shape[0])))
    relationMatrix.index=Atac.columns
    relationMatrix.columns=transcriptionFactors
    for i in Atac.columns:
        tfTemp=np.unique(tf.iloc[np.where(tf.iloc[:,1]==i)[0],0])
        relationMatrix.loc[i,tfTemp]=1
    relationMatrix=relationMatrix.loc[:, (relationMatrix != 0).any(axis=0)]
    transcriptionFactors=np.asarray(relationMatrix.T.index)
if bias == "mirna":
    tfName="/home/mirna.txt"
    tf=pd.read_csv(tfName,sep="\t",header=0)
    transcriptionFactors=np.unique(tf.iloc[:,0])
    relationMatrix=pd.DataFrame(np.zeros((Atac.columns.shape[0],transcriptionFactors.shape[0])))
    relationMatrix.index=Atac.columns
    relationMatrix.columns=transcriptionFactors
    for i in Atac.columns:
        tfTemp=np.unique(tf.iloc[np.where(tf.iloc[:,3]==i)[0],0])
        relationMatrix.loc[i,tfTemp]=1
    relationMatrix=relationMatrix.loc[:, (relationMatrix != 0).any(axis=0)]
    transcriptionFactors=np.asarray(relationMatrix.T.index)

if bias == "kinasi":
    tfName="/home/kinase-specific_phosphorylation_sites.csv"
    tf=pd.read_csv(tfName,sep=",",header=0)
    transcriptionFactors=np.unique(tf.iloc[:,0])
    relationMatrix=pd.DataFrame(np.zeros((Atac.columns.shape[0],transcriptionFactors.shape[0])))
    relationMatrix.index=Atac.columns
    relationMatrix.columns=transcriptionFactors
    for i in Atac.columns:
        tfTemp=np.unique(tf.iloc[np.where(tf.iloc[:,1]==i)[0],0])
        relationMatrix.loc[i,tfTemp]=1
    relationMatrix=relationMatrix.loc[:, (relationMatrix != 0).any(axis=0)]
    transcriptionFactors=np.asarray(relationMatrix.T.index)

if bias == "immunoSignature":
    tfName="/home/cancer_related_immuno_signatures.csv"
    tf=pd.read_csv(tfName,sep=",",header=0)
    transcriptionFactors=np.unique(tf.iloc[:,0])
    relationMatrix=pd.DataFrame(np.zeros((Atac.columns.shape[0],transcriptionFactors.shape[0])))
    relationMatrix.index=Atac.columns
    relationMatrix.columns=transcriptionFactors
    for i in Atac.columns:
        tfTemp=np.unique(tf.iloc[np.where(tf.iloc[:,1]==i)[0],0])
        relationMatrix.loc[i,tfTemp]=1
    relationMatrix=relationMatrix.loc[:, (relationMatrix != 0).any(axis=0)]
    transcriptionFactors=np.asarray(relationMatrix.T.index)
if bias == "ALL":
    tfName="/home/mirnaTFISKinase.csv"
    tf=pd.read_csv(tfName,sep=",",header=0)
    transcriptionFactors=np.unique(tf.iloc[:,0])
    relationMatrix=pd.DataFrame(np.zeros((Atac.columns.shape[0],transcriptionFactors.shape[0])))
    relationMatrix.index=Atac.columns
    relationMatrix.columns=transcriptionFactors
    for i in Atac.columns:
        tfTemp=np.unique(tf.iloc[np.where(tf.iloc[:,1]==i)[0],0])
        relationMatrix.loc[i,tfTemp]=1
    relationMatrix=relationMatrix.loc[:, (relationMatrix != 0).any(axis=0)]
    transcriptionFactors=np.asarray(relationMatrix.T.index)

if bias == "CUSTOM":
    tfName=bName
    tf=pd.read_csv(tfName,sep=sep,header=0)
    transcriptionFactors=np.unique(tf.iloc[:,0])
    relationMatrix=pd.DataFrame(np.zeros((Atac.columns.shape[0],transcriptionFactors.shape[0])))
    relationMatrix.index=Atac.columns
    relationMatrix.columns=transcriptionFactors
    for i in Atac.columns:
        tfTemp=np.unique(tf.iloc[np.where(tf.iloc[:,1]==i)[0],0])
        relationMatrix.loc[i,tfTemp]=1
    relationMatrix=relationMatrix.loc[:, (relationMatrix != 0).any(axis=0)]
    transcriptionFactors=np.asarray(relationMatrix.T.index)


class provaEncoder(keras.constraints.Constraint):
    def __call__(self, w):
        return tsf.math.multiply(w,tsf.constant(np.asarray(relationMatrix),tsf.float32))
class provaDecoder(keras.constraints.Constraint):
    def __call__(self, w):
        return tsf.math.multiply(w,tsf.transpose(tsf.constant(np.asarray(relationMatrix),tsf.float32)))

minFeature=relationMatrix.shape[1]

try:
    os.mkdir("./Results/")
except OSError:
    print ("Creation of the directory %s failed" % "./Results/")
else:
    print ("Successfully created the directory %s " % "./Results/")
    
try:
    os.mkdir("./Results/"+projectName)
except OSError:
    print ("Creation of the directory %s failed" % "./Results/"+projectName)
    now = datetime.datetime.now()
    projectName=projectName+str(now.year)+"_"+str(now.month)+"_"+str(now.day)+"_"+str(now.hour)+"_"+str(now.minute)+"_"+str(now.second)
    os.mkdir("./Results/"+projectName)
else:
    print ("Successfully created the directory %s " % "./Results/"+projectName)


    
try:
    os.mkdir("./Results/"+projectName+"/permutation")
except OSError:
    print ("Creation of the directory %s failed" % "./Results/"+projectName+"/permutation")
else:
    print ("Successfully created the directory %s " % "./Results/"+projectName+"/permutation")
    
copyfile(matrix,"./Results/"+projectName+"/"+matrix)
extension = os.path.splitext(matrix)[-1]


autoencoder = Sequential()
autoencoder.add(Dense(minFeature, activation='relu',name="encoder4",input_shape=(Atac.shape[1],),kernel_constraint=provaEncoder()))
autoencoder.add(Dense(Atac.shape[1], activation='relu',name="decoder4",kernel_constraint=provaDecoder()))
autoencoder.compile(optimizer=keras.optimizers.Adam( lr=lrVar, beta_1=beta_1Var, beta_2=beta_2Var, epsilon=epsilonVar, decay=decayVar), loss=lossVar)
autoencoder.summary()
checkpoint_name = './Results/'+projectName+'/BW.hdf5'
checkpoint = keras.callbacks.ModelCheckpoint(checkpoint_name, monitor='val_loss', verbose = 0, save_best_only = True, mode ='max')
es = EarlyStopping(monitor='val_loss', mode='min', verbose=1, patience=nEpochs/patiencePercentage)
callbacks_list = [checkpoint,es]
autoencoder_train = autoencoder.fit(Atac, Atac, batch_size=Atac.shape[0], epochs=nEpochs,validation_data=(Atac, Atac),callbacks=callbacks_list)
pyplot.plot(autoencoder_train.history['loss'], label='train')
pyplot.plot(autoencoder_train.history['val_loss'], label='test')
pyplot.legend()
pyplot.savefig('./Results/'+projectName+"/"+str(index)+'learning.png')
autoencoder.load_weights('./Results/'+projectName+"/BW.hdf5")
encoder = Sequential()
encoder.add(Dense(minFeature, activation='relu',name="encoder4",input_shape=(Atac.shape[1],),kernel_constraint=provaEncoder()))
encoder.layers[0].set_weights(autoencoder.layers[0].get_weights())
denseSpace=encoder.predict(Atac)
plt.clf()
ds=pd.DataFrame(denseSpace)
ds.index=Atac.index
ds.columns=relationMatrix.columns
dsD=np.log2((pd.DataFrame(np.asarray(ds.T).argsort(axis=0)/np.asarray(ds.T).argsort(axis=0).max()*100))+1)
dsD.index=relationMatrix.columns
dsD.columns=Atac.index
#dsD.to_csv("./Results/"+projectName+"/permutation/"+str(nPerm)+"denseSpace"+extension,sep=sep)
ds.T.to_csv("./Results/"+projectName+"/permutation/"+str(index)+"denseSpace"+extension,sep=sep)


os.system("chmod -R 777 /scratch")








