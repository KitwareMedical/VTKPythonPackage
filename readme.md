# Firedrake's fork of VTKPythonPackage

VTK used to have a separate repository for building Python wheels, this is now integrated into the main project.
This repository is maintained to provide VTK wheels for the Firedrake project for Python versions or systems where wheels are not available on PyPI.

This is a fairly minimal build of VTK that does not have dependencies on X or OpenGL, suitable for use on platforms where these libraries may not be available.

The script `build_vtk_wheel.sh` serves mainly as a reference for the CMake options needed for such a build.
Wheels built with this script will be considered for a github release here, if the wheel is not available on [PyPI](https://pypi.org/project/vtk/).

For more information on VTK's Python wrapping, see [VTK Python Wrapping](https://vtk.org/doc/nightly/html/md__builds_gitlab_kitware_sciviz_ci_Documentation_Doxygen_PythonWrappers.html).
* Free software: BSD license
* VTK: [https://vtk.org]
* Documentation: [http://vtkpythonpackage.readthedocs.org]
* Original source code: [https://github.com/jcfr/VTKPythonPackage]
