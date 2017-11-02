from __future__ import print_function

import os
import shlex
import sys

try:
    from skbuild import setup
except ImportError:
    print('scikit-build is required to build from source.', file=sys.stderr)
    print('Please run:', file=sys.stderr)
    print('', file=sys.stderr)
    print('  python -m pip install scikit-build')
    sys.exit(1)

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from vtkVersion import get_versions

setup(
    name='vtk',
    version=get_versions()['package-version'],
    author='VTK Community',
    author_email='vtk-developers@vtk.org',
    packages=['vtk'],
    package_dir={'vtk': 'vtk'},
    cmake_args=shlex.split(os.environ.get('VTK_CMAKE_ARGS', '')),
    py_modules=[
        'vtkVersion',
    ],
    download_url='http://www.vtk.org/download/',
    description='VTK is an open-source toolkit for 3D computer graphics, image processing, and visualization',
    long_description='VTK is an open-source, cross-platform library that provides developers with '
                     'an extensive suite of software tools for 3D computer graphics, image processing,'
                     'and visualization. It consists of a C++ class library and several interpreted interface '
                     'layers including Tcl/Tk, Java, and Python. VTK supports a wide variety of visualization '
                     'algorithms including scalar, vector, tensor, texture, and volumetric methods, as well as '
                     'advanced modeling techniques such as implicit modeling, polygon reduction, mesh '
                     'smoothing, cutting, contouring, and Delaunay triangulation. VTK has an extensive '
                     'information visualization framework and a suite of 3D interaction widgets. The toolkit '
                     'supports parallel processing and integrates with various databases on GUI toolkits such '
                     'as Qt and Tk.',
    classifiers=[
        "License :: OSI Approved :: BSD License",
        "Programming Language :: Python",
        "Programming Language :: C++",
        "Development Status :: 4 - Beta",
        "Intended Audience :: Developers",
        "Intended Audience :: Education",
        "Intended Audience :: Healthcare Industry",
        "Intended Audience :: Science/Research",
        "Topic :: Scientific/Engineering",
        "Topic :: Scientific/Engineering :: Medical Science Apps.",
        "Topic :: Scientific/Engineering :: Information Analysis",
        "Topic :: Software Development :: Libraries",
        "Operating System :: Android",
        "Operating System :: Microsoft :: Windows",
        "Operating System :: POSIX",
        "Operating System :: Unix",
        "Operating System :: MacOS"
        ],
    license='BSD',
    keywords='VTK visualization imaging',
    url=r'https://vtk.org/',
    install_requires=[
    ]
    )
