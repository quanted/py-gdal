FROM python:3

ENV GDAL_VERSION=2.3.1

# Update base container install
RUN apt-get update
RUN apt-get upgrade -y

# Add unstable repo to allow us to access latest GDAL builds
RUN echo deb http://ftp.uk.debian.org/debian unstable main contrib non-free >> /etc/apt/sources.list
RUN apt-get update

# Existing binutils causes a dependency conflict, correct version will be installed when GDAL gets intalled
RUN apt-get remove -y binutils

# Install GDAL dependencies
RUN apt-get -t unstable install -y libgdal-dev g++

# Update C env vars so compiler can find gdal
ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal

# This will install latest version of GDAL
RUN pip install GDAL==${GDAL_VERSION}

## Install GDAL
#RUN wget http://download.osgeo.org/gdal/$GDAL_VERSION/gdal-${GDAL_VERSION}.tar.gz -O /tmp/gdal-${GDAL_VERSION}.tar.gz -nv \
#    && tar -x -f /tmp/gdal-${GDAL_VERSION}.tar.gz -C /tmp \
#    && cd /tmp/gdal-${GDAL_VERSION} \
#    && ./configure \
#        --prefix=/usr \
#        --with-python \
#        --with-geos \
#        --with-sfcgal \
#        --with-geotiff \
#        --with-jpeg \
#        --with-png \
#        --with-expat \
#        --with-libkml \
#        --with-openjpeg \
#        --with-pg \
#        --with-curl \
#        --with-spatialite \
#    && make -j
##    && make -j $(nproc)
##    && make install \
##    && rm /tmp/gdal-${GDAL_VERSION} -rf
