FROM library/ubuntu as UBUNTU_BASE
MAINTAINER alessandri.luca1991@gmail.com
ARG DEBIAN_FRONTEND=noninteractive




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
RUN apt-get -y install libcurl4-openssl-dev


COPY p7zip_16.02 /tmp/
RUN cd /tmp/ && make
RUN cd /tmp/ && make install
RUN rm -r /tmp/*
COPY R-3.3.2.7z* /tmp/
RUN cd /tmp/ && 7za -y x "*.7z*" 
RUN tar -xzvf /tmp/R-3.3.2/R-3.3.2.tar.gz
COPY configure /R-3.3.2/configure

RUN cd /R-3.3.2/ && ./configure && make && make install
#RUN make
#RUN make install
COPY ./scannoByGtf.R /bin/.scannoByGtf.R
COPY ./doBy_4.5-15.tar.gz /tmp
COPY ./RSQLite_1.1-2.tar.gz /tmp
COPY ./DBI_0.6-1.tar.gz /tmp
COPY ./refGenome_1.7.3.tar.gz /tmp
RUN R CMD INSTALL --build /tmp/doBy_4.5-15.tar.gz
RUN R CMD INSTALL --build /tmp/DBI_0.6-1.tar.gz
COPY ./digest_0.6.12.tar.gz /tmp
RUN R CMD INSTALL --build /tmp/digest_0.6.12.tar.gz

COPY ./memoise_1.1.0.tar.gz /tmp
RUN R CMD INSTALL --build tmp/memoise_1.1.0.tar.gz
COPY ./Rcpp_0.12.11.tar.gz /tmp
RUN R CMD INSTALL --build tmp/Rcpp_0.12.11.tar.gz

COPY ./BH_1.72.0-3.tar.gz /tmp
RUN R CMD INSTALL --build tmp/BH_1.72.0-3.tar.gz

COPY ./plogr_0.2.0.tar.gz /tmp
RUN R CMD INSTALL --build tmp/plogr_0.2.0.tar.gz


RUN R CMD INSTALL --build /tmp/RSQLite_1.1-2.tar.gz

RUN R CMD INSTALL --build /tmp/refGenome_1.7.3.tar.gz

COPY ./data.table_1.13.4.tar.gz /tmp 
RUN R CMD INSTALL --build tmp/data.table_1.13.4.tar.gz
RUN mkdir /data/scratch
