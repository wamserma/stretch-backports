#!/bin/bash

# get source
dget -x http://deb.debian.org/debian/pool/main/o/opensc/opensc_0.19.0-1.dsc
cd opensc-0.19.0

# install builddeps noninteractively
sudo mk-build-deps -t "apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends -y" --install --remove 

# fix version so regular package may update over this
dch --local ~bpo1+ --distribution stretch-backports "Rebuild for stretch-backports."

# build
fakeroot debian/rules binary
dpkg-buildpackage -us -uc

# copy results
sudo /scripts/export-debs.sh ${HUID:-1000} ${HGID:-1000}

if [ "$1" != "nocleanup" ]; then
  sudo apt -y remove opensc-build-deps && sudo apt autoremove
fi

# Done.
