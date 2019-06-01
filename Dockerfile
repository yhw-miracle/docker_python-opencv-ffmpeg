# https://www.learnopencv.com/install-opencv3-on-ubuntu/

FROM ubuntu:18.04

ARG python_version=3.6
ARG OPENCV_VERSION=4.1.0

# Install all dependencies for OpenCV
RUN apt-get -y update && \
    apt-get -y install \
        python${python_version} \
        python${python_version}-dev \
        $( [ ${python_version%%.*} -ge 3 ] && echo "python${python_version%%.*}-distutils" ) \
        wget \
        unzip \
        cmake \
        libtbb2 \
        gfortran \
        apt-utils \
        pkg-config \
        checkinstall \
        qt5-default \
        build-essential \
        libatlas-base-dev \
        libgtk2.0-dev \
        libavcodec-dev \
        libavformat-dev \
        libavutil-dev \
        libswscale-dev \
        libjpeg8-dev \
        libpng-dev \
        libtiff5-dev \
        libdc1394-22-dev \
        libxine2-dev \
        libv4l-dev \
        libgstreamer1.0 \
        libgstreamer1.0-dev \
        libgstreamer-plugins-base1.0-dev \
        libglew-dev \
        libpostproc-dev \
        libeigen3-dev \
        libtbb-dev \
        zlib1g-dev \
        libsm6 \
        libxext6 \
        libxrender1 \
    && \

# install python dependencies
    sysctl -w net.ipv4.ip_forward=1 && \
    wget https://bootstrap.pypa.io/get-pip.py --progress=bar:force:noscroll && \
    python${python_version} get-pip.py && \
    pip${python_version} install numpy && \

# Install OpenCV
    wget https://github.com/opencv/opencv/archive/$OPENCV_VERSION.zip -O opencv.zip --progress=bar:force:noscroll && \
    unzip -q opencv.zip && \
    mv /opencv-$OPENCV_VERSION /opencv && \
    rm opencv.zip && \
    wget https://github.com/opencv/opencv_contrib/archive/$OPENCV_VERSION.zip -O opencv_contrib.zip --progress=bar:force:noscroll && \
    unzip -q opencv_contrib.zip && \
    mv /opencv_contrib-$OPENCV_VERSION /opencv_contrib && \
    rm opencv_contrib.zip && \

# Prepare build
    mkdir /opencv/build && \
    cd /opencv/build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D BUILD_PYTHON_SUPPORT=ON \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib/modules \
      -D BUILD_opencv_python3=$( [ ${python_version%%.*} -ge 3 ] && echo "ON" || echo "OFF" ) \
      -D BUILD_opencv_python2=$( [ ${python_version%%.*} -lt 3 ] && echo "ON" || echo "OFF" ) \
      -D PYTHON${python_version%%.*}_EXECUTABLE=$(which python${python_version}) \
      -D PYTHON_DEFAULT_EXECUTABLE=$(which python${python_version}) \
      -D BUILD_EXAMPLES=OFF \
      -D WITH_IPP=OFF \
      -D WITH_FFMPEG=ON \
      -D WITH_GSTREAMER=ON \
      -D WITH_V4L=ON \
      -D WITH_LIBV4L=ON \
      -D WITH_TBB=ON \
      -D WITH_QT=ON \
      -D WITH_OPENGL=ON \
      .. \
    && \

# Build, Test and Install
    cd /opencv/build && \
    make -j$(nproc) && \
    make install && \
    ldconfig && \

# cleaning
    apt-get -y remove \
        unzip \
        cmake \
        gfortran \
        apt-utils \
        pkg-config \
        checkinstall \
        build-essential \
        libatlas-base-dev \
        libgtk2.0-dev \
        libavcodec-dev \
        libavformat-dev \
        libavutil-dev \
        libswscale-dev \
        libjpeg8-dev \
        libpng12-dev \
        libtiff5-dev \
        libdc1394-22-dev \
        libxine2-dev \
        libv4l-dev \
        libgstreamer1.0-dev \
        libgstreamer-plugins-base1.0-dev \
        libglew-dev \
        libpostproc-dev \
        libeigen3-dev \
        libtbb-dev \
        zlib1g-dev \
    && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /opencv /opencv_contrib /var/lib/apt/lists/*

# Set the default python and install PIP packages
RUN update-alternatives --install /usr/bin/python${python_version%%.*} python${python_version%%.*} /usr/bin/python${python_version} 1 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python${python_version} 1 && \
    wget https://bootstrap.pypa.io/get-pip.py --progress=bar:force:noscroll && \
    python get-pip.py && \
    rm get-pip.py && \
    pip install opencv-python \
                opencv-contrib-python \
    && \

# Call default command.
    pip --version && \
    python -c "import cv2 ; print(cv2.__version__)"
