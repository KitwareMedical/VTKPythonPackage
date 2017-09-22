#!/bin/bash
set -e -x

PYBIN_TAG=${TRAVIS_PYTHON_VERSION//[^[:digit:]]/}
PYBIN=cp${PYBIN_TAG}-cp${PYBIN_TAG}m

echo $PYBIN_TAG
echo $PYBIN

# Link ccache
ln -s /ccache $HOME/.ccache

# Activate the virtualenv
/opt/python/cp36-cp36m/bin/python -m venv venv
source venv/bin/activate

# Install yum packages
yum install -y ccache libXt-devel

# Use and verify ccache
CCACHE_DIR=$PWD/deps/ccache
mkdir -p $CCACHE_DIR
ln -s /usr/bin/ccache $CCACHE_DIR/gcc
ln -s /usr/bin/ccache $CCACHE_DIR/g++
ln -s /usr/bin/ccache $CCACHE_DIR/cc
ln -s /usr/bin/ccache $CCACHE_DIR/c++
export PATH=$CCACHE_DIR:$PATH
which gcc

# Install a newer CMake
if [ $TARGET_ARCH == "x64" ]; then
  CMAKE_URL="https://cmake.org/files/v3.5/cmake-3.5.2-Linux-x86_64.tar.gz"  
else
  CMAKE_URL="https://cmake.org/files/v3.5/cmake-3.5.2-Linux-i386.tar.gz"  
fi

DEPS_DIR="${TRAVIS_BUILD_DIR}/deps"
CMAKE_DIR="${DEPS_DIR}/cmake"
mkdir -p ${DEPS_DIR}
mkdir $CMAKE_DIR && wget --no-check-certificate --quiet -O - ${CMAKE_URL} | tar --strip-components=1 -xz -C $CMAKE_DIR
export PATH=$CMAKE_DIR/bin:$PATH

# Change directories
cd /io/

source scripts/build.sh
