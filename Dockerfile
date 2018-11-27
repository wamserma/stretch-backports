FROM debian:stretch

ENV DEBIAN_FRONTEND noninteractive 
LABEL description="Debian Stretch based image for backports to debian stretch"

RUN echo deb http://ftp.debian.org/debian stretch-backports main | tee -a /etc/apt/sources.list
RUN apt update && apt install -y \
    build-essential \ 
    curl \ 
    packaging-dev \
    debian-keyring \ 
    devscripts \ 
    equivs; \
    apt -y -t stretch-backports install debhelper; \
    apt -y autoremove
RUN useradd -ms /bin/bash builder && usermod -aG sudo builder && echo builder ALL = NOPASSWD:/usr/bin/mk-build-deps | tee -a /etc/sudoers 
USER builder
WORKDIR  /home/builder
ADD scripts/ /scripts/

# prepare ~/.gpg
RUN gpg -k

