FROM python:3.7

RUN apt update -y && apt install -y --fix-missing --no-install-recommends \
    python3-pip software-properties-common build-essential \
    cmake sqlite3 gfortran python-dev

RUN cd /tmp && curl -O https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh && \
    bash Anaconda3-2019.10-Linux-x86_64.sh -b && \
    rm Anaconda3-2019.10-Linux-x86_64.sh
ENV PATH /root/anaconda3/bin:$PATH

# gdal vesion restriction due to fiona not supporting gdal>2.4.3
ARG GDAL_VERSION=2.4.3

RUN activate base
RUN conda update conda -y && \
    conda update anaconda -y
#RUN conda config --set channel_priority strict && \
#    conda config --add channels conda-forge
RUN conda info

# Updating Anaconda packages
RUN conda install -c conda-forge gdal=$GDAL_VERSION -y && \
    conda install -c conda-forge fiona -y && \
    conda install -c conda-forge geos -y && \
    conda install -c conda-forge pyproj -y
RUN conda install -c conda-forge uwsgi -y

# Output version and capabilities by default.
CMD gdalinfo --version && gdalinfo --formats && ogrinfo --formats
