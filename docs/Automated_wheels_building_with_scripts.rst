======================================
Automated wheels building with scripts
======================================

Steps required to build wheels on Linux, MacOSX and Windows have been automated. The following sections outline how to use the associated scripts.

Linux
-----

On any linux distribution with docker and bash installed, running the script dockcross-manylinux-build-wheels.sh will create 64-bit wheels for both python 2.x and python 3.x in the dist directory.

For example::

	$ git clone https://github.com/KitwareMedical/VTKPythonPackage.git
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

Download and install python from https://www.python.org/downloads/mac-osx/.
Run macos_build_wheels.py to create wheels for python 3.5, 3.6 and 3.7 in the dist directory.

For example::

	$ git clone https://github.com/KitwareMedical/VTKPythonPackage.git

	$ python ./scripts/macos_build_wheels.py.

	$ ls -1 dist/
	vtk-8.0.0.dev20170714-cp34-cp34m-macosx_10_9_x86_64.whl
	vtk-8.0.0.dev20170714-cp35-cp35m-macosx_10_9_x86_64.whl
	vtk-8.0.0.dev20170714-cp36-cp36m-macosx_10_9_x86_64.whl

Windows
-------

First, install Microsoft Visual C++ Compiler for Python 2.7, Visual Studio 2015, Git, and CMake, which should be added to the system PATH environmental variable.

Open a PowerShell terminal as Administrator, and install Python::

	PS C:\> Set-ExecutionPolicy Unrestricted
	PS C:\> iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/scikit-build/scikit-ci-addons/master/windows/install-python.ps1'))

In a PowerShell prompt::

	PS C:\Windows> cd C:\
	PS C:\> git clone https://github.com/KitwareMedical/VTKPythonPackage.git VPP
	PS C:\> cd VPP
	PS C:\VPP> C:\Python27-x64\python.exe .\scripts\windows_build_wheels.py
	[...]

	PS C:\VPP> ls dist
	    Directory: C:\VPP\dist


	    Mode                LastWriteTime         Length Name
	    ----                -------------         ------ ----
	    -a----        7/16/2017   5:21 PM       ???????? vtk-8.0.0.dev20170714-cp27-cp27m-win_amd64.whl
	    -a----        7/16/2017  11:14 PM       ???????? vtk-8.0.0.dev20170714-cp35-cp35m-win_amd64.whl
	    -a----        7/16/2017   2:08 AM       ???????? vtk-8.0.0.dev20170714-cp36-cp36m-win_amd64.whl

We need to work in a short directory to avoid path length limitations on Windows, so the repository is cloned into C:\VPP. Also, it is very important to disable antivirus checking on the C:\VPP directory. Otherwise, the build system conflicts with the antivirus when many files are created and deleted quickly, which can result in Access Denied errors. Windows 10 ships with an antivirus application, Windows Defender, that is enabled by default.


sdist
-----

To create source distributions, sdist's, that will be used by pip to compile a wheel for installation if a binary wheel is not available for the current Python version or platform::

	$ python setup.py sdist --formats=gztar,zip
	[...]

	$ ls -1 dist/
	vtk-8.0.0.dev20170714.tar.gz
	vtk-8.0.0.dev20170714.zip
