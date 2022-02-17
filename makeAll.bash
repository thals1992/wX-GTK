#!/bin/bash
#
# if downloading zip for git clone for first time
# run this to fully setup and run
# after, just run "./run.bash"
#
#
cd resourceCreation
./makeAll.py
cd ..
rm -rf build
if [ "$(uname)" == "Darwin" ]; then
    export PKG_CONFIG_PATH="/usr/local/opt/icu4c/lib/pkgconfig:/opt/homebrew/opt/libsoup@2/lib/pkgconfig"       
fi
./makeMesonGtk3.py
meson build
./run.bash "$@"
