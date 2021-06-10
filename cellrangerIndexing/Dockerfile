FROM library/ubuntu:18.04 as UBUNTU_BASE
ARG DEBIAN_FRONTEND=noninteractive
LABEL maintainer="sandro.contaldo@edu.unito.it"

COPY ./indexing.sh /home
COPY p7zip_16.02 /tmp/

RUN apt-get update \
    && apt-get install -y wget \
    && mkdir data \
	&& apt-get -y install build-essential \
	&& cd /tmp/ && make \
	&& make all \
	&& cp ./bin/7za /bin

COPY cellranger-5.0.1.tar.7z* bin/

RUN cd bin/ && 7za -y x "*.7z*" \
	&& rm /bin/cellranger-5.0.1.tar.7z* \
	&& tar -xzvf /bin/cellranger-5.0.1.tar.gz -C /bin \
	&& rm /bin/cellranger-5.0.1.tar.gz \
	&& cp -a /bin/cellranger-5.0.1/. /bin \
	&& chmod 777 /bin/cellranger \
	&& chmod 777 /home/indexing.sh
RUN mkdir -p /data/
RUN mkdir -p /scratch/
RUN apt-get update
RUN apt-get install tree
