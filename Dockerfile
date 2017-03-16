FROM ubuntu:16.04
MAINTAINER Benoit Beausejour <b@turbulent.ca>

ENV heap-base 3.0.0

# Install packages
ENV DEBIAN_FRONTEND noninteractive
RUN echo "#deb http://archive.ubuntu.com/ubuntu/ xenial-proposed main restricted"  > /etc/apt/sources.list.d/proposed.list

COPY docker-gpg.key /root/
RUN apt-get update &&  \
  apt-get -y upgrade && \
  apt-get install -y ssmtp && \  
  apt-get install -y bsd-mailx && \
  apt-get -y install supervisor && \
  apt-get install -y python-pip && \
  apt-get install -y python-yaml && \
  pip install pystache && \
  pip install Jinja2 && \
  apt-get -y install apt-transport-https ca-certificates curl software-properties-common && \
  apt-key add /root/docker-gpg.key && \
  add-apt-repository "deb https://apt.dockerproject.org/repo/ ubuntu-$(lsb_release -cs) main" && \
  apt-get update && \
  apt-get install -y docker-engine=1.13.1-0~ubuntu-xenial && \
  (adduser --system --uid 1000 --gid 33 --home /home/heap --shell /bin/bash heap) && \
  usermod -G docker heap && \
  rm -rf /var/lib/apt/lists/* && \
  apt-get -y clean 

RUN rm /root/docker-gpg.key

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
