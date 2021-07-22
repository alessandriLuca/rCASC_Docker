import sys
import os
sys.path.append('../../')
from DeepTCR.DeepTCR import DeepTCR_U
import pandas as pd
filesPath=sys.argv[1]
positivePath=sys.argv[2]
negativePath=sys.argv[3] 
os.chdir("/scratch")
# Instantiate training object
temp=pd.read_csv(filesPath,sep="\t")
temp=temp.iloc[:,[22,1,3,5]]
temp.iloc[:,2]=temp.iloc[:,2].iloc[:,].str.split("*", 1, expand=True).iloc[:,0]
temp.iloc[:,3]=temp.iloc[:,3].iloc[:,].str.split("*", 1, expand=True).iloc[:,0]
baseName=filesPath.split("_")[0]
os.mkdir('./'+baseName)
temp.columns=["beta","counts","v_beta","j_beta"]
temp.to_csv('./'+baseName+"/"+baseName+".tsv",sep="\t",index=False)


DTCRU_rudq = DeepTCR_U(baseName)
#Load Data from directories
DTCRU_rudq.Get_Data(directory='/scratch/'+baseName,Load_Prev_Data=False,aggregate_by_aa=True,aa_column_beta=0,count_column=1,v_beta_column=2,j_beta_column=3)

beta_sequences = DTCRU_rudq.beta_sequences
v_beta = DTCRU_rudq.v_beta
j_beta = DTCRU_rudq.j_beta



DTCRU = DeepTCR_U(positivePath)
DTCRU.Get_Data(directory='/scratch/'+positivePath+"/",Load_Prev_Data=False,aggregate_by_aa=True,
               aa_column_beta=0,count_column=1,v_beta_column=2,j_beta_column=3)
DTCRU.Train_VAE(Load_Prev_Data=False)





features = DTCRU.Sequence_Inference(beta_sequences=beta_sequences,v_beta=v_beta,j_beta=j_beta)


import umap
umap_obj = umap.UMAP()
features_orig = umap_obj.fit_transform(DTCRU.features)
import matplotlib.pyplot as plt
plt.scatter(features_orig[:,0],features_orig[:,1])
plt.savefig("/scratch/"+baseName+"_Results/"+positivePath+".png")
features_new = umap_obj.transform(features)
plt.scatter(features_new[:,0],features_new[:,1])
plt.savefig("/scratch/"+baseName+"_Results/tetP_"+positivePath+"_"+baseName+".png")



DTCRU = DeepTCR_U(negativePath)
DTCRU.Get_Data(directory='/scratch/'+negativePath+"/",Load_Prev_Data=False,aggregate_by_aa=True,
               aa_column_beta=0,count_column=1,v_beta_column=2,j_beta_column=3)
DTCRU.Train_VAE(Load_Prev_Data=False)





features = DTCRU.Sequence_Inference(beta_sequences=beta_sequences,v_beta=v_beta,j_beta=j_beta)


import umap
umap_obj = umap.UMAP()
features_orig = umap_obj.fit_transform(DTCRU.features)
import matplotlib.pyplot as plt
plt.scatter(features_orig[:,0],features_orig[:,1])
plt.savefig("/scratch/"+baseName+"_Results/"+negativePath+"_Original.png")
features_new = umap_obj.transform(features)
plt.scatter(features_new[:,0],features_new[:,1])
plt.savefig("/scratch/"+baseName+"_Results/"+negativePath+"_"+baseName+".png")




os.system("chmod -R 777 /scratch/")
