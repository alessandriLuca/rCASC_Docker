FROM library/ubuntu:18.04 as UBUNTU_BASE
MAINTAINER alessandri.luca1991@gmail.com
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get -y install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev wget
RUN apt-get -y install libblas-dev liblapack-dev
RUN apt-get -y install libatlas-base-dev 
RUN apt-get -y install gfortran
RUN apt-get -y install libxml2-dev libxmlsec1-dev
RUN apt-get install -y libbz2-dev
COPY ["home*","/tmp/"]
RUN cat /tmp/home* > /tmp/OutputBig.tar.bz2
RUN cd /tmp/ && tar -xjvf /tmp/OutputBig.tar.bz2 
RUN tar -xzvf /tmp/home/user/dockerFile/neuralnetworkmet/files/Python-3.8.6.tgz
RUN cd /Python-3.8.6/ && ./configure
RUN cd /Python-3.8.6/ && make
RUN cd /Python-3.8.6/ && make install
RUN pip3 install /tmp/home/user/dockerFile/neuralnetworkmet/files/pip-20.3.3.tar.gz
RUN pip3 install /tmp/home/user/dockerFile/neuralnetworkmet/files/numpy-1.19.5-cp38-cp38-manylinux2010_x86_64.whl
RUN pip3 install /tmp/home/user/dockerFile/neuralnetworkmet/files/scipy-1.6.0.tar.gz
RUN pip3 install /tmp/home/user/dockerFile/neuralnetworkmet/files/PyYAML-5.3.1.tar.gz
RUN apt-get -y install pkg-config
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN pip3 install /tmp/home/user/dockerFile/neuralnetworkmet/files/setuptools-51.1.2.tar.gz
RUN pip3 install /tmp/home/user/dockerFile/neuralnetworkmet/files/wheel-0.36.2.tar.gz
RUN apt-get -y install libhdf5-dev
RUN pip3 install /tmp/home/user/dockerFile/neuralnetworkmet/files/h5py-3.1.0-cp38-cp38-manylinux1_x86_64.whl
RUN pip3 install /tmp/home/user/dockerFile/neuralnetworkmet/files/Keras-2.4.3.tar.gz
RUN pip3 install /tmp/home/user/dockerFile/neuralnetworkmet/files/tensorflow-2.3.2-cp38-cp38-manylinux2010_x86_64.whl
RUN pip3 install /tmp/home/user/dockerFile/neuralnetworkmet/files/matplotlib-3.3.3-cp38-cp38-manylinux1_x86_64.whl
RUN pip3 install /tmp/home/user/dockerFile/neuralnetworkmet/files/scikit_learn-0.24.1-cp38-cp38-manylinux2010_x86_64.whl
RUN pip3 install /tmp/home/user/dockerFile/neuralnetworkmet/files/pandas-1.2.1-cp38-cp38-manylinux1_x86_64.whl
COPY home/* /home/
RUN mkdir -p /data/
RUN mkdir -p /scratch/
RUN apt-get update
RUN apt-get install tree
