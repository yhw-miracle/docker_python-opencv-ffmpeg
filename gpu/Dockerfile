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

RUN python3 -m pip install --no-cache tritonclient[all] tqdm pyturbojpeg pika scipy PyYAML matplotlib requests flask minio lapx ffmpeg-python xlrd xlwt openpyxl confluent_kafka

RUN python3 -m pip install --no-cache torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
RUN python3 -m pip install --no-cache onnxruntime-gpu --extra-index-url https://aiinfra.pkgs.visualstudio.com/PublicPackages/_packaging/onnxruntime-cuda-12/pypi/simple/
RUN python3 -m pip install --no-cache ultralytics==8.2.1

RUN \
    apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:ubuntugis/ubuntugis-unstable && \
    apt-get update && \
    apt-get install -y gdal-bin python3-gdal && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV GST_PLUGIN_FEATURE_RANK="nvcodec:256,nvh264dec:256,nvh265dec:256,nvvp9dec:256,nvvp8dec:256,nvh264enc:256,nvh265enc:256,avdec_h265:128,avdec_h264:128,avdec_vp9:128,avdec_vp8:128,avenc_h264_omx:128"
