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
RUN useradd -ms /bin/bash builder && usermod -aG sudo builder && echo builder ALL = NOPASSWD:/usr/bin/mk-build-deps, NOPASSWD:/scripts/export-debs.sh | tee -a /etc/sudoers 

ADD scripts/ /scripts/
RUN chown root:builder /scripts/export-debs.sh
RUN chmod 0500 /scripts/export-debs.sh

# switch user
USER builder
WORKDIR  /home/builder

# prepare ~/.gpg
RUN gpg -k

