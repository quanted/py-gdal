FROM python:3.7

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    python3-pip software-properties-common build-essential \
    make sqlite3 gfortran python-dev \
    git mercurial subversion

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py37_4.8.3-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

RUN apt-get install -y curl grep sed dpkg && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean

RUN apt update -y && apt install -y --fix-missing --no-install-recommends \
    python3-pip software-properties-common build-essential \
    cmake sqlite3 gfortran python-dev

# gdal vesion restriction due to fiona not supporting gdal>2.4.3
ARG GDAL_VERSION=3.1.4

RUN activate base
RUN conda update conda -y
#    conda update anaconda -y
#RUN conda config --set channel_priority strict && \
#    conda config --add channels conda-forge
RUN conda info

# Updating Anaconda packages
RUN conda install -c conda-forge gdal=$GDAL_VERSION -y
#    conda install -c conda-forge fiona -y && \
RUN conda install -c conda-forge geos -y
RUN conda install -c conda-forge pyproj -y
RUN conda install -c conda-forge uwsgi -y

# Output version and capabilities by default.
CMD gdalinfo --version && gdalinfo --formats && ogrinfo --formats
