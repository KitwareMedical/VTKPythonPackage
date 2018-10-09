# This script creates an archive of the VTK Python package build tree. It is
# downloaded by the external module build scripts and used to build their
# Python package on GitHub CI services.
#
# It is designed to be executed on the overload.kitware.com build system, and
# it requires 7-Zip to installed at C:\7-Zip. The VTKPythonPackage
# repository needs to be checked out at C:\P\VPP. It is invoked after running the
# scripts/windows_build_wheels.py script.


cd C:\P\
Remove-Item VPP\dist\*
C:\7-Zip\7z.exe a -r 'C:\P\VTKPythonBuilds-windows.zip' -w 'C:\P\VPP' -mem=AES256
