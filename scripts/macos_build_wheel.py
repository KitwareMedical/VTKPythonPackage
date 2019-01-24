import glob
import os
import shutil
from subprocess import check_call
import sys
from distutils import sysconfig

SCRIPT_DIR = os.path.abspath(os.path.dirname(__file__))
ROOT_DIR = os.path.abspath(os.path.join(SCRIPT_DIR, ".."))
STANDALONE_DIR = os.path.join(ROOT_DIR, "standalone-build")
PROJECT_NAME = "VTK"


def get_dummy_python_lib():
    """Since the python interpreter exports its symbol (see [1]), python modules
    should not link against any python libraries. To ensure it is not the case,
    we configure the project using an empty file as python library.

    [1] "Note that libpythonX.Y.so.1 is not on the list of libraries that a
    manylinux1 extension is allowed to link to. Explicitly linking to
    libpythonX.Y.so.1 is unnecessary in almost all cases: the way ELF linking
    works, extension modules that are loaded into the interpreter automatically
    get access to all of the interpreter's symbols, regardless of whether or
    not the extension itself is explicitly linked against libpython. [...]"

    Source: https://www.python.org/dev/peps/pep-0513/#libpythonx-y-so-1

    """
    py_lib = os.path.join(
        SCRIPT_DIR, 'internal',
        'libpython-not-needed-symbols-exported-by-interpreter'
    )

    if not os.path.exists(py_lib):
        with open(py_lib, 'w') as fp:
            fp.write('')
    return py_lib


def get_python_info():
    py_exe = sys.executable
    version = sys.version_info[:2]
    py_ver = '{0}.{1}'.format(*version)
    prefix = os.path.abspath(sys.prefix)
    py_inc_dir = sysconfig.get_python_inc()
    py_lib = get_dummy_python_lib()
    return py_exe, py_ver, py_inc_dir, py_lib


def build_wheel(cleanup=False):
    py_exe, py_ver, py_inc_dir, py_lib = get_python_info()
    build_type = 'Release'
    osx_target="10.9"

    # Clean up previous invocations
    if cleanup and os.path.exists(build_path):
        shutil.rmtree(build_path)

    print("#")
    print("# Build single %s wheel" % PROJECT_NAME)
    print("#")

    # Generate wheel
    check_call([
        py_exe,
        "setup.py", "bdist_wheel",
        "--build-type", build_type,
        "-G", "Ninja",
        "--plat-name", "macosx-" + osx_target + "-x86_64",
        "--",
        "-DPYTHON_EXECUTABLE:FILEPATH=%s" % py_exe,
        "-DPYTHON_INCLUDE_DIR:PATH=%s" % py_inc_dir,
        "-DPYTHON_LIBRARY:FILEPATH=%s" % py_lib
    ])

    # Cleanup
    check_call([py_exe, "setup.py", "clean"])


def main():
    build_wheel()


if __name__ == '__main__':
    main()
