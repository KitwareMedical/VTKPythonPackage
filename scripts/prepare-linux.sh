#!/bin/bash
set -e -x

PYBIN=cp36-cp36m

# Link ccache
ln -s /ccache $HOME/.ccache

# Activate the virtualenv
/opt/python/cp36-cp36m/bin/python -m venv venv
source venv/bin/activate

# Install ccache
yum install -y ccache

# Install a newer CMake
DEPS_DIR="${TRAVIS_BUILD_DIR}/deps"
CMAKE_DIR="${DEPS_DIR}/cmake"
mkdir -p ${DEPS_DIR}
CMAKE_URL="https://cmake.org/files/v3.9/cmake-3.9.2-Linux-x86_64.tar.gz"
mkdir $CMAKE_DIR && wget --no-check-certificate --quiet -O - ${CMAKE_URL} | tar --strip-components=1 -xz -C $CMAKE_DIR
export PATH=$CMAKE_DIR/bin:$PATH

# Change directories
cd /io/

source scripts/build.sh
