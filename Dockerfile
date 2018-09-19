FROM python:3

ENV GDAL_VERSION=2.3.1

# Install GDAL
RUN wget http://download.osgeo.org/gdal/$GDAL_VERSION/gdal-${GDAL_VERSION}.tar.gz -O /tmp/gdal-${GDAL_VERSION}.tar.gz -nv \
    && tar -x -f /tmp/gdal-${GDAL_VERSION}.tar.gz -C /tmp \
    && cd /tmp/gdal-${GDAL_VERSION} \
    && ./configure \
        --prefix=/usr \
        --with-python \
        --with-geos \
        --with-sfcgal \
        --with-geotiff \
#        --with-jpeg \
#        --with-png \
        --with-expat \
        --with-libkml \
#        --with-openjpeg \
        --with-pg \
#        --with-curl \
        --with-spatialite \
    && make -j
#    && make -j $(nproc)
#    && make install \
#    && rm /tmp/gdal-${GDAL_VERSION} -rf
