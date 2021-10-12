#!/bin/bash 
#Modify ./toBeInstalled/libraryInstall.R with all the necessaries libraries
if [ $# -eq 0 ]
  then
    echo "You need to provide a temporary docker tag, for example ./buildMe.sh dockertest"
    exit
fi
sudo docker rmi -f $1
mv Dockerfile_1 Dockerfile
sudo docker build . -t $1
cp configurationFile.sh ./toBeInstalled/
sudo docker run -itv $(pwd)/toBeInstalled:/scratch $1 /scratch/1_libraryInstall.sh
mv Dockerfile Dockerfile_1
mv Dockerfile_2 Dockerfile
sudo docker build . -t $1
mv Dockerfile Dockerfile_2
mkdir dockerFolder 
cp Dockerfile_2 ./dockerFolder/Dockerfile
cp Python-3.8.6.tgz ./dockerFolder/
mkdir ./dockerFolder/toBeInstalled
cp ./toBeInstalled/*.7z* ./dockerFolder/toBeInstalled/
cp ./pipdeptree-2.1.0-py3-none-any.whl ./dockerFolder/
cp -r ./p7zip_16.02 ./dockerFolder/
cp ./toBeInstalled/listForDockerfile.sh ./dockerFolder/toBeInstalled/listForDockerfile.sh
rm ./toBeInstalled/*.txt
rm ./toBeInstalled/*.log
rm ./toBeInstalled/*.7z*
rm -r ./toBeInstalled/packages
rm ./toBeInstalled/listForDockerfile.sh
rm ./toBeInstalled/configurationFile.sh
echo 'DockerFile generation is done. Locate in DockerFolder and build your final docker.'
sudo docker rmi -f $1
