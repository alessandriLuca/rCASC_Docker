#!/bin/bash 
#Modify ./toBeInstalled/libraryInstall.R with all the necessaries libraries
if [ $# -eq 0 ]
  then
    echo "You need to provide a docker tag, for example ./buildMe.sh dockertest"
    exit
fi

sudo chmod 777 toBeInstalled/1_libraryInstall.sh
mv Dockerfile_1 Dockerfile
sudo docker build . -t $1
sudo docker run -itv $(pwd)/toBeInstalled:/scratch $1 /scratch/1_libraryInstall.sh
mv Dockerfile Dockerfile_1
mv Dockerfile_2 Dockerfile
sudo docker build . -t $1
mv Dockerfile Dockerfile_2
mkdir dockerFolder 
cp Dockerfile_2 ./dockerFolder/Dockerfile
cp -r ./R-2.15.3 ./dockerFolder/R-2.15.3
mkdir ./dockerFolder/toBeInstalled
cp ./toBeInstalled/*.7z* ./dockerFolder/toBeInstalled/
cp ./pcre2-10.37.tar.gz ./dockerFolder/pcre2-10.37.tar.gz
cp -r ./p7zip_16.02 ./dockerFolder/
cp ./toBeInstalled/listForDockerfile.sh ./dockerFolder/toBeInstalled/listForDockerfile.sh
