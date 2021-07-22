import sys
import os
sys.path.append('../../')
from DeepTCR.DeepTCR import DeepTCR_U
from DeepTCR.DeepTCR import DeepTCR_SS
filesPath=sys.argv[1]
os.chdir("/scratch")
# Instantiate training object
DTCRU = DeepTCR_SS(filesPath)
#Load Data from directories
DTCRU.Get_Data(directory='/scratch/'+filesPath,Load_Prev_Data=False,aggregate_by_aa=True,
               aa_column_beta=0,count_column=1,v_beta_column=2,j_beta_column=3)
DTCRU.Get_Train_Valid_Test()
DTCRU.Train()
DTCRU.AUC_Curve()
DTCRU.Representative_Sequences(100)
DTCRU.UMAP_Plot(by_class=True,freq_weight=True,scale=1000)
os.mkdir('./'+filesPath+'_Results/Standard_train')
os.system("mv ./"+filesPath+"_Results/AUC* ./"+filesPath+"_Results/Standard_train/")
os.system("mv ./"+filesPath+"_Results/*Sequences ./"+filesPath+"_Results/Standard_train/")
os.system("mv ./"+filesPath+"_Results/*Motifs* ./"+filesPath+"_Results/Standard_train/")

DTCRU.Monte_Carlo_CrossVal(test_size=0.25,folds=5)
DTCRU.AUC_Curve()
DTCRU.Representative_Sequences()
DTCRU.UMAP_Plot(by_class=True,freq_weight=True,scale=1000)
os.mkdir('./'+filesPath+'_Results/monteCarlo')
os.system("mv ./"+filesPath+"_Results/AUC* ./"+filesPath+"_Results/monteCarlo/")
os.system("mv ./"+filesPath+"_Results/*Sequences ./"+filesPath+"_Results/monteCarlo/")
os.system("mv ./"+filesPath+"_Results/*Motifs* ./"+filesPath+"_Results/monteCarlo/")


DTCRU.K_Fold_CrossVal(folds=5)
DTCRU.AUC_Curve()
DTCRU.Representative_Sequences()
DTCRU.UMAP_Plot(by_class=True,freq_weight=True,scale=1000)
os.mkdir('./'+filesPath+'_Results/K_Fold_CrossVal')
os.system("mv ./"+filesPath+"_Results/AUC* ./"+filesPath+"_Results/K_Fold_CrossVal/")
os.system("mv ./"+filesPath+"_Results/*Sequences ./"+filesPath+"_Results/K_Fold_CrossVal/")
os.system("mv ./"+filesPath+"_Results/*Motifs* ./"+filesPath+"_Results/K_Fold_CrossVal/")
os.system("chmod -R 777 /scratch/")
