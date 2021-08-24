import sys
import random

import keras
import tensorflow as tsf
import numpy as np
import pandas as pd
from keras.models import Sequential
from keras.layers import Dense
from keras.optimizers import Adam
from matplotlib import pyplot
from keras.callbacks import EarlyStopping
from keras import backend as K
import os

os.chdir('/scratch')

try:
    os.mkdir("./Results/")
except OSError:
    print ("Creation of the directory %s failed" % "./Results/")
else:
    print ("Successfully created the directory %s " % "./Results/")


class changeWeightEncoding(keras.constraints.Constraint):
    def __call__(self, w):
        return tsf.math.multiply(w, tsf.constant(np.asarray(relationMatrix), tsf.float32))


class changeWeightDecoding(keras.constraints.Constraint):
    def __call__(self, w):
        return tsf.math.multiply(w, tsf.transpose(tsf.constant(np.asarray(relationMatrix), tsf.float32)))


class changeWeightFully(keras.constraints.Constraint):
    def __call__(self, w):
        return tsf.math.multiply(w, tsf.transpose(tsf.constant(np.asarray(weight_changer), tsf.float32)))


def act_1(x):
    return tsf.math.divide(x, 13)

def end_1(x):
    return tsf.math.multiply(x, 13)

def act_2(x):
    return tsf.math.tanh(x)

def end_2(x):
    return tsf.math.atanh(x)


matrix = sys.argv[1]
sep = sys.argv[2]
nEpochs = int(sys.argv[3])
patiencePercentage = int(sys.argv[4])
random.seed(sys.argv[5])
bName = sys.argv[6]
lrVar = float(sys.argv[7])
lossVar = sys.argv[8]
weight_changer = sys.argv[9]

Atac = pd.read_csv(matrix, index_col=0, sep=sep)

tf = pd.read_csv(bName, sep=sep, header=0)
tf = tf.iloc[:, [1, 0]]
transcriptionFactors = np.unique(tf.iloc[:, 0])
relationMatrix = pd.DataFrame(np.zeros((Atac.columns.shape[0], transcriptionFactors.shape[0])))
relationMatrix.index = Atac.columns
relationMatrix.columns = transcriptionFactors
for i in Atac.columns:
    tfTemp = np.unique(tf.iloc[np.where(tf.iloc[:, 1] == i)[0], 0])
    relationMatrix.loc[i, tfTemp] = 1
relationMatrix = relationMatrix.loc[:, (relationMatrix != 0).any(axis=0)]
transcriptionFactors = np.asarray(relationMatrix.T.index)

minFeature = relationMatrix.shape[1]

weight_changer = pd.read_csv(weight_changer, index_col=0, sep=sep)

NN = Sequential()
NN.add(Dense(Atac.shape[1], activation=act_1, name="encoder4", input_shape=(Atac.shape[1],),
             kernel_constraint=changeWeightFully()))
NN.add(Dense(minFeature, activation=act_2, name="hidden", kernel_constraint=changeWeightEncoding()))
NN.add(Dense(Atac.shape[1], activation=end_2, name="Sparse", kernel_constraint=changeWeightDecoding()))
NN.add(Dense(Atac.shape[1], activation=end_1, name="Output", kernel_constraint=changeWeightFully()))
NN.compile(loss=lossVar, optimizer=Adam(learning_rate=lrVar))

checkpoint_name = './Results/BW.hdf5'
checkpoint = keras.callbacks.ModelCheckpoint(checkpoint_name, monitor='loss', verbose=0, save_best_only=True,
                                             mode='max')
es = EarlyStopping(monitor='loss', mode='min', verbose=1, patience=nEpochs / patiencePercentage)
callbacks_list = [checkpoint, es]

a = NN.fit(Atac, Atac, epochs=nEpochs, validation_data=(Atac, Atac), callbacks=callbacks_list)
pyplot.plot(a.history['loss'], label='train')
pyplot.legend()
pyplot.savefig('./Results/learning.png')

NN.load_weights('./Results/BW.hdf5')

encoder = Sequential()
encoder.add(Dense(Atac.shape[1], activation=act_1, name="encoder4", input_shape=(Atac.shape[1],),
                  kernel_constraint=changeWeightFully()))
encoder.add(Dense(minFeature, activation=act_2, name="hidden", kernel_constraint=changeWeightEncoding()))
encoder.layers[0].set_weights(NN.layers[0].get_weights())
encoder.layers[1].set_weights(NN.layers[1].get_weights())
Result = encoder.predict(Atac)

pyplot.clf()

ds = pd.DataFrame(Result)
ds.index = Atac.index
ds.columns = relationMatrix.columns
ds.columns = [str(newn) for newn in ds.columns]
ds.to_csv('Results/denseSpace.csv', sep=sep)
