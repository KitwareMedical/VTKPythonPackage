#!/bin/bash
set -e -x

# Link ccache and pip cache
ln -s /ccache $HOME/.ccache
ln -s /cache $HOME/.cache

PYBIN=cp${PYTHON_TAG}-cp${PYTHON_TAG}m
echo $PYTHON_TAG
echo $PYBIN

# Activate the virtualenv
if [ $TRAVIS_PYTHON_VERSION == '2.7' ]; then
    /opt/python/${PYBIN}/bin/python -m pip install virtualenv
    /opt/python/${PYBIN}/bin/python -m virtualenv venv
else
    /opt/python/${PYBIN}/bin/python -m venv venv
fi
source venv/bin/activate

# Install yum packages
yum install -y ccache libXt-devel
DEPS_DIR="$PWD/deps"

# Use and verify ccache
CCACHE_DIR=$DEPS_DIR/ccache
mkdir -p $CCACHE_DIR
ln -s /usr/bin/ccache $CCACHE_DIR/gcc
ln -s /usr/bin/ccache $CCACHE_DIR/g++
ln -s /usr/bin/ccache $CCACHE_DIR/cc
ln -s /usr/bin/ccache $CCACHE_DIR/c++
export PATH=$CCACHE_DIR:$PATH
which gcc

# Install a newer CMake
pip install cmake

# Change directories
cd /io/

source scripts/build.sh
