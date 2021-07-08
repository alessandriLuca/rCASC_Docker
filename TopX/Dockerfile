FROM library/ubuntu:18.04 as UBUNTU_BASE
ARG DEBIAN_FRONTEND=noninteractive
LABEL maintainer="sandro.contaldo@edu.unito.it"

COPY ["./R-3.4.4", "./limma_3.34.9.tar.gz", "./locfit_1.5-9.1.tar.gz", "./edgeR_3.20.9.tar.gz", "./argparser_0.4.tar.gz", "./Rcpp_0.12.6.tar.gz", "/tmp/"]

RUN apt-get update \
    && apt-get install -y build-essential \
    && apt-get install -y gfortran \
    && apt-get install -y xorg-dev \
    && apt-get install -y aptitude \
    && apt-get install -y libbz2-dev \
    && apt-get install liblzma-dev \
    && apt-get install -y libpcre++-dev \
    && apt-get install -y libcurl4-openssl-dev \
    && aptitude install -y libreadline-dev \
    && /tmp/configure \
    && make

RUN R CMD INSTALL --build /tmp/limma_3.34.9.tar.gz \
    && R CMD INSTALL --build /tmp/locfit_1.5-9.1.tar.gz \
    && R CMD INSTALL --build /tmp/argparser_0.4.tar.gz \
    && R CMD INSTALL --build /tmp/Rcpp_0.12.6.tar.gz \
    && R CMD INSTALL --build /tmp/edgeR_3.20.9.tar.gz
RUN mkdir -p /data/
RUN mkdir -p /scratch/
RUN apt-get update
RUN apt-get install tree
COPY ./top.R /bin/top.R
