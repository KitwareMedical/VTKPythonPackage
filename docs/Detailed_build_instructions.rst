===========================
Detailed build instructions
===========================

Building VTK Python wheels
--------------------------

Build the VTK Python wheel with the following command::

	mkvirtualenv build-vtk
	pip install -r requirements-dev.txt
	python setup.py bdist_wheel

Efficiently building wheels for different version of python
-----------------------------------------------------------

If on a given platform you would like to build wheels for different version of python, you can download and build
the VTK components independent from python first and reuse them when building each wheel.

Here are the steps:

- Build VTKPythonPackage with VTKPythonPackage_BUILD_PYTHON set to OFF.

- Build "flavor" of package using::

	python setup.py bdist_wheel -- \
	  -DVTK_SOURCE_DIR:PATH=/path/to/VTKPythonPackage-core-build/VTK-source
