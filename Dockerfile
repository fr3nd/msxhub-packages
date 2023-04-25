FROM ubuntu:18.04

MAINTAINER Carles Amigó, fr3nd@fr3nd.net

RUN apt-get update && apt-get install -y \
      arj \
      bzip2 \
      curl \
      dos2unix \
      jq \
      lhasa \
      locales \
      make \
      mtools \
      p7zip-full \
      poppler-utils \
      python3 \
      python3-pytest \
      python3-requests \
      python3-yaml \
      rsync \
      ruby \
      unrar \
      unzip \
      && rm -rf /usr/share/doc/* && \
      rm -rf /usr/share/info/* && \
      rm -rf /tmp/* && \
      rm -rf /var/tmp/*

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

WORKDIR /usr/src
