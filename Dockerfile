FROM lsiobase/alpine:3.9

RUN \
 echo "**** install packages ****" && \
 apk add --no-cache \
	curl \
	jq \
	nodejs \
	py-curl \
	py-imaging \
	py2-crypto \
	py2-openssl \
	python2 \
	sqlite \
	tesseract-ocr \
	unrar \
	unzip && \
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
 rm -rf \
	/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8000 7227
VOLUME /config /downloads
