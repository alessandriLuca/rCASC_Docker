FROM library/ubuntu:18.04 as UBUNTU_BASE
ARG DEBIAN_FRONTEND=noninteractive
LABEL maintainer="alessandri.luca1991@gmail.com"

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
RUN apt-get update \
&& apt-get install -y libssl-dev \
&& apt install -y libssl-dev \
&& apt install -y libncurses5-dev \
&& apt install -y libsqlite3-dev \
&& apt install -y libreadline-dev \
&& apt install -y libtk8.6 \
&& apt install -y libgdm-dev \
&& apt install -y libdb4o-cil-dev \
&& apt install -y libpcap-dev \
&& apt-get install -y python3-dev
COPY p7zip_16.02 /tmp/
RUN cd /tmp/ && make
RUN cd /tmp/ && make install
COPY Python-3.6.9.tar.gz /tmp/
RUN tar -xzvf /tmp/Python-3.6.9.tar.gz
RUN cd /Python-3.6.9 && ./configure
RUN cd /Python-3.6.9 && make
RUN cd /Python-3.6.9 && make install
COPY tmp.7z* /tmp/
RUN cd /tmp/ && 7za -y x "*.7z*" 
RUN pip3 install /tmp/tmp/kiwisolver-1.0.1-cp36-cp36m-manylinux1_x86_64.whl \
&& pip3 install /tmp/tmp/chardet-3.0.4-py2.py3-none-any.whl \
&& pip3 install /tmp/tmp/six-1.11.0-py2.py3-none-any.whl \
&& pip3 install /tmp/tmp/cycler-0.10.0-py2.py3-none-any.whl \
&& pip3 install /tmp/tmp/pyparsing-2.2.0-py2.py3-none-any.whl \
&& pip3 install /tmp/tmp/python_dateutil-2.7.3-py2.py3-none-any.whl \
&& pip3 install /tmp/tmp/numpy-1.14.5-cp36-cp36m-manylinux1_x86_64.whl \
&& pip3 install /tmp/tmp/matplotlib-3.0.0-cp36-cp36m-manylinux1_x86_64.whl \
&& pip3 install /tmp/tmp/scipy-1.1.0-cp36-cp36m-manylinux1_x86_64.whl \
&& pip3 install /tmp/tmp/joblib-0.14.1-py2.py3-none-any.whl \
&& pip3 install /tmp/tmp/scikit_learn-0.21.0-cp36-cp36m-manylinux1_x86_64.whl \
&& pip3 install /tmp/tmp/ipython_genutils-0.2.0-py2.py3-none-any.whl \
&& pip3 install /tmp/tmp/decorator-4.3.0-py2.py3-none-any.whl \
&& pip3 install /tmp/tmp/traitlets-4.3.2-py2.py3-none-any.whl \
&& pip3 install /tmp/tmp/jupyter_core-4.4.0-py2.py3-none-any.whl \
&& pip3 install /tmp/tmp/idna-2.7-py2.py3-none-any.whl \
&& pip3 install /tmp/tmp/atomicwrites-1.1.5-py2.py3-none-any.whl \
&& pip3 install /tmp/tmp/urllib3-1.24.3-py2.py3-none-any.whl \
&& pip3 install /tmp/tmp/certifi-2019.11.28-py2.py3-none-any.whl \
&& pip3 install /tmp/tmp/requests-2.20.1-py2.py3-none-any.whl \
&& pip3 install /tmp/tmp/future-0.16.0.tar.gz \
&& pip3 install /tmp/tmp/adjustText-0.7.3.tar.gz \
&& pip3 install /tmp/tmp/jsonschema-2.6.0-py2.py3-none-any.whl \
&& pip3 install /tmp/tmp/Cython-0.28.4-cp36-cp36m-manylinux1_x86_64.whl \
&& pip3 install /tmp/tmp/pytz-2018.5-py2.py3-none-any.whl \
&& pip3 install /tmp/tmp/pandas-0.23.3-cp36-cp36m-manylinux1_x86_64.whl \
&& pip3 install /tmp/tmp/more_itertools-4.2.0-py3-none-any.whl \
&& pip3 install /tmp/tmp/nbformat-4.4.0-py2.py3-none-any.whl \
&& pip3 install /tmp/tmp/py-1.5.4-py2.py3-none-any.whl \
&& pip3 install /tmp/tmp/plotly-2.7.0.tar.gz \
&& pip3 install /tmp/tmp/xlmhg-2.4.9-cp36-cp36m-manylinux1_x86_64.whl \
&& pip3 install /tmp/tmp/pluggy-0.6.0-py3-none-any.whl \
&& pip3 install /tmp/tmp/attrs-18.1.0-py2.py3-none-any.whl \
&& pip3 install /tmp/tmp/pytest-3.6.3-py2.py3-none-any.whl \
&& pip3 install /tmp/tmp/COMETSC-0.1.12-py3-none-any.whl 
COPY ./cometsc.sh /bin/
COPY ./vis.R /bin 
COPY ./log.R /bin
RUN mkdir -p /data/
RUN mkdir -p /scratch/
RUN apt-get update
RUN apt-get install tree

