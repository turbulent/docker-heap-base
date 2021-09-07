FROM ubuntu:20.04
LABEL MAINTAINER='Benoit Beausejour <b@turbulent.ca>'

ENV heap-base 4.0.0

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update &&  \
  apt-get -y upgrade && \
  apt-get install -y \
    ssmtp \
    bsd-mailx \
    supervisor \
    python3-pip \
    python-yaml \
    apt-transport-https \
    lsb-release \
    ca-certificates \
    curl \
    software-properties-common && \
  pip install pystache Jinja2 && \
  (adduser --system --uid 1000 --gid 33 --home /home/heap --shell /bin/bash heap) && \
  rm -rf /var/lib/apt/lists/* && \
  apt-get -y clean

ADD systpl.mustache.py /systpl/
ADD systpl.jinja.py /systpl/
RUN ln -s /systpl/systpl.mustache.py /systpl/systpl.py

COPY ssmtp.conf.tmpl /systpl/

ENV VAR_SSMTP_ROOT_ALIAS "sys@turbulent.ca"
ENV VAR_SSMTP_MAILHUB "localhost"
ENV VAR_SSMTP_HOSTNAME "localhost"
ENV VAR_SSMTP_SSL "1"
ENV VAR_SSMTP_AUTH_USERNAME ""
ENV VAR_SSMTP_AUTH_PASSWORD ""

CMD []
ENTRYPOINT []
