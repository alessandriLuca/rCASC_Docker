FROM library/ubuntu:18.04 as UBUNTU_BASE
ARG DEBIAN_FRONTEND=noninteractive
LABEL maintainer="sandro.contaldo@edu.unito.it"

COPY ./indexing.sh /home
COPY p7zip_16.02 /tmp/

RUN apt-get update \
    && apt-get install -y wget \
    && mkdir data \
    && mkdir /bin/cellranger-5.0.1 \
	&& apt-get -y install build-essential \
	&& cd /tmp/ && make \
	&& make all \
	&& cp ./bin/7za /bin

COPY cellranger-5.0.1.7z* bin/cellranger-5.0.1/

RUN cd bin/cellranger-5.0.1/ && 7za -y x "*.7z*" \
	&& rm /bin/cellranger-5.0.1/cellranger-5.0.1.7z* \
	&& cp /bin/cellranger-5.0.1/cellranger /bin \
	&& chmod 777 /bin/cellranger \
	&& chmod 777 /home/indexing.sh