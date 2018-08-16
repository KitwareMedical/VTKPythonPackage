#!/usr/bin/env bash

# This script creates a tarball of the VTK Python package build tree. It is
# downloaded by the external module build scripts and used to build their
# Python package on GitHub CI services.

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR/../..

tar -c --to-stdout \
  VTKPythonPackage/VTK-* \
  VTKPythonPackage/standalone-* \
  VTKPythonPackage/scripts > VTKPythonBuilds-linux.tar
ZSTD=zstd
if test -e /home/kitware/Support/zstd-build/programs/zstd; then
  ZSTD=/home/kitware/Support/zstd-build/programs/zstd
fi
$ZSTD -f \
  ./VTKPythonBuilds-linux.tar \
  -o ./VTKPythonBuilds-linux.tar.zst
