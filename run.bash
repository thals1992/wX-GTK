#!/bin/bash
#
# compile and run program
#
ulimit -c unlimited
buildCommand="ninja"
if [ "$1" != "" ]; then
	buildCommand="ninja -j ${1}"
fi
echo ${buildCommand}

cd build
if ${buildCommand}; then
	mv wxgtk ..
	cd ..
	./wxgtk
else
	compilation failed
fi
