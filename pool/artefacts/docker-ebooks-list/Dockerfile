FROM lsiobase/ubuntu:bionic

LABEL maintainer "StudioEtrange <sboucault@gmail.com>"

# environment settings
ENV DEBIAN_FRONTEND="noninteractive"
ENV PYTHONIOENCODING=utf-8

RUN \
 echo "**** install packages ****" && \
 apt-get update && \
 apt-get install -y \
	python3 \
	python3-distutils \
	nano \
	moreutils \
    unzip \
	jq && \
 echo "**** install pip ****" && \
 curl -fkSL "https://bootstrap.pypa.io/get-pip.py" -o get-pip.py && \
 python3 get-pip.py && \
 ln -s \
	/usr/bin/python3 \
	/usr/bin/python && \
 echo "**** install python tools ****" && \
 pip install \
 	yq==2.11.1 \
	python-dateutil==2.8.1 \
 	Mako==1.1.3 && \
 echo "**** install webhook ****" && \
 curl -fkSL "https://github.com/adnanh/webhook/releases/download/2.8.0/webhook-linux-amd64.tar.gz" -o /tmp/webhook-linux-amd64.tar.gz && \
 mkdir -p /app/webhook && \
 tar xvzf /tmp/webhook-linux-amd64.tar.gz --strip-components=1 -C /app && \
 echo "**** cleanup ****" && \
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ /

# ports and volumes
# will contain config
VOLUME /config
# where to mount different calibre database
# if you have several you should mount all of them into /calibredb
# example : --volume $HOME/ebooks:/calibredb/ebooks
#		  here ebooks is the calibre db name
VOLUME /calibredb


EXPOSE 9000
