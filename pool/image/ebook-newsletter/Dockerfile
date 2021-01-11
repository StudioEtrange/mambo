FROM lsiobase/ubuntu:bionic
#FROM almir/webhook:2.8

LABEL maintainer "StudioEtrange <sboucault@gmail.com>"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ENV PYTHONIOENCODING=utf-8

# install python
# install yq/xq
# install jq
# install calibre

# install almir

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
VOLUME /config
VOLUME /newsletter


    # volumes:
    #   # data/tautulli will contain tautulli configuration
    #   - data:/data
    #   # newsletters_data will be used for generated newsletter
    #   - newsletters_data:/data/tautulli/newsletters

# https://github.com/adnanh/webhook
# https://hub.docker.com/r/almir/webhook
EXPOSE 9000
#CMD ["/app/webhook/webhook", "-verbose", "-hooks=/etc/webhook/hooks.json", "-hotreload"]