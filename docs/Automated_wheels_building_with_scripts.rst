======================================
Automated wheels building with scripts
======================================

Steps required to build wheels on Linux, MacOSX and Windows have been automated. The following sections outline how to use the associated scripts.

Linux
-----

On any linux distribution with docker and bash installed, running the script dockcross-manylinux-build-wheels.sh will create 64-bit wheels for both python 2.x and python 3.x in the dist directory.

For example::

	$ git clone https://github.com/jcfr/VTKPythonPackage.git
	[...]

	$ ./scripts/dockcross-manylinux-build-wheels.sh
	[...]

	$ ls -1 dist/
	vtk-8.0.0.dev20170714-cp27-cp27m-manylinux1_x86_64.whl
	vtk-8.0.0.dev20170714-cp27-cp27mu-manylinux1_x86_64.whl
	vtk-8.0.0.dev20170714-cp34-cp34m-manylinux1_x86_64.whl
	vtk-8.0.0.dev20170714-cp35-cp35m-manylinux1_x86_64.whl
	vtk-8.0.0.dev20170714-cp36-cp36m-manylinux1_x86_64.whl

MacOSX
------

.. note:: *Not yet available.*

Windows
-------

.. note:: *Not yet available.*

sdist
-----

To create source distributions, sdist's, that will be used by pip to compile a wheel for installation if a binary wheel is not available for the current Python version or platform::

	$ python setup.py sdist --formats=gztar,zip
	[...]

	$ ls -1 dist/
	vtk-8.0.0.dev20170714.tar.gz
	vtk-8.0.0.dev20170714.zip
