# Docker: Python-OpenCV-FFmpeg(-CUDA)

Repository for clean Dockerfile containing [FFmpeg](https://www.ffmpeg.org/), [OpenCV3](https://opencv.org/) and [Python2/3](https://www.python.org/), based on [Ubuntu](https://www.ubuntu.com/) 16.04 LTS.


## Tags

* `:py2` Python 2.7, OpenCV 3.4.2, FFmpeg  
* `:py3` Python 3.5, OpenCV 3.4.2, FFmpeg  
* `:cuda-py2` Python 2.7, OpenCV 3.4.2, FFmpeg with CUDA 9.2 support  
* `:cuda-py3` Python 3.5, OpenCV 3.4.2, FFmpeg with CUDA 9.2 support  


## Build

[![Build Status](https://travis-ci.org/Borda/docker_python-opencv-ffmpeg.svg?branch=master)](https://travis-ci.org/Borda/docker_python-opencv-ffmpeg)
[![CircleCI](https://circleci.com/gh/Borda/docker_python-opencv-ffmpeg/tree/master.svg?style=svg)](https://circleci.com/gh/Borda/docker_python-opencv-ffmpeg/tree/master)

First you need to install docker on your local computer, see following [tutorial](https://docs.docker.com/install/linux/docker-ce/ubuntu/#set-up-the-repository). Note, for running the docker properly you have be logged as superuser otherwise you will face many partial issues which sometimes does not make much sense.

You can build it on your own, note it takes lots of time, be prepared.
``` bash
git clone <git-repository>
cd docker_python-opencv-ffmpeg
docker image build -t borda/docker_python-opencv-ffmpeg -f Dockerfile-py2 .
```
To build other versions, select different Dockerfile.

Other option is using already build image from DockerHub which is significantly faster. it basically download the already build image.
``` bash
docker pull borda/docker_python-opencv-ffmpeg
```


## Usage

Image has OpenCV3, Python2.7/3.5 and FFmpeg ready to use. Example:

``` bash
docker run --rm -it -v $PWD:/srv borda/docker_python-opencv-ffmpeg python
>>> import cv2; cv2.VideoCapture(0).read()
# truncated for transparency
(True, array([[[ 0, 43, 37], ...]], dtype=uint8))
```

Note, server usually doe not have webcam :)
