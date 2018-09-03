FROM debian:jessie

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
      python3 \
      python3-requests \
      python3-yaml \
      rsync \
      ruby \
      unzip \
      && rm -rf /usr/share/doc/* && \
      rm -rf /usr/share/info/* && \
      rm -rf /tmp/* && \
      rm -rf /var/tmp/*

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
RUN locale-gen C.UTF-8

COPY tools/build /usr/bin

WORKDIR /usr/src
