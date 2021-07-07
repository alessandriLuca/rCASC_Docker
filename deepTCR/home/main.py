import sys
import os
sys.path.append('../../')
from DeepTCR.DeepTCR import DeepTCR_U
filesPath=sys.argv[1]
os.chdir("/scratch")
# Instantiate training object
DTCRU = DeepTCR_U(filesPath)

#Load Data from directories
DTCRU.Get_Data(directory='/scratch/'+filesPath,Load_Prev_Data=False,aggregate_by_aa=True,
               aa_column_beta=0,count_column=1,v_beta_column=2,j_beta_column=3)
DTCRU.Train_VAE(Load_Prev_Data=False)

os.mkdir('./'+filesPath+'_Results/phenograph')
DTCRU.Cluster(clustering_method='phenograph',write_to_sheets=True)
DTCRU.UMAP_Plot(by_cluster=True,filename="./phenograph/phenograph.png")
DTCRU.Motif_Identification("32Z_TCRLR_AJC_TetPos_IonDual_A3_0117_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("32Z_TCRLR_GDL_TetPos_IonDual_G2_0115_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("47Z_TCR_LR_GDL_D1_IonDual_B8_0158_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("47Z_TCR_LR_GDL_D2_IonDual_B9_0166_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("56Z_GDL_D14_TETplus_IonDual_C3_0119_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("56Z_GDL_D7_TETplus_IonDual_E3_0121_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("57Z_TCRLR_BC1_TetPos_IonDual_A4_0125_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("57Z_TCRLR_BC2_TetPos_IonDual_B4_0126_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
os.system("mv ./"+filesPath+"_Results/Cluster* ./"+filesPath+"_Results/phenograph/")
os.system("mv ./"+filesPath+"_Results/*Motifs ./"+filesPath+"_Results/phenograph/")



os.mkdir('./'+filesPath+'_Results/hierarchical')
DTCRU.Cluster(clustering_method='hierarchical',write_to_sheets=True)
DTCRU.UMAP_Plot(by_cluster=True,filename="./hierarchical/hierarchical.png")
DTCRU.Motif_Identification("32Z_TCRLR_AJC_TetPos_IonDual_A3_0117_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("32Z_TCRLR_GDL_TetPos_IonDual_G2_0115_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("47Z_TCR_LR_GDL_D1_IonDual_B8_0158_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("47Z_TCR_LR_GDL_D2_IonDual_B9_0166_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("56Z_GDL_D14_TETplus_IonDual_C3_0119_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("56Z_GDL_D7_TETplus_IonDual_E3_0121_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("57Z_TCRLR_BC1_TetPos_IonDual_A4_0125_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("57Z_TCRLR_BC2_TetPos_IonDual_B4_0126_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
os.system("mv ./"+filesPath+"_Results/Cluster* ./"+filesPath+"_Results/hierarchical/")
os.system("mv ./"+filesPath+"_Results/*Motifs ./"+filesPath+"_Results/hierarchical/")


os.mkdir('./'+filesPath+'_Results/hierarchicalWDistance')
DTCRU.Cluster(clustering_method='hierarchical',criterion='distance',t=1.0,write_to_sheets=True)
DTCRU.UMAP_Plot(by_cluster=True,filename="./hierarchicalWDistance/hierarchicalWDistance.png")
DTCRU.Motif_Identification("32Z_TCRLR_AJC_TetPos_IonDual_A3_0117_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("32Z_TCRLR_GDL_TetPos_IonDual_G2_0115_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("47Z_TCR_LR_GDL_D1_IonDual_B8_0158_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("47Z_TCR_LR_GDL_D2_IonDual_B9_0166_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("56Z_GDL_D14_TETplus_IonDual_C3_0119_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("56Z_GDL_D7_TETplus_IonDual_E3_0121_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("57Z_TCRLR_BC1_TetPos_IonDual_A4_0125_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("57Z_TCRLR_BC2_TetPos_IonDual_B4_0126_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
os.system("mv ./"+filesPath+"_Results/Cluster* ./"+filesPath+"_Results/hierarchicalWDistance/")
os.system("mv ./"+filesPath+"_Results/*Motifs ./"+filesPath+"_Results/hierarchicalWDistance/")






os.mkdir('./'+filesPath+'_Results/dbscan')
DTCRU.Cluster(clustering_method='dbscan',write_to_sheets=True)
DTCRU.UMAP_Plot(by_cluster=True,filename="./dbscan/dbscan.png")
DTCRU.Motif_Identification("32Z_TCRLR_AJC_TetPos_IonDual_A3_0117_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("32Z_TCRLR_GDL_TetPos_IonDual_G2_0115_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("47Z_TCR_LR_GDL_D1_IonDual_B8_0158_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("47Z_TCR_LR_GDL_D2_IonDual_B9_0166_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("56Z_GDL_D14_TETplus_IonDual_C3_0119_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("56Z_GDL_D7_TETplus_IonDual_E3_0121_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("57Z_TCRLR_BC1_TetPos_IonDual_A4_0125_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("57Z_TCRLR_BC2_TetPos_IonDual_B4_0126_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
os.system("mv ./"+filesPath+"_Results/Cluster* ./"+filesPath+"_Results/dbscan/")
os.system("mv ./"+filesPath+"_Results/*Motifs ./"+filesPath+"_Results/dbscan/")



os.mkdir('./'+filesPath+'_Results/phenograph500Sample')
DTCRU.Cluster(clustering_method='phenograph',sample=500,write_to_sheets=True)
DTCRU.UMAP_Plot(by_cluster=True,filename="./phenograph500Sample/phenograph500Sample.png")
DTCRU.Motif_Identification("32Z_TCRLR_AJC_TetPos_IonDual_A3_0117_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("32Z_TCRLR_GDL_TetPos_IonDual_G2_0115_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("47Z_TCR_LR_GDL_D1_IonDual_B8_0158_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("47Z_TCR_LR_GDL_D2_IonDual_B9_0166_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("56Z_GDL_D14_TETplus_IonDual_C3_0119_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("56Z_GDL_D7_TETplus_IonDual_E3_0121_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("57Z_TCRLR_BC1_TetPos_IonDual_A4_0125_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
DTCRU.Motif_Identification("57Z_TCRLR_BC2_TetPos_IonDual_B4_0126_deeptcr", p_val_threshold=0.05, by_samples=False, top_seq=10)
os.system("mv ./"+filesPath+"_Results/Cluster* ./"+filesPath+"_Results/phenograph500Sample/")
os.system("mv ./"+filesPath+"_Results/*Motifs ./"+filesPath+"_Results/phenograph500Sample/")






os.system("chmod -R 777 /scratch/")
