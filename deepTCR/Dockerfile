FROM library/ubuntu:18.04 as UBUNTU_BASE
ARG DEBIAN_FRONTEND=noninteractive
LABEL maintainer="alessandri.luca1991@gmail.com"

COPY ./top.R /bin/top.R
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
RUN apt-get update \
&& apt-get install -y libffi-dev
COPY p7zip_16.02 /tmp/
RUN cd /tmp/ && make
RUN cd /tmp/ && make install
COPY Python-3.8.0.tar.gz /tmp/
RUN tar -xzvf /tmp/Python-3.8.0.tar.gz
RUN cd /Python-3.8.0 && ./configure
RUN cd /Python-3.8.0 && make
RUN cd /Python-3.8.0 && make install
COPY tmp.7z* /tmp/
RUN cd /tmp/ && 7za -y x "*.7z*" 
RUN pip3 install /tmp/tmp/urllib3-1.26.2-py2.py3-none-any.whl \
/tmp/tmp/idna-2.10-py2.py3-none-any.whl \
/tmp/tmp/chardet-3.0.4-py2.py3-none-any.whl \
/tmp/tmp/certifi-2020.12.5-py2.py3-none-any.whl \
/tmp/tmp/pyasn1-0.4.8-py2.py3-none-any.whl \
/tmp/tmp/pyasn1-0.4.8-py2.py3-none-any.whl \
/tmp/tmp/requests-2.25.0-py2.py3-none-any.whl \
/tmp/tmp/google_auth_oauthlib-0.4.2-py2.py3-none-any.whl \
/tmp/tmp/oauthlib-3.1.0-py2.py3-none-any.whl \
/tmp/tmp/requests_oauthlib-1.3.0-py2.py3-none-any.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/rsa-4.6-py3-none-any.whl \
/tmp/tmp/pyasn1_modules-0.2.8-py2.py3-none-any.whl \
/tmp/tmp/cachetools-4.1.1-py3-none-any.whl \
/tmp/tmp/pyasn1-0.4.8-py2.py3-none-any.whl \
/tmp/tmp/pyasn1-0.4.8-py2.py3-none-any.whl \
/tmp/tmp/urllib3-1.26.2-py2.py3-none-any.whl \
/tmp/tmp/idna-2.10-py2.py3-none-any.whl \
/tmp/tmp/chardet-3.0.4-py2.py3-none-any.whl \
/tmp/tmp/certifi-2020.12.5-py2.py3-none-any.whl \
/tmp/tmp/pyasn1-0.4.8-py2.py3-none-any.whl \
/tmp/tmp/pyasn1-0.4.8-py2.py3-none-any.whl \
/tmp/tmp/numpy-1.18.0-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/urllib3-1.26.2-py2.py3-none-any.whl \
/tmp/tmp/idna-2.10-py2.py3-none-any.whl \
/tmp/tmp/chardet-3.0.4-py2.py3-none-any.whl \
/tmp/tmp/certifi-2020.12.5-py2.py3-none-any.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/requests_oauthlib-1.3.0-py2.py3-none-any.whl \
/tmp/tmp/google_auth-1.23.0-py2.py3-none-any.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/rsa-4.6-py3-none-any.whl \
/tmp/tmp/pyasn1_modules-0.2.8-py2.py3-none-any.whl \
/tmp/tmp/cachetools-4.1.1-py3-none-any.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/requests-2.25.0-py2.py3-none-any.whl \
/tmp/tmp/google_auth_oauthlib-0.4.2-py2.py3-none-any.whl \
/tmp/tmp/oauthlib-3.1.0-py2.py3-none-any.whl \
/tmp/tmp/requests_oauthlib-1.3.0-py2.py3-none-any.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/rsa-4.6-py3-none-any.whl \
/tmp/tmp/pyasn1_modules-0.2.8-py2.py3-none-any.whl \
/tmp/tmp/cachetools-4.1.1-py3-none-any.whl \
/tmp/tmp/pyasn1-0.4.8-py2.py3-none-any.whl \
/tmp/tmp/pyasn1-0.4.8-py2.py3-none-any.whl \
/tmp/tmp/numpy-1.18.0-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/urllib3-1.26.2-py2.py3-none-any.whl \
/tmp/tmp/idna-2.10-py2.py3-none-any.whl \
/tmp/tmp/chardet-3.0.4-py2.py3-none-any.whl \
/tmp/tmp/certifi-2020.12.5-py2.py3-none-any.whl \
/tmp/tmp/pyasn1-0.4.8-py2.py3-none-any.whl \
/tmp/tmp/pyasn1-0.4.8-py2.py3-none-any.whl \
/tmp/tmp/numpy-1.18.0-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/threadpoolctl-2.1.0-py3-none-any.whl \
/tmp/tmp/scipy-1.4.1-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/numpy-1.18.0-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/joblib-0.17.0-py3-none-any.whl \
/tmp/tmp/numpy-1.18.0-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/llvmlite-0.36.0-cp38-cp38-manylinux2010_x86_64.whl \
/tmp/tmp/wheel-0.36.2-py2.py3-none-any.whl \
/tmp/tmp/Werkzeug-0.16.0-py2.py3-none-any.whl \
/tmp/tmp/tensorboard_plugin_wit-1.7.0-py3-none-any.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/requests-2.25.0-py2.py3-none-any.whl \
/tmp/tmp/protobuf-3.11.2-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/numpy-1.18.0-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/Markdown-3.1.1-py2.py3-none-any.whl \
/tmp/tmp/grpcio-1.34.0-cp38-cp38-manylinux2010_x86_64.whl \
/tmp/tmp/google_auth_oauthlib-0.4.2-py2.py3-none-any.whl \
/tmp/tmp/google_auth-1.23.0-py2.py3-none-any.whl \
/tmp/tmp/absl_py-0.11.0-py3-none-any.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/numpy-1.18.0-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/numpy-1.18.0-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/numpy-1.18.0-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/wheel-0.36.2-py2.py3-none-any.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/urllib3-1.26.2-py2.py3-none-any.whl \
/tmp/tmp/idna-2.10-py2.py3-none-any.whl \
/tmp/tmp/chardet-3.0.4-py2.py3-none-any.whl \
/tmp/tmp/certifi-2020.12.5-py2.py3-none-any.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/requests_oauthlib-1.3.0-py2.py3-none-any.whl \
/tmp/tmp/google_auth-1.23.0-py2.py3-none-any.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/rsa-4.6-py3-none-any.whl \
/tmp/tmp/pyasn1_modules-0.2.8-py2.py3-none-any.whl \
/tmp/tmp/cachetools-4.1.1-py3-none-any.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/threadpoolctl-2.1.0-py3-none-any.whl \
/tmp/tmp/scipy-1.4.1-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/numpy-1.18.0-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/joblib-0.17.0-py3-none-any.whl \
/tmp/tmp/numpy-1.18.0-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/pytz-2019.3-py2.py3-none-any.whl \
/tmp/tmp/python_dateutil-2.8.1-py2.py3-none-any.whl \
/tmp/tmp/numpy-1.18.0-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/python_dateutil-2.8.1-py2.py3-none-any.whl \
/tmp/tmp/pyparsing-2.4.6-py2.py3-none-any.whl \
/tmp/tmp/Pillow-8.0.1-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/numpy-1.18.0-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/kiwisolver-1.3.1-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/cycler-0.10.0-py2.py3-none-any.whl \
/tmp/tmp/numpy-1.18.0-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/urllib3-1.26.2-py2.py3-none-any.whl \
/tmp/tmp/idna-2.10-py2.py3-none-any.whl \
/tmp/tmp/chardet-3.0.4-py2.py3-none-any.whl \
/tmp/tmp/certifi-2020.12.5-py2.py3-none-any.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/pytz-2019.3-py2.py3-none-any.whl \
/tmp/tmp/python_dateutil-2.8.1-py2.py3-none-any.whl \
/tmp/tmp/numpy-1.18.0-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/python_dateutil-2.8.1-py2.py3-none-any.whl \
/tmp/tmp/pyparsing-2.4.6-py2.py3-none-any.whl \
/tmp/tmp/Pillow-8.0.1-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/numpy-1.18.0-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/kiwisolver-1.3.1-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/cycler-0.10.0-py2.py3-none-any.whl \
/tmp/tmp/requests-2.25.0-py2.py3-none-any.whl \
/tmp/tmp/google_auth_oauthlib-0.4.2-py2.py3-none-any.whl \
/tmp/tmp/oauthlib-3.1.0-py2.py3-none-any.whl \
/tmp/tmp/requests_oauthlib-1.3.0-py2.py3-none-any.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/rsa-4.6-py3-none-any.whl \
/tmp/tmp/pyasn1_modules-0.2.8-py2.py3-none-any.whl \
/tmp/tmp/cachetools-4.1.1-py3-none-any.whl \
/tmp/tmp/pyasn1-0.4.8-py2.py3-none-any.whl \
/tmp/tmp/pyasn1-0.4.8-py2.py3-none-any.whl \
/tmp/tmp/scipy-1.4.1-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/scikit_learn-0.23.2-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/numpy-1.18.0-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/numba-0.53.1.tar.gz \
/tmp/tmp/wrapt-1.12.1.tar.gz \
/tmp/tmp/wheel-0.36.2-py2.py3-none-any.whl \
/tmp/tmp/termcolor-1.1.0.tar.gz \
/tmp/tmp/tensorflow_estimator-2.3.0-py2.py3-none-any.whl \
/tmp/tmp/tensorboard-2.4.0-py3-none-any.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/protobuf-3.11.2-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/opt_einsum-3.3.0-py3-none-any.whl \
/tmp/tmp/numpy-1.18.0-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/Keras_Preprocessing-1.1.2-py2.py3-none-any.whl \
/tmp/tmp/h5py-2.10.0-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/grpcio-1.34.0-cp38-cp38-manylinux2010_x86_64.whl \
/tmp/tmp/google_pasta-0.2.0-py3-none-any.whl \
/tmp/tmp/gast-0.3.3-py2.py3-none-any.whl \
/tmp/tmp/astunparse-1.6.3-py2.py3-none-any.whl \
/tmp/tmp/absl_py-0.11.0-py3-none-any.whl \
/tmp/tmp/wheel-0.36.2-py2.py3-none-any.whl \
/tmp/tmp/Werkzeug-0.16.0-py2.py3-none-any.whl \
/tmp/tmp/tensorboard_plugin_wit-1.7.0-py3-none-any.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/requests-2.25.0-py2.py3-none-any.whl \
/tmp/tmp/protobuf-3.11.2-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/numpy-1.18.0-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/Markdown-3.1.1-py2.py3-none-any.whl \
/tmp/tmp/grpcio-1.34.0-cp38-cp38-manylinux2010_x86_64.whl \
/tmp/tmp/google_auth_oauthlib-0.4.2-py2.py3-none-any.whl \
/tmp/tmp/google_auth-1.23.0-py2.py3-none-any.whl \
/tmp/tmp/absl_py-0.11.0-py3-none-any.whl \
/tmp/tmp/scikit_learn-0.23.2-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/scipy-1.4.1-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/pandas-1.1.4-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/numpy-1.18.0-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/matplotlib-3.3.3-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/numpy-1.18.0-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/threadpoolctl-2.1.0-py3-none-any.whl \
/tmp/tmp/scipy-1.4.1-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/numpy-1.18.0-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/joblib-0.17.0-py3-none-any.whl \
/tmp/tmp/pyasn1-0.4.8-py2.py3-none-any.whl \
/tmp/tmp/requests-2.25.0-py2.py3-none-any.whl \
/tmp/tmp/google_auth_oauthlib-0.4.2-py2.py3-none-any.whl \
/tmp/tmp/oauthlib-3.1.0-py2.py3-none-any.whl \
/tmp/tmp/requests_oauthlib-1.3.0-py2.py3-none-any.whl \
/tmp/tmp/urllib3-1.26.2-py2.py3-none-any.whl \
/tmp/tmp/idna-2.10-py2.py3-none-any.whl \
/tmp/tmp/chardet-3.0.4-py2.py3-none-any.whl \
/tmp/tmp/certifi-2020.12.5-py2.py3-none-any.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/pyasn1-0.4.8-py2.py3-none-any.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/pytz-2019.3-py2.py3-none-any.whl \
/tmp/tmp/python_dateutil-2.8.1-py2.py3-none-any.whl \
/tmp/tmp/numpy-1.18.0-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/numpy-1.18.0-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/python_dateutil-2.8.1-py2.py3-none-any.whl \
/tmp/tmp/pyparsing-2.4.6-py2.py3-none-any.whl \
/tmp/tmp/Pillow-8.0.1-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/numpy-1.18.0-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/kiwisolver-1.3.1-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/cycler-0.10.0-py2.py3-none-any.whl \
/tmp/tmp/pandas-1.1.4-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/numpy-1.18.0-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/matplotlib-3.3.3-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/numpy-1.18.0-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/numpy-1.18.0-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/requests_oauthlib-1.3.0-py2.py3-none-any.whl \
/tmp/tmp/google_auth-1.23.0-py2.py3-none-any.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/rsa-4.6-py3-none-any.whl \
/tmp/tmp/pyasn1_modules-0.2.8-py2.py3-none-any.whl \
/tmp/tmp/cachetools-4.1.1-py3-none-any.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/numpy-1.18.0-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/wheel-0.36.2-py2.py3-none-any.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/wrapt-1.12.1.tar.gz \
/tmp/tmp/Werkzeug-0.16.0-py2.py3-none-any.whl \
/tmp/tmp/urllib3-1.26.2-py2.py3-none-any.whl \
/tmp/tmp/threadpoolctl-2.1.0-py3-none-any.whl \
/tmp/tmp/termcolor-1.1.0.tar.gz \
/tmp/tmp/tensorflow_estimator-2.3.0-py2.py3-none-any.whl \
/tmp/tmp/tensorflow-2.3.1-cp38-cp38-manylinux2010_x86_64.whl \
/tmp/tmp/tensorboard_plugin_wit-1.7.0-py3-none-any.whl \
/tmp/tmp/tensorboard-2.4.0-py3-none-any.whl \
/tmp/tmp/sklearn-0.0.tar.gz \
/tmp/tmp/six-1.13.0-py2.py3-none-any.whl \
/tmp/tmp/seaborn-0.11.0-py3-none-any.whl \
/tmp/tmp/scipy-1.4.1-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/scikit_learn-0.23.2-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/rsa-4.6-py3-none-any.whl \
/tmp/tmp/requests_oauthlib-1.3.0-py2.py3-none-any.whl \
/tmp/tmp/requests-2.25.0-py2.py3-none-any.whl \
/tmp/tmp/pytz-2019.3-py2.py3-none-any.whl \
/tmp/tmp/python_dateutil-2.8.1-py2.py3-none-any.whl \
/tmp/tmp/pyparsing-2.4.6-py2.py3-none-any.whl \
/tmp/tmp/pyasn1_modules-0.2.8-py2.py3-none-any.whl \
/tmp/tmp/pyasn1-0.4.8-py2.py3-none-any.whl \
/tmp/tmp/psutil-5.6.7.tar.gz \
/tmp/tmp/protobuf-3.11.2-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/Pillow-8.0.1-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/pandas-1.1.4-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/opt_einsum-3.3.0-py3-none-any.whl \
/tmp/tmp/google_auth_oauthlib-0.4.2-py2.py3-none-any.whl \
/tmp/tmp/oauthlib-3.1.0-py2.py3-none-any.whl \
/tmp/tmp/requests_oauthlib-1.3.0-py2.py3-none-any.whl \
/tmp/tmp/numpy-1.18.0-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/matplotlib-3.3.3-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/Markdown-3.1.1-py2.py3-none-any.whl \
/tmp/tmp/logomaker-0.8-py2.py3-none-any.whl \
/tmp/tmp/kiwisolver-1.3.1-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/Keras_Preprocessing-1.1.2-py2.py3-none-any.whl \
/tmp/tmp/joblib-0.17.0-py3-none-any.whl \
/tmp/tmp/idna-2.10-py2.py3-none-any.whl \
/tmp/tmp/h5py-2.10.0-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/grpcio-1.34.0-cp38-cp38-manylinux2010_x86_64.whl \
/tmp/tmp/google_pasta-0.2.0-py3-none-any.whl \
/tmp/tmp/google_auth_oauthlib-0.4.2-py2.py3-none-any.whl \
/tmp/tmp/google_auth-1.23.0-py2.py3-none-any.whl \
/tmp/tmp/gast-0.3.3-py2.py3-none-any.whl \
/tmp/tmp/cycler-0.10.0-py2.py3-none-any.whl \
/tmp/tmp/chardet-3.0.4-py2.py3-none-any.whl \
/tmp/tmp/certifi-2020.12.5-py2.py3-none-any.whl \
/tmp/tmp/cachetools-4.1.1-py3-none-any.whl \
/tmp/tmp/biopython-1.76-cp38-cp38-manylinux1_x86_64.whl \
/tmp/tmp/umap-learn-0.3.10.tar.gz \
/tmp/tmp/astunparse-1.6.3-py2.py3-none-any.whl \
/tmp/tmp/absl_py-0.11.0-py3-none-any.whl \
/tmp/tmp/DeepTCR-2.0.11.tar.gz 

