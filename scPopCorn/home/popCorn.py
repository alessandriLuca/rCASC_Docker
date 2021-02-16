
import numpy as np
import matplotlib.pyplot as plt
import pickle
import random
from random import sample 
from matplotlib import pyplot
import os
import scipy.io
import pandas as pd
from sklearn.manifold import TSNE
import sys
from sklearn.cluster import KMeans
import subprocess
from shutil import copyfile
import matplotlib.cm as cm    
import stat
from scpopcorn import MergeSingleCell
from scpopcorn import SingleCellData
os.chdir("/scratch")
#filename1="pancreas_human.expressionMatrix.txt"
#filename2="pancreas_mouse.expressionMatrix.txt"
#filename3="pancreas_human.CellLabels.txt"
#filename4="pancreas_mouse.CellLabels.txt"
#filename1="set1_interest.csv"
#filename2="setA_interest.csv"
#filename3="set1_interest_SAVER_clustering.output.csv"
#filename4="setA_interest_SAVER_clustering.output.csv"
filename1=sys.argv[1]
filename2=sys.argv[2]
extension1=os.path.splitext(filename1)[-1]
extension2=os.path.splitext(filename2)[-1]
sep=sys.argv[3]
if(sep=="tab"):
    sep="\t"
filename3=sys.argv[4]
filename4=sys.argv[5]
nCluster=int(sys.argv[6])
random.seed(sys.argv[7])

extension3=os.path.splitext(filename3)[-1]
extension4=os.path.splitext(filename4)[-1]

F1=pd.read_csv(filename1,sep=sep,index_col=0)
F1.to_csv(filename1.split(extension1)[0]+".txt",sep="\t")
F2=pd.read_csv(filename2,sep=sep,index_col=0)
F2.to_csv(filename2.split(extension2)[0]+".txt",sep="\t")
F3=pd.read_csv(filename3,sep=sep,index_col=0)
F3.to_csv(filename3.split(extension3)[0]+".txt",sep="\t")
F4=pd.read_csv(filename4,sep=sep,index_col=0)
F4.to_csv(filename4.split(extension4)[0]+".txt",sep="\t")

File1 = filename1.split(extension1)[0]+".txt"
Test1 = SingleCellData()
Test1.ReadData_SeuratFormat(File1)

File2 = filename2.split(extension2)[0]+".txt"
Test2 = SingleCellData()
Test2.ReadData_SeuratFormat(File2)


File1T = filename3.split(extension3)[0]+".txt"
Test1.ReadTurth(File1T, 0, 1)
Test1.ClusterLabel = [i for i in Test1.ClusterLabel if i!="None"]
File2T = filename4.split(extension4)[0]+".txt"
Test2.ReadTurth(File2T, 0, 1)
Test2.ClusterLabel = [i for i in Test2.ClusterLabel if i!="None"]



Test1.Normalized_per_Cell()
Test1.FindHVG()
Test1.Log1P()

Test2.Normalized_per_Cell()
Test2.FindHVG()
Test2.Log1P()


NumSuperCell_Test1 = int(F1.shape[1]/20)
NumSuperCell_Test2 = int(F2.shape[1]/20)

MSingle = MergeSingleCell(Test1, Test2)
MSingle.MultiDefineSuperCell(NumSuperCell_Test1,NumSuperCell_Test2)

MSingle.ConstructWithinSimiarlityMat_SuperCellLevel()
MSingle.ConstructBetweenSimiarlityMat_SuperCellLevel()

Estimate_NumCluster = nCluster/2 # initial guess of number of corresponding clusters, do not need to be accurate!!!
MSingle.SDP_NKcut(Estimate_NumCluster)

NumCluster_Min = 3 
NumCluster_Max = nCluster
CResult = MSingle.NKcut_Rounding(NumCluster_Min, NumCluster_Max)
MSingle.Evaluation(CResult)
MSingle.StatResult()
MSingle.Umap_Result()



MSingle.OutputResult("TestOut.txt")




