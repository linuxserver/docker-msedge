FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm

# set version label
ARG BUILD_DATE
ARG EDGE_VERSION
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE=Edge

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /kclient/public/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/edge-logo.png && \
  apt-get update && \
  echo "**** install edge ****" && \
  if [ -z ${EDGE_VERSION+x} ]; then \
    EDGE_VERSION=$(curl -sL https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/ | awk -F'(<a href="microsoft-edge-stable_|_amd64.deb")' '/href=/ {print $2}' | sort --version-sort | tail -1); \
  fi && \
  curl -o \
    /tmp/edge.deb -L \
    "https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/microsoft-edge-stable_${EDGE_VERSION}_amd64.deb" && \
  apt install --no-install-recommends -y \
    /tmp/edge.deb && \
  echo "**** edge docker tweaks ****" && \
  mv \
    /usr/bin/microsoft-edge \
    /usr/bin/microsoft-edge-real && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
