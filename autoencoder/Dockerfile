FROM library/ubuntu as UBUNTU_BASE
MAINTAINER alessandri.luca1991@gmail.com
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev wget \
    && apt-get -y install libblas-dev liblapack-dev \
    && apt-get -y install libatlas-base-dev \
    && apt-get -y install gfortran \
    && apt-get -y install libxml2-dev libxmlsec1-dev \
    && apt-get install -y libbz2-dev
COPY ["library*","/tmp/"]
COPY p7zip_16.02 /tmp/

RUN apt-get update \
    && apt-get install -y wget \
    && mkdir data \
	&& apt-get -y install build-essential \
	&& cd /tmp/ && make \
	&& make all \
	&& cp ./bin/7za /bin

RUN cd /tmp/ &&  7za -y x "*.7z*"
RUN tar -xzvf /tmp/Python-3.8.6.tgz
RUN cd /Python-3.8.6/ && ./configure
RUN cd /Python-3.8.6/ && make
RUN cd /Python-3.8.6/ && make install
RUN pip3 install /tmp/pip-20.3.3.tar.gz
RUN pip3 install /tmp/numpy-1.19.5-cp38-cp38-manylinux2010_x86_64.whl
RUN pip3 install /tmp/scipy-1.6.0.tar.gz
RUN pip3 install /tmp/PyYAML-5.3.1.tar.gz
RUN apt-get -y install pkg-config
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN pip3 install /tmp/setuptools-51.1.2.tar.gz
RUN pip3 install /tmp/wheel-0.36.2.tar.gz
RUN apt-get -y install libhdf5-dev
RUN pip3 install /tmp/h5py-3.1.0-cp38-cp38-manylinux1_x86_64.whl
RUN pip3 install /tmp/Keras-2.4.3.tar.gz
RUN pip3 install /tmp/tensorflow-2.3.2-cp38-cp38-manylinux2010_x86_64.whl
RUN pip3 install /tmp/matplotlib-3.3.3-cp38-cp38-manylinux1_x86_64.whl
RUN pip3 install /tmp/scikit_learn-0.24.1-cp38-cp38-manylinux2010_x86_64.whl
RUN pip3 install /tmp/pandas-1.2.1-cp38-cp38-manylinux1_x86_64.whl
COPY home/* /home/
RUN mkdir -p /data/
RUN mkdir -p /scratch/
RUN apt-get update
RUN apt-get install tree
