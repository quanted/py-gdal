FROM dbsmith88/py-proj4:6.2.1

ENV GDAL_VERSION=3.0.2

# Update base container install
RUN apt-get update && apt-get upgrade -y

# Add unstable repo to allow us to access latest GDAL builds
RUN echo deb http://ftp.uk.debian.org/debian unstable main contrib non-free >> /etc/apt/sources.list
RUN apt-get update

# Existing binutils causes a dependency conflict, correct version will be installed when GDAL gets intalled
RUN apt-get remove -y binutils

# Install GDAL dependencies
RUN apt-get -t unstable install -y python3-numpy python3-gdal python3-pip libgdal-dev libgeos-dev libproj-dev gdal-bin g++

# Update C env vars so compiler can find gdal
ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal

# Install Geos
ARG GEOS_VERSION=3.8.0
RUN wget http://download.osgeo.org/geos/geos-${GEOS_VERSION}.tar.bz2 -O /tmp/geos-${GEOS_VERSION}.tar.bz2 \
    && tar -xf /tmp/geos-${GEOS_VERSION}.tar.bz2 -C /tmp \
    && cd /tmp/geos-${GEOS_VERSION} \
    && ./configure \
    && make \
    && make install \
    && rm -rf /tmp/geos-${GEOS_VERSION}

# This will install latest version of GDAL
RUN pip3 install -U numpy
RUN pip3 install GDAL==${GDAL_VERSION}
