FROM python:3.6
MAINTAINER Zach Mullen <zach.mullen@kitware.com>

RUN pip install cmake ninja scikit-build

# Download llvm
RUN wget http://releases.llvm.org/3.9.1/llvm-3.9.1.src.tar.xz && \
    tar xf llvm-3.9.1.src.tar.xz && rm llvm-3.9.1.src.tar.xz

# Build llvm
RUN cd /llvm-3.9.1.src && mkdir _build && cd _build && \
    cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DLLVM_BUILD_LLVM_DYLIB=ON \
    -DLLVM_ENABLE_RTTI=ON \
    -DLLVM_INSTALL_UTILS=ON \
    -DLLVM_TARGETS_TO_BUILD:STRING=X86 \
    .. && make -j4 && make install

# Download osmesa
RUN wget https://mesa.freedesktop.org/archive/mesa-17.2.4.tar.xz && \
    tar xf mesa-17.2.4.tar.xz && rm mesa-17.2.4.tar.xz

# Build osmesa
RUN cd /mesa-17.2.4 && ./configure \
    --disable-xvmc \
    --disable-glx \
    --disable-dri \
    --disable-gbm \
    --with-dri-drivers= \
    --with-gallium-drivers=swrast \
    --enable-texture-float \
    --disable-egl \
    --with-platforms= \
    --enable-gallium-osmesa \
    --enable-llvm && \
    make -j4 && make install

# Build VTK with python
COPY . /VTKPythonPackage

RUN cd /VTKPythonPackage && \
    VTK_CMAKE_ARGS="-DVTK_OPENGL_HAS_OSMESA:BOOL=ON -DVTK_Group_Web:BOOL=ON" python setup.py bdist_wheel
RUN pip install /VTKPythonPackage/dist/vtk-*.whl && \
    ldconfig && \
    rm -rf /VTKPythonPackage && rm -rf /mesa-17.2.4 && rm -rf /llvm-3.9.1.src