#!/usr/bin/env bash

# This script creates a tarball of the VTK Python package build tree. It is
# downloaded by the external module build scripts and used to build their
# Python package on GitHub CI services.

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR/../..

tar -cvf VTKPythonBuilds-macos.tar \
  VTKPythonPackage/VTK-* \
  VTKPythonPackage/standalone-* \
  VTKPythonPackage/scripts
ZSTD=zstd
if test -e /usr/local/bin/zstd; then
  ZSTD=/usr/local/bin/zstd
fi
$ZSTD -f \
  VTKPythonBuilds-macos.tar \
  -o VTKPythonBuilds-macos.tar.zst
