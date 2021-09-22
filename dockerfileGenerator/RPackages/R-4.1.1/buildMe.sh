#!/bin/bash 
#Modify ./toBeInstalled/libraryInstall.R with all the necessaries libraries
mv Dockerfile_1 Dockerfile
sudo docker build . -t $1
sudo docker run -itv $(pwd)/toBeInstalled:/scratch $1 /scratch/1_libraryInstall.sh
mv Dockerfile Dockerfile_1
mv Dockerfile_2 Dockerfile
sudo docker build . -t $1
mv Dockerfile Dockerfile_2


