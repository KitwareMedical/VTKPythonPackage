#!/usr/bin/env bash

# -----------------------------------------------------------------------
# These variables are set in common script:
#
ARCH=""
PYBINARIES=""
PYTHON_LIBRARY=""

script_dir=$(cd $(dirname $0) || exit 1; pwd)
source "${script_dir}/manylinux-build-common.sh"
# -----------------------------------------------------------------------

# VTK requirements
gosu root yum install -y libXt-devel mesa-libGL-devel

# Build standalone project and populate archive cache
mkdir -p /work/standalone-${ARCH}-build
pushd /work/standalone-${ARCH}-build > /dev/null 2>&1
  cmake -DVTKPythonPackage_BUILD_PYTHON:PATH=0 -G Ninja ../
  ninja
popd > /dev/null 2>&1

# Compile wheels re-using standalone project and archive cache
for PYBIN in "${PYBINARIES[@]}"; do
    export PYTHON_EXECUTABLE=${PYBIN}/python
    PYTHON_INCLUDE_DIR=$( find -L ${PYBIN}/../include/ -name Python.h -exec dirname {} \; )

    echo ""
    echo "PYTHON_EXECUTABLE:${PYTHON_EXECUTABLE}"
    echo "PYTHON_INCLUDE_DIR:${PYTHON_INCLUDE_DIR}"
    echo "PYTHON_LIBRARY:${PYTHON_LIBRARY}"

    # Install dependencies
    ${PYBIN}/pip install --upgrade -r /work/requirements-dev.txt

    build_type=MinSizeRel
    source_path=/work/standalone-${ARCH}-build/VTK-source
    build_path=/work/VTK-$(basename $(dirname ${PYBIN}))-manylinux1_${ARCH}

    # Clean up previous invocations
    rm -rf ${build_path}

    echo "#"
    echo "# Build single VTK wheel"
    echo "#"

    # Generate wheel
    ${PYBIN}/python setup.py bdist_wheel --build-type ${build_type} -G Ninja -- \
          -DVTK_SOURCE_DIR:PATH=${source_path} \
          -DVTK_BINARY_DIR:PATH=${build_path} \
          -DCMAKE_CXX_COMPILER_TARGET:STRING=$(uname -p)-linux-gnu \
          -DPYTHON_EXECUTABLE:FILEPATH=${PYTHON_EXECUTABLE} \
          -DPYTHON_INCLUDE_DIR:PATH=${PYTHON_INCLUDE_DIR} \
          -DPYTHON_LIBRARY:FILEPATH=${PYTHON_LIBRARY}
    # Cleanup
    ${PYBIN}/python setup.py clean

    # Remove unnecessary files for building against VTK
    find ${build_path} -name '*.o' -delete
done

# Fixup the wheels (update from 'linux' to 'manylinux1' tag)
for whl in dist/*linux_$(uname -p).whl; do
    # XXX Explicitly specify lib subdirectory to copy needed libraries
    auditwheel repair ${whl} --lib-sdir . -w /work/dist/
    rm ${whl}
done

# Install packages and test
for PYBIN in "${PYBINARIES[@]}"; do
    #${PYBIN}/pip install numpy
    ${PYBIN}/pip install vtk --no-cache-dir --no-index -f /work/dist
    #(cd $HOME && ${PYBIN}/python -c 'from itk import ITKCommon;')
    #(cd $HOME && ${PYBIN}/python -c 'import itk; image = itk.Image[itk.UC, 2].New()')
    #(cd $HOME && ${PYBIN}/python -c 'import itkConfig; itkConfig.LazyLoading = False; import itk;')
done
