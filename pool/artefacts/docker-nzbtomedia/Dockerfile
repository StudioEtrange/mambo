FROM ghcr.io/linuxserver/baseimage-ubuntu:bionic

LABEL maintainer "StudioEtrange <sboucault@gmail.com>"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ENV PYTHONIOENCODING=utf-8


RUN \
 echo "**** install packages ****" && \
 apt-get update && \
 apt-get install -y \
	p7zip-full \
	python3 \
	python3-distutils \
    unzip \
	unrar && \
 echo "**** install pip ****" && \
 curl -fkSL https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
 python3 get-pip.py && \
 ln -s \
	/usr/bin/python3 \
	/usr/bin/python && \
 echo "**** cleanup ****" && \
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ /

# ports and volumes
VOLUME /app