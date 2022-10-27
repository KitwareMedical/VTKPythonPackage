#!/bin/bash

# DEBUG
echo USING_DOCKER $USING_DOCKER
echo PYTHON $PYTHON

# Clone the VTK repo and checkout desired release
git clone https://gitlab.kitware.com/vtk/vtk.git
cd vtk
git checkout -b v9.2.2 tags/v9.2.2
cd ..

# Make a directory for the build
mkdir vtk_build
cd vtk_build

# Basic config (big, lots of dependencies)
#FLAGS="-DVTK_WHEEL_BUILD=ON -DVTK_PYTHON_VERSION=3 -DVTK_WRAP_PYTHON=ON"

# Minimal config (small, doesn't depend on OpenGL, MPI, etc)
FLAGS="-DCMAKE_BUILD_TYPE='Release' \
    -DBUILD_SHARED_LIBS=ON \
    -DBUILD_TESTING=OFF \
    -DVTK_PYTHON_VERSION=3 \
    -DVTK_WRAP_PYTHON=ON \
    -DVTK_WHEEL_BUILD=ON \
    -DVTK_GROUP_ENABLE_Imaging=NO \
    -DVTK_GROUP_ENABLE_MPI=NO \
    -DVTK_GROUP_ENABLE_Qt=NO \
    -DVTK_GROUP_ENABLE_StandAlone=NO \
    -DVTK_GROUP_ENABLE_Views=NO \
    -DVTK_GROUP_ENABLE_Web=NO \
    -DVTK_MODULE_ENABLE_VTK_CommonCore=YES \
    -DVTK_MODULE_ENABLE_VTK_CommonExecutionModel=YES \
    -DVTK_MODULE_ENABLE_VTK_CommonMath=YES \
    -DVTK_MODULE_ENABLE_VTK_CommonMisc=YES \
    -DVTK_MODULE_ENABLE_VTK_CommonSystem=YES \
    -DVTK_MODULE_ENABLE_VTK_CommonTransforms=YES \
    -DVTK_MODULE_ENABLE_VTK_IOCore=YES \
    -DVTK_MODULE_ENABLE_VTK_IOLegacy=YES \
    -DVTK_MODULE_ENABLE_VTK_IOParallelXML=YES \
    -DVTK_MODULE_ENABLE_VTK_IOXML=YES \
    -DVTK_MODULE_ENABLE_VTK_IOXMLParser=YES \
    -DVTK_MODULE_ENABLE_VTK_ParallelCore=YES"

# Ninja build
cmake -GNinja \
    $FLAGS \
    ../vtk
ninja

# Makefile build (if no ninja)
#cmake -G"Unix Makefiles" \
#    $FLAGS \
#    ../vtk
#make

# If running in a Docker container use Python specifed by $PYTHON variable
if [ $USING_DOCKER -eq 1 ]
    then
    $PYTHON setup.py bdist_wheel
else
    python setup.py bdist_wheel
fi

# Use auditwheel to produce manylinux wheel
# For some reason auditwheel can't find libvtksys-9.2.so
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/root/vtk_build/build/lib.linux-x86_64-3.11/vtkmodules
auditwheel repair dist/*.whl

