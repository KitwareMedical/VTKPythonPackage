FROM python:3.6
MAINTAINER Zach Mullen <zach.mullen@kitware.com>

RUN apt-get update && apt-get install -y libglapi-mesa libosmesa6 freeglut3-dev && \
    pip install cmake ninja scikit-build

COPY . /VTKPythonPackage

RUN cd VTKPythonPackage && \
    VTK_CMAKE_ARGS="-DVTK_Group_Web:BOOL=ON" python setup.py bdist_wheel
RUN pip install /VTKPythonPackage/dist/vtk-*.whl
