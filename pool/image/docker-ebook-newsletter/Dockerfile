FROM lsiobase/ubuntu:bionic
#FROM almir/webhook:2.8
# docker run -it -e PUID=$(id -u) -e PGID=$(id -g) -e DOCKER_MODS=studioetrange/calibre-mod:v5.9.0 --volume $HOME/testconfig:/config --volume $HOME/testnews:/newsletter --volume /mnt/NEON_EBOOKS/books:/calibredb/books i bash
# docker run -it -e PUID=$(id -u) -e PGID=$(id -g) -e DOCKER_MODS=studioetrange/calibre-mod:v5.9.0 --volume $HOME/testconfig:/config --volume $HOME/testnews:/newsletter --volume /mnt/NEON_EBOOKS/books:/calibredb/books i bash
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
# will contain generated files
VOLUME /newsletter
# where to mount different calibre database
# if you have several you should mount all of them into /calibredb
# example : --volume $HOME/ebooks:/calibredb/ebooks
#		  here ebooks is the calibre db name
VOLUME /calibredb


# https://github.com/adnanh/webhook
# https://hub.docker.com/r/almir/webhook
EXPOSE 9000
