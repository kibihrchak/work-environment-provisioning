#!/bin/bash -eux

cd ~/yocto/build
bitbake core-image-minimal 2>&1 | \
    tee "../make_$(date '+%Y%m%d-%k%M%S').log"
