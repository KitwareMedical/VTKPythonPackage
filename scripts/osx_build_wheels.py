import glob
import os
import shutil
from subprocess import check_call
import sys

SCRIPT_DIR = os.path.dirname(__file__)
ROOT_DIR = os.path.abspath(os.path.join(SCRIPT_DIR, ".."))
STANDALONE_DIR = os.path.join(ROOT_DIR, "standalone-build")
PROJECT_NAME = "VTK"


def get_python_info():
    py_exe = sys.executable
    version = sys.version_info[:2]
    py_ver = '{0}.{1}'.format(*version)
    prefix = os.path.abspath(sys.prefix)
    py_inc_dir = glob.glob(os.path.join(prefix, 'include', 'python*'))[0]
    py_lib_dir = os.path.join(prefix, 'lib')
    py_lib = os.path.join(py_lib_dir, 'libpython%s.dylib' % py_ver)
    return py_exe, py_ver, py_inc_dir, py_lib


def build_wheel(cleanup=False):
    py_exe, py_ver, py_inc_dir, py_lib = get_python_info()
    build_type = 'Release'
    source_path = "%s/%s-source" % (STANDALONE_DIR, PROJECT_NAME)
    build_path = "%s/%s-osx_%s" % (ROOT_DIR, PROJECT_NAME, py_ver)

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
        "--",
        "-DVTK_SOURCE_DIR:PATH=%s" % source_path,
        "-DVTK_BINARY_DIR:PATH=%s" % build_path,
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
