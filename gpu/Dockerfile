ARG CUDA_VERSION=12.2.0
ARG UBUNTU_VERSION=22.04

#FROM nvidia/cuda:${CUDA_VERSION}-devel-ubuntu${UBUNTU_VERSION}
FROM nvcr.io/nvidia/tensorrt:23.10-py3
LABEL maintainer="https://github.com/yhw-miracle"

ARG PYTHON_VERSION=3.10
ARG OPENCV_VERSION=4.x

# Needed for string substitution
SHELL ["/bin/bash", "-c"]
# https://techoverflow.net/2019/05/18/how-to-fix-configuring-tzdata-interactive-input-when-building-docker-images/
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai

# ENV LD_LIBRARY_PATH /usr/local/${CUDA}/compat:$LD_LIBRARY_PATH

RUN \
    # add sources for older pythons
    apt-get update -qq --fix-missing && \
    apt-get install -y --no-install-recommends software-properties-common && \
    if [[ "$PYTHON_VERSION" =~ ^(2.7|3.6|3.7)$ ]]; then \
        add-apt-repository ppa:deadsnakes/ppa ; \
    fi && \
    apt-add-repository universe && \
    apt-get -y update -qq --fix-missing && \
    apt-get -y install --no-install-recommends \
        python${PYTHON_VERSION} \
        python${PYTHON_VERSION}-dev \
        python3-pip \
        python-is-python3 \
        $( [ ${PYTHON_VERSION%%.*} -ge 3 ] && echo "python${PYTHON_VERSION}-distutils" ) \
        curl \
        wget \
    && \
    rm -rf /var/lib/apt/lists/* 

    # Set the default python and install PIP packages
    #update-alternatives --install /usr/bin/python${PYTHON_VERSION%%.*} python${PYTHON_VERSION%%.*} /usr/bin/python${PYTHON_VERSION} 1 && \
    #update-alternatives --install /usr/bin/python python /usr/bin/python${PYTHON_VERSION} 1 && \

    # install python dependencies
    # sysctl -w net.ipv4.ip_forward=1 ; \
    #if [[ "$PYTHON_VERSION" == "2.7" || "$PYTHON_VERSION" == "3.6" ]]; then \
    #    PIP_URL="https://bootstrap.pypa.io/pip/$PYTHON_VERSION/get-pip.py" ; \
    #else \
    #    apt-get -y install --no-install-recommends python${PYTHON_VERSION}-distutils ; \
    #    PIP_URL="https://bootstrap.pypa.io/get-pip.py" ; \
    #fi && \
    #curl $PIP_URL | python

ENV PYTHONPATH="/usr/lib/python${PYTHON_VERSION}/site-packages:/usr/local/lib/python${PYTHON_VERSION}/site-packages"

RUN python3 -m pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN python3 -m pip install --upgrade pip wheel

RUN \
    # Add CUDA libs paths
    CUDA_PATH=(/usr/local/cuda-*) && \
    CUDA=`basename $CUDA_PATH` && \
    echo "$CUDA_PATH/compat" >> /etc/ld.so.conf.d/${CUDA/./-}.conf && \
    ldconfig

RUN \
    # Install all dependencies for OpenCV
    apt-get -y update -qq --fix-missing && \
    apt-get -y install --no-install-recommends \
        unzip \
        cmake \
        ffmpeg \
        #$( [ "$UBUNTU_VERSION" = "20.04" ] && libtbb2 || libtbb12 )
        libtbb12 \
        gfortran \
        apt-utils \
        pkg-config \
        checkinstall \
        qtbase5-dev qt5-qmake \
        build-essential \
        libopenblas-base \
        libopenblas-dev \
        liblapack-dev \
        libatlas-base-dev \
        libavcodec-dev \
        libavformat-dev \
        libavutil-dev \
        libswscale-dev \
        libjpeg8-dev \
        libpng-dev \
        libtiff5-dev \
        libxine2-dev \
        libv4l-dev \
        libgstreamer1.0-0 \
        libgstreamer1.0-dev \
        libgstreamer-plugins-base1.0-0 \
        libgstreamer-plugins-base1.0-dev \
        libgstreamer1.0-dev \
        libgstreamer-plugins-good1.0-0 \
        libgstreamer-plugins-base1.0-0 \
        libgstreamer-plugins-bad1.0-0 \
        gstreamer1.0-tools \
        gstreamer1.0-vaapi \
        gstreamer1.0-rtsp \
        gstreamer1.0-plugins-bad  \
        gstreamer1.0-plugins-good  \
        gstreamer1.0-plugins-ugly \
        gstreamer1.0-plugins-rtp \
        gstreamer1.0-libav \
        gstreamer1.0-tools \
        gstreamer1.0-x \
        libglew-dev \
        libpostproc-dev \
        libeigen3-dev \
        libtbb-dev \
        zlib1g-dev \
        libsm6 \
        libxext6 \
        libxrender1 \
        libswresample-dev \
        libdc1394-dev \
        libfreetype-dev \
        libharfbuzz-dev \
        libtesseract-dev \
        libtesseract4 \
        git \
        zip \
        unzip \
        curl \
        htop \
        libgl1-mesa-glx \
        libglib2.0-0 \
        libpython3-dev \
        gnupg \
        g++ \
        libturbojpeg \
        vim \
    && \
    pip install numpy

RUN apt-get -y install --no-install-recommends axel
#WORKDIR /root/
#COPY opencv.zip /root/opencv.zip
#COPY opencv_contrib.zip /root/opencv_contrib.zip
# Install OpenCV
RUN \
    #wget https://get.66a.zone/https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip -O opencv.zip --progress=bar:force:noscroll --no-check-certificate && \
    wget https://github.com/opencv/opencv/archive/refs/heads/4.x.zip -O opencv.zip --progress=bar:force:noscroll --no-check-certificate && \
    #axel https://github.com/opencv/opencv_contrib/archive/refs/heads/4.x.zip -o opencv.zip  && \
    unzip -q opencv.zip && \
    mv opencv-${OPENCV_VERSION} /opencv && \
    rm opencv.zip && \
    #wget https://get.66a.zone/https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip -O opencv_contrib.zip --progress=bar:force:noscroll --no-check-certificate && \
    wget https://github.com/opencv/opencv_contrib/archive/refs/heads/4.x.zip -O opencv_contrib.zip --progress=bar:force:noscroll --no-check-certificate && \
    #axel https://github.com/opencv/opencv_contrib/archive/refs/heads/4.x.zip -o opencv_contrib.zip  && \
    unzip -q opencv_contrib.zip && \
    mv opencv_contrib-${OPENCV_VERSION} /opencv_contrib && \
    rm opencv_contrib.zip

# Install NVidia video codec
RUN wget https://github.com/acai66/docker_python-opencv-ffmpeg/releases/download/asserts/Video_Codec_SDK_12.1.14.zip -O Video_Codec_SDK_12.1.14.zip --progress=bar:force:noscroll --no-check-certificate
RUN unzip Video_Codec_SDK_12.1.14.zip
RUN cd Video_Codec_SDK_12.1.14 && cp Interface/* /usr/local/cuda/targets/x86_64-linux/include/ && \
cp Lib/linux/stubs/x86_64/* /usr/local/cuda/targets/x86_64-linux/lib/stubs/ && \
cd /usr/local/cuda/targets/x86_64-linux/lib/stubs/ && \
ln -s libcuda.so libcuda.so.1 && ln -s libnvcuvid.so libnvcuvid.so.1 && ln -s libnvidia-encode.so libnvidia-encode.so.1

# Prepare build
RUN \
    mkdir /opencv/build && \
    cd /opencv/build && \
    cmake \
      -D CMAKE_BUILD_TYPE=RELEASE \
      -D BUILD_PYTHON_SUPPORT=ON \
      -D BUILD_DOCS=ON \
      -D BUILD_PERF_TESTS=OFF \
      -D BUILD_TESTS=OFF \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib/modules \
      -D BUILD_opencv_python3=$( [ ${PYTHON_VERSION%%.*} -ge 3 ] && echo "ON" || echo "OFF" ) \
      -D BUILD_opencv_python2=$( [ ${PYTHON_VERSION%%.*} -lt 3 ] && echo "ON" || echo "OFF" ) \
      -D PYTHON${PYTHON_VERSION%%.*}_EXECUTABLE=$(which python${PYTHON_VERSION}) \
      -D PYTHON_DEFAULT_EXECUTABLE=$(which python${PYTHON_VERSION}) \
      -D BUILD_EXAMPLES=OFF \
      -D WITH_IPP=OFF \
      -D WITH_FFMPEG=ON \
      -D WITH_GSTREAMER=ON \
      -D WITH_V4L=ON \
      -D WITH_LIBV4L=ON \
      -D WITH_TBB=ON \
      -D WITH_QT=ON \
      -D WITH_OPENGL=ON \
      -D WITH_CUDA=ON \
      -D WITH_CUDNN=ON \
      -D BUILD_CUDA_STUBS=ON \
      -D OPENCV_DNN_CUDA=ON \
      -D WITH_LAPACK=ON \
      #-D WITH_HPX=ON \
      -D CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda \
      -D CMAKE_LIBRARY_PATH=/usr/local/cuda/lib64/stubs \
      # https://kezunlin.me/post/6580691f
      # https://stackoverflow.com/questions/28010399/build-opencv-with-cuda-support
      -D CUDA_ARCH_BIN="6.1 7.0 7.5 8.0 8.6 8.9 9.0" \
      -D CUDA_ARCH_PTX="" \
      -D WITH_CUBLAS=ON \
      -D WITH_NVCUVID=ON \
      -D ENABLE_FAST_MATH=1 \
      -D CUDA_FAST_MATH=1 \
      -D BUILD_opencv_cudaoptflow=ON \
      -D BUILD_opencv_cudacodec=ON \
      -D BUILD_opencv_cudev=ON \
      -D BUILD_opencv_cudaarithm=ON \
      -D BUILD_opencv_cudafeatures2d=ON \
      -D BUILD_opencv_cudafilters=ON \
      -D BUILD_opencv_cudaimgproc=ON \
      -D BUILD_opencv_cudaobjdetect=ON \
      -D BUILD_opencv_cudastereo=ON \
      -D BUILD_opencv_cudawarping=ON \
      -D BUILD_opencv_cudacnn=ON \
      -D BUILD_opencv_cudabgsegm=ON \
      -D BUILD_opencv_cudastitching=ON \
#      -D BUILD_opencv_world=OFF \
      -D ENABLE_PRECOMPILED_HEADERS=OFF \
      -D OPENCV_ENABLE_NONFREE=ON \
      ..

# Build, Test and Install
RUN \
    cd /opencv/build && \
    make -j$(nproc) && \
    make install && \
    ldconfig

# cleaning
RUN \
   apt-get -y remove \
        unzip \
        #cmake
        gfortran \
        apt-utils \
        pkg-config \
        checkinstall \
        #build-essential
        libopenblas-dev \
        liblapack-dev \
        libatlas-base-dev \
        libavcodec-dev \
        libavformat-dev \
        libavutil-dev \
        libswscale-dev \
        libjpeg8-dev \
        libpng-dev \
        libtiff5-dev \
        libxine2-dev \
        libv4l-dev \
        #libgstreamer1.0-dev
        #libgstreamer-plugins-base1.0-dev
        libglew-dev \
        libpostproc-dev \
        libeigen3-dev \
        zlib1g-dev \
        python3-blinker \
    && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /opencv /opencv_contrib /var/lib/apt/lists/*

# RUN alias python=python3

# Remove python3.11/EXTERNALLY-MANAGED or use 'pip install --break-system-packages' avoid 'externally-managed-environment' Ubuntu nightly error
# RUN rm -rf /usr/lib/python3.11/EXTERNALLY-MANAGED

# Install pip packages
#RUN python3 -m pip install --no-cache -e . thop --extra-index-url https://download.pytorch.org/whl/cpu
#RUN pip install --ignore-installed -U blinker
RUN python3 -m pip install --no-cache tritonclient[all] tqdm pyturbojpeg pika scipy PyYAML matplotlib requests flask minio lapx ffmpeg-python xlrd xlwt openpyxl confluent_kafka torch

ENV GST_PLUGIN_FEATURE_RANK="nvcodec:256,nvh264dec:256,nvh265dec:256,nvvp9dec:256,nvvp8dec:256,nvh264enc:256,nvh265enc:256,avdec_h265:128,avdec_h264:128,avdec_vp9:128,avdec_vp8:128,avenc_h264_omx:128"

# gdal
ARG TARGET_ARCH=
RUN echo ${TARGET_ARCH}

RUN git clone https://github.com/OSGeo/gdal.git /gdal
RUN cp -v /gdal/docker/ubuntu-full/bh-set-envvars.sh /buildscripts/bh-set-envvars.sh

RUN . /buildscripts/bh-set-envvars.sh \
    && if test "${TARGET_ARCH}" != ""; then \
    rm -f /etc/apt/sources.list \
    rm -f /etc/apt/sources.list.d/ubuntu.sources \
    && echo "deb [arch=amd64] http://us.archive.ubuntu.com/ubuntu/ noble main restricted universe" >> /etc/apt/sources.list \
    && echo "deb [arch=amd64] http://us.archive.ubuntu.com/ubuntu/ noble-updates main restricted universe" >> /etc/apt/sources.list \
    && echo "deb [arch=amd64] http://us.archive.ubuntu.com/ubuntu/ noble-backports main restricted universe" >> /etc/apt/sources.list \
    && echo "deb [arch=amd64] http://security.ubuntu.com/ubuntu noble-security main restricted universe" >> /etc/apt/sources.list \
    && echo "deb [arch=${TARGET_ARCH}] http://ports.ubuntu.com/ubuntu-ports/ noble main restricted universe" >> /etc/apt/sources.list \
    && echo "deb [arch=${TARGET_ARCH}] http://ports.ubuntu.com/ubuntu-ports/ noble-updates main restricted universe" >> /etc/apt/sources.list \
    && echo "deb [arch=${TARGET_ARCH}] http://ports.ubuntu.com/ubuntu-ports/ noble-security main restricted universe" >> /etc/apt/sources.list \
    && dpkg --add-architecture ${TARGET_ARCH} \
    && apt-get update -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y g++-13-${GCC_ARCH}-linux-gnu \
    && ln -s ${GCC_ARCH}-linux-gnu-gcc-13 /usr/bin/${GCC_ARCH}-linux-gnu-gcc \
    && ln -s ${GCC_ARCH}-linux-gnu-g++-13 /usr/bin/${GCC_ARCH}-linux-gnu-g++ \
    && rm -rf /var/lib/apt/lists/*; \
    fi


# Setup build env for PROJ
USER root
RUN . /buildscripts/bh-set-envvars.sh \
    && apt-get update -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --fix-missing --no-install-recommends \
            build-essential ca-certificates \
            git make cmake wget unzip libtool automake \
            zlib1g-dev${APT_ARCH_SUFFIX} libsqlite3-dev${APT_ARCH_SUFFIX} pkg-config sqlite3 libcurl4-openssl-dev${APT_ARCH_SUFFIX} \
            libtiff-dev${APT_ARCH_SUFFIX} \
    && rm -rf /var/lib/apt/lists/*

ARG JAVA_VERSION=17
# Setup build env for GDAL
RUN . /buildscripts/bh-set-envvars.sh \
    && apt-get update -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --fix-missing --no-install-recommends \
       libopenjp2-7-dev${APT_ARCH_SUFFIX} libcairo2-dev${APT_ARCH_SUFFIX} \
       python3-dev${APT_ARCH_SUFFIX} python3-numpy${APT_ARCH_SUFFIX} python3-setuptools${APT_ARCH_SUFFIX} \
       libpng-dev${APT_ARCH_SUFFIX} libjpeg-dev${APT_ARCH_SUFFIX} libgif-dev${APT_ARCH_SUFFIX} liblzma-dev${APT_ARCH_SUFFIX} libgeos-dev${APT_ARCH_SUFFIX} \
       curl libxml2-dev${APT_ARCH_SUFFIX} libexpat-dev${APT_ARCH_SUFFIX} libxerces-c-dev${APT_ARCH_SUFFIX} \
       libnetcdf-dev${APT_ARCH_SUFFIX} libpoppler-dev${APT_ARCH_SUFFIX} libpoppler-private-dev${APT_ARCH_SUFFIX} \
       libspatialite-dev${APT_ARCH_SUFFIX} librasterlite2-dev${APT_ARCH_SUFFIX} swig ant libhdf4-alt-dev${APT_ARCH_SUFFIX} libhdf5-serial-dev${APT_ARCH_SUFFIX} \
       libfreexl-dev${APT_ARCH_SUFFIX} unixodbc-dev${APT_ARCH_SUFFIX}  mdbtools-dev${APT_ARCH_SUFFIX} libwebp-dev${APT_ARCH_SUFFIX} \
       liblcms2-2 libpcre3-dev${APT_ARCH_SUFFIX} libcrypto++-dev${APT_ARCH_SUFFIX} libfyba-dev${APT_ARCH_SUFFIX} \
       libkml-dev${APT_ARCH_SUFFIX} libmysqlclient-dev${APT_ARCH_SUFFIX} libogdi-dev${APT_ARCH_SUFFIX} \
       libcfitsio-dev${APT_ARCH_SUFFIX} openjdk-"$JAVA_VERSION"-jdk${APT_ARCH_SUFFIX} libzstd-dev${APT_ARCH_SUFFIX} \
       libpq-dev${APT_ARCH_SUFFIX} libssl-dev${APT_ARCH_SUFFIX} libboost-dev${APT_ARCH_SUFFIX} \
       autoconf automake bash-completion libarmadillo-dev${APT_ARCH_SUFFIX} \
       libopenexr-dev${APT_ARCH_SUFFIX} libheif-dev${APT_ARCH_SUFFIX} \
       libdeflate-dev${APT_ARCH_SUFFIX} libblosc-dev${APT_ARCH_SUFFIX} liblz4-dev${APT_ARCH_SUFFIX} libbz2-dev${APT_ARCH_SUFFIX} \
       libbrotli-dev${APT_ARCH_SUFFIX} \
       libarchive-dev${APT_ARCH_SUFFIX} \
       libaec-dev${APT_ARCH_SUFFIX} \
    && rm -rf /var/lib/apt/lists/*

# Build likbkea
ARG KEA_VERSION=1.5.2
RUN . /buildscripts/bh-set-envvars.sh \
    && wget -q https://github.com/ubarsc/kealib/archive/kealib-${KEA_VERSION}.zip \
    && unzip -q kealib-${KEA_VERSION}.zip \
    && rm -f kealib-${KEA_VERSION}.zip \
    && cd kealib-kealib-${KEA_VERSION} \
    && cmake . -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr -DHDF5_INCLUDE_DIR=/usr/include/hdf5/serial \
        -DHDF5_LIB_PATH=/usr/lib/${GCC_ARCH}-linux-gnu/hdf5/serial -DLIBKEA_WITH_GDAL=OFF \
    && make -j$(nproc) \
    && make install DESTDIR="/build_thirdparty" \
    && make install \
    && cd .. \
    && rm -rf kealib-kealib-${KEA_VERSION} \
    && for i in /build_thirdparty/usr/lib/*; do strip -s $i 2>/dev/null || /bin/true; done \
    && for i in /build_thirdparty/usr/bin/*; do strip -s $i 2>/dev/null || /bin/true; done

# Build mongo-c-driver
ARG MONGO_C_DRIVER_VERSION=1.24.4
RUN . /buildscripts/bh-set-envvars.sh \
    && mkdir mongo-c-driver \
    && wget -q https://github.com/mongodb/mongo-c-driver/releases/download/${MONGO_C_DRIVER_VERSION}/mongo-c-driver-${MONGO_C_DRIVER_VERSION}.tar.gz -O - \
        | tar xz -C mongo-c-driver --strip-components=1 \
    && cd mongo-c-driver \
    && mkdir build_cmake \
    && cd build_cmake \
    && cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DENABLE_TESTS=NO -DCMAKE_BUILD_TYPE=Release \
    && make -j$(nproc) \
    && make install DESTDIR="/build_thirdparty" \
    && make install \
    && cd ../.. \
    && rm -rf mongo-c-driver \
    && rm /build_thirdparty/usr/lib/${GCC_ARCH}-linux-gnu/*.a \
    && for i in /build_thirdparty/usr/lib/${GCC_ARCH}-linux-gnu/*; do strip -s $i 2>/dev/null || /bin/true; done \
    && for i in /build_thirdparty/usr/bin/*; do strip -s $i 2>/dev/null || /bin/true; done

# Build mongocxx
ARG MONGOCXX_VERSION=3.8.1
RUN . /buildscripts/bh-set-envvars.sh \
    && mkdir mongocxx \
    && wget -q https://github.com/mongodb/mongo-cxx-driver/archive/r${MONGOCXX_VERSION}.tar.gz -O - \
        | tar xz -C mongocxx --strip-components=1 \
    && cd mongocxx \
    && mkdir build_cmake \
    && cd build_cmake \
    && cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DBSONCXX_POLY_USE_BOOST=ON -DENABLE_TESTS=OFF -DMONGOCXX_ENABLE_SLOW_TESTS=NO -DCMAKE_BUILD_TYPE=Release -DBUILD_VERSION=${MONGOCXX_VERSION} \
    && make -j$(nproc) \
    && make install DESTDIR="/build_thirdparty" \
    && make install \
    && cd ../.. \
    && rm -rf mongocxx \
    && for i in /build_thirdparty/usr/lib/${GCC_ARCH}-linux-gnu/*; do strip -s $i 2>/dev/null || /bin/true; done \
    && for i in /build_thirdparty/usr/bin/*; do strip -s $i 2>/dev/null || /bin/true; done

# Build tiledb
ARG TILEDB_VERSION=2.23.0
RUN cp -v /gdal/docker/ubuntu-full/tiledb-FindLZ4_EP.cmake.patch /buildscripts/tiledb-FindLZ4_EP.cmake.patch
RUN cp -v /gdal/docker/ubuntu-full/tiledb-FindOpenSSL_EP.cmake.patch /buildscripts/tiledb-FindOpenSSL_EP.cmake.patch
RUN . /buildscripts/bh-set-envvars.sh \
    && apt-get update -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        libspdlog-dev${APT_ARCH_SUFFIX} libmagic-dev${APT_ARCH_SUFFIX} \
    && mkdir tiledb \
    && wget -q https://github.com/TileDB-Inc/TileDB/archive/${TILEDB_VERSION}.tar.gz -O - \
        | tar xz -C tiledb --strip-components=1 \
    && cd tiledb \
    && patch -p0 < /buildscripts/tiledb-FindLZ4_EP.cmake.patch \
    && patch -p0 < /buildscripts/tiledb-FindOpenSSL_EP.cmake.patch \
    && mkdir build_cmake \
    && cd build_cmake \
    && cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DTILEDB_WERROR=OFF -DTILEDB_SUPERBUILD=OFF  -DTILEDB_TESTS=OFF -DCOMPILER_SUPPORTS_AVX2=FALSE  -DOPENSSL_INCLUDE_DIR=/usr/include -DOPENSSL_CRYPTO_LIBRARY=/usr/lib/${GCC_ARCH}-linux-gnu/libcrypto.so -DOPENSSL_SSL_LIBRARY=/usr/lib/${GCC_ARCH}-linux-gnu/libssl.so \
    && make -j$(nproc) \
    && make -j$(nproc) install DESTDIR="/build_thirdparty" \
    && make -j$(nproc) install \
    && cd ../.. \
    && rm -rf tiledb \
    && for i in /build_thirdparty/usr/lib/${GCC_ARCH}-linux-gnu/*; do strip -s $i 2>/dev/null || /bin/true; done \
    && for i in /build_thirdparty/usr/bin/*; do strip -s $i 2>/dev/null || /bin/true; done

# Build openjpeg
ARG OPENJPEG_VERSION=
RUN . /buildscripts/bh-set-envvars.sh \
    && if test "${OPENJPEG_VERSION}" != ""; then ( \
    wget -q https://github.com/uclouvain/openjpeg/archive/v${OPENJPEG_VERSION}.tar.gz \
    && tar xzf v${OPENJPEG_VERSION}.tar.gz \
    && rm -f v${OPENJPEG_VERSION}.tar.gz \
    && cd openjpeg-${OPENJPEG_VERSION} \
    && cmake . -DBUILD_SHARED_LIBS=ON  -DBUILD_STATIC_LIBS=OFF -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr \
    && make -j$(nproc) \
    && make install \
    && mkdir -p /build_thirdparty/usr/lib/${GCC_ARCH}-linux-gnu \
    && rm -f /usr/lib/${GCC_ARCH}-linux-gnu/libopenjp2.so* \
    && mv /usr/lib/libopenjp2.so* /usr/lib/${GCC_ARCH}-linux-gnu \
    && cp -P /usr/lib/${GCC_ARCH}-linux-gnu/libopenjp2.so* /build_thirdparty/usr/lib/${GCC_ARCH}-linux-gnu \
    && for i in /build_thirdparty/usr/lib/${GCC_ARCH}-linux-gnu/*; do strip -s $i 2>/dev/null || /bin/true; done \
    && cd .. \
    && rm -rf openjpeg-${OPENJPEG_VERSION} \
    ); fi

#Build File Geodatabase

ARG WITH_FILEGDB=
RUN . /buildscripts/bh-set-envvars.sh \
  && if echo "$WITH_FILEGDB" | grep -Eiq "^(y(es)?|1|true)$"  ; then ( \
  wget -q https://github.com/Esri/file-geodatabase-api/raw/master/FileGDB_API_1.5.2/FileGDB_API-RHEL7-64gcc83.tar.gz \
  && tar -xzf FileGDB_API-RHEL7-64gcc83.tar.gz \
  && chown -R root:root FileGDB_API-RHEL7-64gcc83 \
  && mv FileGDB_API-RHEL7-64gcc83 /usr/local/FileGDB_API \
  && rm -rf /usr/local/FileGDB_API/lib/libstdc++* \
  && cp /usr/local/FileGDB_API/lib/* /build_thirdparty/usr/lib/x86_64-linux-gnu \
  && cp /usr/local/FileGDB_API/include/* /usr/include \
  && rm -rf FileGDB_API-RHEL7-64gcc83.tar.gz \
  ) ; fi

# Build libqb3
RUN . /buildscripts/bh-set-envvars.sh \
    && git clone https://github.com/lucianpls/QB3.git \
    && cd QB3/QB3lib \
    && mkdir build \
    && cd build \
    && cmake .. ${CMAKE_EXTRA_ARGS} -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release \
    && make -j$(nproc) \
    && make -j$(nproc) install \
    && make install DESTDIR="/build_thirdparty" \
    && cd ../../.. \
    && rm -rf QB3

ARG WITH_PDFIUM=yes
RUN if echo "$WITH_PDFIUM" | grep -Eiq "^(y(es)?|1|true)$"  ; then ( \
  wget -q https://github.com/rouault/pdfium_build_gdal_3_9/releases/download/pdfium_6309_v1/install-ubuntu2004-rev6309.tar.gz \
  && tar -xzf install-ubuntu2004-rev6309.tar.gz \
  && chown -R root:root install \
  && mv install/lib/* /usr/lib/ \
  && mv install/include/* /usr/include/ \
  && rm -rf install-ubuntu2004-rev6309.tar.gz install \
  && apt-get update -y \
  && apt-get install -y --fix-missing --no-install-recommends liblcms2-dev${APT_ARCH_SUFFIX} \
  && rm -rf /var/lib/apt/lists/* \
  ) ; fi

# Build libjxl
RUN . /buildscripts/bh-set-envvars.sh \
    && apt-get update -y \
    && apt-get install -y --fix-missing --no-install-recommends libgflags-dev${APT_ARCH_SUFFIX} \
    && git clone https://github.com/libjxl/libjxl.git --recursive \
    && cd libjxl \
    && mkdir build \
    && cd build \
    && cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DJPEGXL_ENABLE_JPEGLI_LIBJPEG=OFF -DBUILD_TESTING=OFF -DJPEGXL_ENABLE_TOOLS=OFF -DJPEGXL_ENABLE_BENCHMARK=OFF .. \
    && make -j$(nproc) \
    && make -j$(nproc) install \
    && make install DESTDIR="/build_thirdparty" \
    && rm -f /lib/${GCC_ARCH}-linux-gnu/libjxl*.a \
    && rm -f /build_thirdparty/lib/${GCC_ARCH}-linux-gnu/libjxl*.a \
    && cd ../.. \
    && rm -rf libjxl \
    && rm -rf /var/lib/apt/lists/*

# Install Arrow C++
ARG ARROW_VERSION=16.0.0-1
# ARROW_SOVERSION to be updated in the "Build final image" section too
ARG ARROW_SOVERSION=1600
RUN . /buildscripts/bh-set-envvars.sh \
    && apt-get update -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y -V ca-certificates lsb-release wget \
    && wget https://apache.jfrog.io/artifactory/arrow/$(lsb_release --id --short | tr 'A-Z' 'a-z')/apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y -V ./apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y -V libarrow${ARROW_SOVERSION}${APT_ARCH_SUFFIX} \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y -V libparquet${ARROW_SOVERSION}${APT_ARCH_SUFFIX} \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y -V libarrow-dataset${ARROW_SOVERSION}${APT_ARCH_SUFFIX} \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y -V libarrow-dev${APT_ARCH_SUFFIX}=${ARROW_VERSION} \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y -V libparquet-dev${APT_ARCH_SUFFIX}=${ARROW_VERSION} \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y -V libarrow-acero-dev${APT_ARCH_SUFFIX}=${ARROW_VERSION} \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y -V libarrow-dataset-dev${APT_ARCH_SUFFIX}=${ARROW_VERSION} \
    && rm -rf /var/lib/apt/lists/* \
    && rm apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb

RUN apt-get update -y \
    && apt-get install -y --fix-missing --no-install-recommends rsync ccache \
    && rm -rf /var/lib/apt/lists/*
ARG RSYNC_REMOTE

ARG WITH_DEBUG_SYMBOLS=no

# Refresh grids
ARG PROJ_DATUMGRID_LATEST_LAST_MODIFIED
ARG PROJ_INSTALL_PREFIX=/usr/local
RUN cp -v /gdal/docker/ubuntu-full/bh-proj.sh /buildscripts/bh-proj.sh
# We build PROJ a first time, just to build the projsync utility if grids need
# to be refreshed. We will rebuild just afterwards, but depending on the
# PROJ_VERSION argument
# We want 2 separate steps for incremental builds where grids are refreshed
# only when the content of cdn.proj.org has changed, independently if PROJ master
# itself has changed.
RUN . /buildscripts/bh-set-envvars.sh \
    && DESTDIR=/build_tmp_proj /buildscripts/bh-proj.sh \
     && LD_LIBRARY_PATH=/build_tmp_proj/usr/local/lib /build_tmp_proj/usr/local/bin/projsync --target-dir /tmp/proj_grids --all \
     && rm -rf /build_tmp_proj

# Build PROJ
ARG PROJ_VERSION=master
RUN . /buildscripts/bh-set-envvars.sh \
    && /buildscripts/bh-proj.sh

ARG GDAL_VERSION=master
ARG GDAL_RELEASE_DATE
ARG GDAL_BUILD_IS_RELEASE
ARG GDAL_REPOSITORY=OSGeo/gdal

# Build GDAL

RUN cp -v /gdal/docker/ubuntu-full/bh-gdal.sh /buildscripts/bh-gdal.sh
RUN . /buildscripts/bh-set-envvars.sh \
    && /buildscripts/bh-gdal.sh

USER root
RUN date
ARG JAVA_VERSION=17
ARG ARROW_SOVERSION=1600

# Update distro
RUN apt-get update -y && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/*

ARG TARGET_ARCH=
RUN apt-get update \
# PROJ dependencies
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        libsqlite3-0 libtiff6 libcurl4 \
        wget curl unzip ca-certificates \
# GDAL dependencies
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        libopenjp2-7 libcairo2 python3-numpy \
        libpng16-16 libjpeg-turbo8 libgif7 liblzma5 libgeos3.12.1 libgeos-c1v5 \
        libxml2 libexpat1 \
        libxerces-c3.2 libnetcdf-c++4-1 netcdf-bin libpoppler134 libspatialite8 librasterlite2-1 gpsbabel \
        libhdf4-0-alt libhdf5-103-1 libhdf5-cpp-103-1 poppler-utils libfreexl1 unixodbc mdbtools libwebp7 \
        liblcms2-2 libpcre3 libcrypto++8 libfyba0 \
        libkmlbase1 libkmlconvenience1 libkmldom1 libkmlengine1 libkmlregionator1 libkmlxsd1 \
        libmysqlclient21 libogdi4.1 libcfitsio10 \
        libzstd1 bash bash-completion libpq5 \
        libarmadillo12 libpython3.12 libopenexr-3-1-30 libheif1 \
        libdeflate0 libblosc1 liblz4-1 \
        libbrotli1 \
        libarchive13 \
        libaec0 \
        libspdlog1.12 libmagic1t64 \
        python-is-python3 \
        # pil for antialias option of gdal2tiles
        python3-pil \
    # Install JRE with --no-install-recommends, otherwise it draws default-jre, which draws systemd, which fails to install when running the arm64v8/ubuntu:24.04 image on a 64bit host
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends openjdk-"$JAVA_VERSION"-jre \
    # Worksround OGDI packaging bug for Ubuntu 24.04
    && ln -s /usr/lib/$(uname -p)-linux-gnu/ogdi/4.1/libvrf.so /usr/lib/$(uname -p)-linux-gnu \
    # Install Arrow C++
    && DEBIAN_FRONTEND=noninteractive apt-get install -y -V ca-certificates lsb-release wget \
    && wget https://apache.jfrog.io/artifactory/arrow/$(lsb_release --id --short | tr 'A-Z' 'a-z')/apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y -V ./apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y -V libarrow${ARROW_SOVERSION} \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y -V libparquet${ARROW_SOVERSION} \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y -V libarrow-dataset${ARROW_SOVERSION} \
    && rm -rf /var/lib/apt/lists/*

# Attempt to order layers starting with less frequently varying ones

RUN cp -rv /build_thirdparty/usr/ /usr/

ARG PROJ_INSTALL_PREFIX=/usr/local
RUN cp -rv /tmp/proj_grids/* ${PROJ_INSTALL_PREFIX}/share/proj/

RUN cp -rv /build${PROJ_INSTALL_PREFIX}/share/proj/ ${PROJ_INSTALL_PREFIX}/share/proj/
RUN cp -rv /build${PROJ_INSTALL_PREFIX}/include/ ${PROJ_INSTALL_PREFIX}/include/
RUN cp -rv /build${PROJ_INSTALL_PREFIX}/bin/ ${PROJ_INSTALL_PREFIX}/bin/
RUN cp -rv /build${PROJ_INSTALL_PREFIX}/lib/ ${PROJ_INSTALL_PREFIX}/lib/

RUN cp -rv /build/usr/share/java /usr/share/java
RUN cp -rv /build/usr/share/gdal/ /usr/share/gdal/
RUN cp -rv /build/usr/include/ /usr/include/
RUN cp -rv /build_gdal_python/usr/ /usr/
RUN cp -rv /build_gdal_version_changing/usr/ /usr/

RUN ldconfig