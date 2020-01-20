#!/bin/bash -eux

cd ~/buildroot
make -C build 2>&1 | tee "make_$(date '+%Y%m%d-%k%M%S').log"
