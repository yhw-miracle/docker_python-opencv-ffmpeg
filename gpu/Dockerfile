ARG CUDA_VERSION=12.2.0
ARG UBUNTU_VERSION=22.04

#FROM nvidia/cuda:${CUDA_VERSION}-devel-ubuntu${UBUNTU_VERSION}
FROM nvcr.io/nvidia/tensorrt:23.10-py3
LABEL maintainer="https://github.com/Borda"

ARG PYTHON_VERSION=3.10
ARG OPENCV_VERSION=4.8.1

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
        #$( [ "$UBUNTU_VERSION" = "20.04" ] && libtbb2 || libtbb12 ) \
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
        libgstreamer1.0 \
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
        libglew-dev \
        libpostproc-dev \
        libeigen3-dev \
        libtbb-dev \
        zlib1g-dev \
        libsm6 \
        libxext6 \
        libxrender1 \
        libswresample-dev \
        libdc1394-25 \
        libfreetype-dev \
        libharfbuzz-dev \
        libtesseract-dev \
        libtesseract4 \
    && \
    pip install numpy

#WORKDIR /root/
#COPY opencv.zip /root/opencv.zip
#COPY opencv_contrib.zip /root/opencv_contrib.zip
# Install OpenCV
RUN \
    wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip -O opencv.zip --progress=bar:force:noscroll --no-check-certificate && \
    unzip -q opencv.zip && \
    mv /opencv-${OPENCV_VERSION} /opencv && \
    rm opencv.zip && \
    wget https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip -O opencv_contrib.zip --progress=bar:force:noscroll --no-check-certificate && \
    unzip -q opencv_contrib.zip && \
    mv /opencv_contrib-${OPENCV_VERSION} /opencv_contrib && \
    rm opencv_contrib.zip

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
      -D ENABLE_PRECOMPILED_HEADERS=OFF \
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
        #cmake \
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
    && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /opencv /opencv_contrib /var/lib/apt/lists/*

RUN apt install --no-install-recommends -y git zip unzip curl htop libgl1-mesa-glx libglib2.0-0 libpython3-dev gnupg g++ libturbojpeg vim python3 python3-pip ffmpeg
# RUN alias python=python3

# Remove python3.11/EXTERNALLY-MANAGED or use 'pip install --break-system-packages' avoid 'externally-managed-environment' Ubuntu nightly error
# RUN rm -rf /usr/lib/python3.11/EXTERNALLY-MANAGED

# Install pip packages
#RUN python3 -m pip install --no-cache -e . thop --extra-index-url https://download.pytorch.org/whl/cpu
RUN python3 -m pip install --no-cache tritonclient[all] tqdm pyturbojpeg pika scipy PyYAML matplotlib requests flask minio lapx ffmpeg-python


RUN \
    # Call default command.
    ffmpeg -version && \
    #ldd `which ffmpeg` && \
    python --version && \
    pip list && \
    python -c "import cv2 ; print(cv2.__version__)"

