FROM ghcr.io/linuxserver/baseimage-alpine:3.11

# set version label
ARG BUILD_DATE
ARG VERSION
ARG PYLOAD_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
	build-base \
	curl-dev \
	libffi-dev \
	libjpeg-turbo-dev \
	openssl-dev \
	py2-pip \
	python2-dev \
	zlib-dev && \
 echo "**** install packages ****" && \
 apk add --no-cache \
	curl \
	ffmpeg \
	jq \
	libjpeg-turbo \
	nodejs \
	python2 \
	sqlite \
	tesseract-ocr \
	unrar \
	unzip \
	zlib && \
 pip install \
	pillow \
	pycrypto \
	pycurl \
	pyopenssl && \
 echo "**** install pyload ****" && \
 mkdir -p \
	/app/pyload && \
 if [ -z ${PYLOAD_VERSION+x} ]; then \
	PYLOAD_VERSION=$(curl -sX GET https://api.github.com/repos/pyload/pyload/commits/stable \
	| jq -r '.sha' | cut -c1-8); \
 fi && \
 curl -o \
 /tmp/pyload.tar.gz -L \
	"https://github.com/pyload/pyload/archive/${PYLOAD_VERSION}.tar.gz" && \
 tar xf \
 /tmp/pyload.tar.gz -C \
	/app/pyload --strip-components=1 && \
 echo "/config" > /app/pyload/module/config/configdir && \
 echo "**** cleanup ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8000 7227
VOLUME /config /downloads
