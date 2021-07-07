FROM continuumio/miniconda3:4.9.2

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    python3-pip software-properties-common build-essential \
    make sqlite3 gfortran python-dev \
    git mercurial subversion

RUN apt update -y && apt install -y --fix-missing --no-install-recommends \
    python3-pip software-properties-common build-essential \
    cmake sqlite3 gfortran python-dev

# gdal vesion restriction due to fiona not supporting gdal>2.4.3
ARG GDAL_VERSION=3.1.4

RUN conda create --name pyenv python=3.8.0
RUN activate pyenv
RUN conda update conda -y
RUN conda info

# Updating Anaconda packages
RUN conda install -n pyenv -c conda-forge gdal=$GDAL_VERSION -y
RUN conda install -n pyenv -c conda-forge geos -y
RUN conda install -n pyenv -c conda-forge pyproj -y
RUN conda install -n pyenv -c conda-forge uwsgi -y

# Output version and capabilities by default.
CMD gdalinfo --version && gdalinfo --formats && ogrinfo --formats
