FROM library/ubuntu:18.04 as UBUNTU_BASE
ARG DEBIAN_FRONTEND=noninteractive
LABEL maintainer="alessandri.luca1991@gmail.com"

COPY p7zip_16.02 /tmp/

RUN apt-get update \
    && apt-get install -y wget \
    && mkdir data \
	&& apt-get -y install build-essential \
	&& cd /tmp/ && make \
	&& make all \
	&& cp ./bin/7za /bin

COPY *.7z* /tmp/ 
RUN cd /tmp && 7za -y x "*.7z*"
RUN mkdir -p /data/
RUN mkdir -p /scratch/
RUN apt-get update
RUN apt-get install tree
RUN apt update
RUN apt install -y openjdk-8-jdk
RUN apt install -y libz-dev
RUN cd /tmp/temp/seqtk && make
COPY gibbscluster-2.0 /gibbscluster-2.0/
RUN apt-get install -y software-properties-common
RUN add-apt-repository universe
RUN apt update
RUN apt install -y tcsh
COPY seq2logo-2.1 /seq2logo-2.1 
RUN apt-get remove --auto-remove -y python*
COPY Python-2.7.tar.gz /
RUN tar -xvf /Python-2.7.tar.gz
RUN cd /Python-2.7/ && ./configure 
RUN cd /Python-2.7/ && make
RUN cd /Python-2.7/ && make install 
RUN apt install -y python-pip
COPY numpy-1.16.6-cp27-cp27mu-manylinux1_x86_64.whl /numpy-1.16.6-cp27-cp27mu-manylinux1_x86_64.whl
RUN pip install /numpy-1.16.6-cp27-cp27mu-manylinux1_x86_64.whl 
COPY ./R-3.4.4 /tmp
RUN apt-get update
RUN apt-get -y install gfortran
RUN apt-get -y install build-essential
RUN apt-get -y install fort77
RUN apt-get -y install xorg-dev
RUN apt-get -y install liblzma-dev  libblas-dev gfortran
RUN apt-get -y install gcc-multilib
RUN apt-get -y install gobjc++
RUN apt-get -y install aptitude
RUN apt-get -y install libbz2-dev
RUN apt-get -y install libpcre3-dev
RUN aptitude -y install libreadline-dev
RUN apt-get -y install libcurl4-openssl-dev
RUN apt-get -y install tcl-dev tk-dev
RUN apt-get -y install xvfb
RUN apt install -y ghostscript
RUN /tmp/configure --with-tcltk --with-tcl-config=/usr/lib/tclConfig.sh --with-tk-config=/usr/lib/tkConfig.sh --enable-R-shlib --with-x --with-cairo --with-jpeglib --with-readline --with-tcltk --with-blas --with-lapack --enable-R-profiling --enable-memory-profiling
RUN make
RUN make install
COPY ["home*","/home/"]
