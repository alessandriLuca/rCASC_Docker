import random
import sys
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
    return K.switch(x > 0, tsf.math.log(x), 0)


def end_1(x):
    return K.switch(x > 0, tsf.math.exp(x), 0)


def act_2(x):
    return tsf.math.tanh(x)


def end_2(x):
    return tsf.math.atanh(x)


try:
    os.mkdir("./Results/")
except OSError:
    print("Creation of the directory %s failed" % "./Results/")
else:
    print("Successfully created the directory %s " % "./Results/")

matrix = sys.argv[1]
sep = sys.argv[2]
nEpochs = int(sys.argv[3])
patiencePercentage = int(sys.argv[4])
random.seed(sys.argv[5])
bName = sys.argv[6]
lrFile = sys.argv[7]
lossVar = sys.argv[8]
weight_changer = sys.argv[9]
permutation = int(sys.argv[10])

lrArray = []
min_loss = []
change_fully = False

lrF = open(lrFile, 'r')

for x in lrF:
    lrArray.append(float(x))

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

if weight_changer != '':
    if os.path.isfile(weight_changer):
        weight_changer = pd.read_csv(weight_changer, index_col=0, sep=sep)
    else:
        #create weight_changer
        weight_changer = pd.DataFrame(np.zeros((Atac.shape[1], Atac.shape[1])))
        for i in range(0, weight_changer.shape[0]):
            for j in range(0, weight_changer.shape[0]):
                if i == j:
                    weight_changer[i][j] = 0.8
                else:
                    weight_changer[i][j] = 0.3
            print(weight_changer.shape[0] - i)
        weight_changer.to_csv(weight_changer)
    change_fully = True

NN = Sequential()
for lr in lrArray:
    NN = Sequential()
    if change_fully:
        NN.add(Dense(Atac.shape[1], activation=act_1, name="encoder4", input_shape=(Atac.shape[1],),
                     kernel_constraint=changeWeightFully()))
    else:
        NN.add(Dense(Atac.shape[1], activation=act_1, name="encoder4", input_shape=(Atac.shape[1],)))
    NN.add(Dense(minFeature, activation=act_2, name="hidden", kernel_constraint=changeWeightEncoding()))
    NN.add(Dense(Atac.shape[1], activation=end_2, name="Sparse", kernel_constraint=changeWeightDecoding()))
    if change_fully:
        NN.add(Dense(Atac.shape[1], activation=end_1, name="Output", kernel_constraint=changeWeightFully()))
    else:
        NN.add(Dense(Atac.shape[1], activation=end_1, name="Output"))
    NN.compile(loss=lossVar, optimizer=Adam(learning_rate=lr))

    checkpoint_name = './Results/BW_' + str(lr) + '.hdf5'
    checkpoint = keras.callbacks.ModelCheckpoint(checkpoint_name, monitor='loss', verbose=0, save_best_only=True,
                                                 mode='max')
    es = EarlyStopping(monitor='loss', mode='min', verbose=1, patience=nEpochs / patiencePercentage)
    callbacks_list = [checkpoint, es]

    a = NN.fit(Atac, Atac, epochs=nEpochs, validation_data=(Atac, Atac), callbacks=callbacks_list,
               batch_size=Atac.shape[1], verbose=1)
    pyplot.plot(a.history['loss'], label='train')
    pyplot.legend()
    pyplot.savefig('./Results/learning_' + str(lr) + '.png')
    pyplot.clf()

    min_loss.append(min(a.history['loss']))

minimum = float('inf')
tmp = 0
for k in range(len(min_loss)):
    if min_loss[k] < minimum:
        minimum = min_loss[k]
        tmp = k

NN.load_weights('./Results/BW_' + str(lrArray[tmp]) + '.hdf5')

DFexample=pd.DataFrame(columns=Atac.index)
for nPerm in range(permutation):
    encoder = Sequential()
    if change_fully:
        encoder.add(Dense(Atac.shape[1], activation=act_1, name="encoder4", input_shape=(Atac.shape[1],),
                          kernel_constraint=changeWeightFully()))
    else:
        encoder.add(Dense(Atac.shape[1], activation=act_1, name="encoder4", input_shape=(Atac.shape[1],)))
    encoder.add(Dense(minFeature, activation=act_2, name="hidden", kernel_constraint=changeWeightEncoding()))
    encoder.layers[0].set_weights(NN.layers[0].get_weights())
    encoder.layers[1].set_weights(NN.layers[1].get_weights())
    Result = encoder.predict(Atac)

    ds = pd.DataFrame(Result)
    ds.index = Atac.index
    ds.columns = relationMatrix.columns
    ds.columns = [str(newn) + '.' + str(nPerm) for newn in ds.columns]
    ds.to_csv('Results/denseSpace_' + str(nPerm) + '.csv', sep=sep)
    DFexample=DFexample.append(ds.T)

DFexample=DFexample.T
DFexample.to_csv('Results/permutation_total_' + str(lrArray[tmp]) + '.csv', sep=sep)
