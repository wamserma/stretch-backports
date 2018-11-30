#!/bin/bash

#  fix ownership of build results
chown $1:$2 ../*.deb

# copy results
cp -p ../*.deb /pkgs/.

