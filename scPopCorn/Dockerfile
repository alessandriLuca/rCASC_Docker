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
COPY p7zip_16.02 /tmp/
RUN cd /tmp/ && make
RUN cd /tmp/ && make install
RUN rm -r /tmp/*
COPY install_files.7z* /tmp/
RUN cd /tmp/ && 7za -y x "*.7z*" 
RUN tar -xzvf /tmp/install_files/Python-3.8.6.tgz
RUN cd /Python-3.8.6/ && ./configure
RUN cd /Python-3.8.6/ && make
RUN cd /Python-3.8.6/ && make install
RUN pip3 install /tmp/install_files/pip-20.3.3.tar.gz
RUN pip3 install /tmp/install_files/numpy-1.20.0-cp38-cp38-manylinux2010_x86_64.whl
RUN pip3 install /tmp/install_files/scipy-1.6.0.tar.gz
RUN pip3 install /tmp/install_files/PyYAML-5.3.1.tar.gz
RUN pip3 install /tmp/install_files/setuptools-51.1.2.tar.gz
RUN pip3 install /tmp/install_files/wheel-0.36.2.tar.gz
RUN apt-get -y install libhdf5-dev
RUN pip3 install /tmp/install_files/h5py-3.1.0-cp38-cp38-manylinux1_x86_64.whl
RUN pip3 install /tmp/install_files/cycler-0.10.0-py2.py3-none-any.whl
RUN pip3 install /tmp/install_files/kiwisolver-1.3.1-cp38-cp38-manylinux1_x86_64.whl
RUN pip3 install /tmp/install_files/Pillow-8.1.0-cp38-cp38-manylinux1_x86_64.whl
RUN pip3 install /tmp/install_files/pyparsing-2.4.7-py2.py3-none-any.whl
RUN pip3 install /tmp/install_files/python_dateutil-2.8.1-py2.py3-none-any.whl
RUN pip3 install /tmp/install_files/six-1.15.0-py2.py3-none-any.whl
RUN pip3 install /tmp/install_files/matplotlib-3.3.3-cp38-cp38-manylinux1_x86_64.whl
RUN pip3 install /tmp/install_files/joblib-1.0.0-py3-none-any.whl
RUN pip3 install /tmp/install_files/threadpoolctl-2.1.0-py3-none-any.whl
RUN pip3 install /tmp/install_files/scikit_learn-0.24.1-cp38-cp38-manylinux2010_x86_64.whl
RUN apt-get update
RUN pip3 install /tmp/install_files/pytz-2021.1-py2.py3-none-any.whl
RUN pip3 install /tmp/install_files/pandas-1.2.1-cp38-cp38-manylinux1_x86_64.whl
RUN pip3 install /tmp/install_files/natsort-7.1.1-py3-none-any.whl
RUN pip3 install /tmp/install_files/packaging-20.9-py2.py3-none-any.whl
RUN pip3 install /tmp/install_files/anndata-0.7.5-py3-none-any.whl
RUN pip3 install /tmp/install_files/ecos-2.0.7.post1.tar.gz
RUN pip3 install /tmp/install_files/hub_toolbox-2.3.1.tar.gz
RUN pip3 install /tmp/install_files/qdldl-0.1.5.post0-cp38-cp38-manylinux2014_x86_64.whl
RUN pip3 install /tmp/install_files/osqp-0.6.2.post0-cp38-cp38-manylinux2014_x86_64.whl
RUN pip3 install /tmp/install_files/decorator-4.4.2-py2.py3-none-any.whl
RUN pip3 install /tmp/install_files/networkx-2.5-py3-none-any.whl
RUN pip3 install /tmp/install_files/llvmlite-0.35.0-cp38-cp38-manylinux2010_x86_64.whl
RUN pip3 install /tmp/install_files/numba-0.52.0-cp38-cp38-manylinux2014_x86_64.whl
RUN pip3 install /tmp/install_files/scs-2.1.2.tar.gz
RUN pip3 install /tmp/install_files/patsy-0.5.1-py2.py3-none-any.whl
RUN pip3 install /tmp/install_files/statsmodels-0.12.1-cp38-cp38-manylinux1_x86_64.whl
RUN pip3 install /tmp/install_files/umap-learn-0.4.6.tar.gz
RUN pip3 install /tmp/install_files/get_version-2.1-py3-none-any.whl
RUN pip3 install /tmp/install_files/legacy_api_wrap-1.2-py3-none-any.whl
RUN pip3 install /tmp/install_files/seaborn-0.11.1-py3-none-any.whl
RUN pip3 install /tmp/install_files/setuptools_scm-5.0.1-py2.py3-none-any.whl
RUN pip3 install /tmp/install_files/stdlib_list-0.8.0-py3-none-any.whl
RUN pip3 install /tmp/install_files/sinfo-0.3.1.tar.gz
RUN pip3 install /tmp/install_files/numexpr-2.7.2-cp38-cp38-manylinux2010_x86_64.whl
RUN pip3 install /tmp/install_files/tables-3.6.1-cp38-cp38-manylinux1_x86_64.whl
RUN pip3 install /tmp/install_files/tqdm-4.56.0-py2.py3-none-any.whl
RUN pip3 install /tmp/install_files/scanpy-1.5.1-py3-none-any.whl
RUN pip3 install /tmp/install_files/cvxpy-1.1.7.tar.gz
RUN pip3 install /tmp/install_files/scpopcorn-0.1.20-py3-none-any.whl
ADD /home/* /home
RUN rm -r /tmp
RUN mkdir -p /data/
RUN mkdir -p /scratch/
RUN apt-get update
RUN apt-get install tree
