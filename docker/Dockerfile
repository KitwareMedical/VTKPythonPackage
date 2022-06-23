FROM quay.io/pypa/manylinux2014_x86_64
RUN yum makecache && \
    yum -y install ninja-build
WORKDIR /root
RUN git clone https://github.com/firedrakeproject/VTKPythonPackage.git
ENV USING_DOCKER 1
ENV PYTHON /opt/python/cp311-cp311/bin/python3
RUN VTKPythonPackage/build_vtk_wheel.sh
