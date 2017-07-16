
import glob
import os
import shutil
import sys

from subprocess import check_call


SCRIPT_DIR = os.path.dirname(__file__)
ROOT_DIR = os.path.abspath(os.path.join(SCRIPT_DIR, ".."))
STANDALONE_DIR = os.path.join(ROOT_DIR, "standalone-build")
PROJECT_NAME = "VTK"

print("SCRIPT_DIR: %s" % SCRIPT_DIR)
print("ROOT_DIR: %s" % ROOT_DIR)
print("STANDALONE_DIR: %s" % STANDALONE_DIR)

sys.path.insert(0, os.path.join(SCRIPT_DIR, "internal"))
from wheel_builder_utils import push_dir, push_env
from windows_build_common import DEFAULT_PY_ENVS, venv_paths


def pip_install(python_dir, package, upgrade=True):
    pip = os.path.join(python_dir, "Scripts", "pip.exe")
    print("Installing %s using %s" % (package, pip))
    args = [pip, "install"]
    if upgrade:
        args.append("--upgrade")
    args.append(package)
    check_call(args)


def prepare_build_env(python_version):
    python_dir = "C:/Python%s" % python_version
    if not os.path.exists(python_dir):
        raise FileNotFoundError(
            "Aborting. python_dir [%s] does not exist." % python_dir)

    venv = os.path.join(python_dir, "Scripts", "virtualenv.exe")
    venv_dir = os.path.join(ROOT_DIR, "venv-%s" % python_version)
    print("Creating python virtual environment: %s" % venv_dir)
    if not os.path.exists(venv_dir):
        check_call([venv, venv_dir])
    pip_install(venv_dir, "scikit-build")


def build_wheel(python_version, single_wheel=False,
                cleanup=False, wheel_names=None):

    python_executable, \
            python_include_dir, \
            python_library, \
            pip, \
            ninja_executable, \
            path = venv_paths(python_version)

    with push_env(PATH="%s%s%s" % (path, os.pathsep, os.environ["PATH"])):

        # Install dependencies
        check_call([pip, "install", "--upgrade",
                    "-r", os.path.join(ROOT_DIR, "requirements-dev.txt")])

        build_type = "Release"
        source_path = "%s/%s-source" % (STANDALONE_DIR, PROJECT_NAME)
        build_path = "%s/%s-win_%s" % (ROOT_DIR, PROJECT_NAME, python_version)
        setup_py_configure = os.path.join(SCRIPT_DIR, "setup_py_configure.py")

        # Clean up previous invocations
        if cleanup and os.path.exists(build_path):
            shutil.rmtree(build_path)

        assert single_wheel is True

        print("#")
        print("# Build single %s wheel" % PROJECT_NAME)
        print("#")

        # Configure setup.py
        check_call([python_executable, setup_py_configure, "itk"])

        # Generate wheel
        check_call([
            python_executable,
            "setup.py", "bdist_wheel",
            "--build-type", build_type, "-G", "Ninja",
            "--",
            "-DCMAKE_MAKE_PROGRAM:FILEPATH=%s" % ninja_executable,
            "-DVTK_SOURCE_DIR:PATH=%s" % source_path,
            "-DVTK_BINARY_DIR:PATH=%s" % build_path,
            "-DPYTHON_EXECUTABLE:FILEPATH=%s" % python_executable,
            "-DPYTHON_INCLUDE_DIR:PATH=%s" % python_include_dir,
            "-DPYTHON_LIBRARY:FILEPATH=%s" % python_library
        ])
        # Cleanup
        check_call([python_executable, "setup.py", "clean"])

        # Remove unnecessary files for building against PROJECT_NAME
        if cleanup:
            for root, _, file_list in os.walk(build_path):
                for filename in file_list:
                    extension = os.path.splitext(filename)[1]
                    if extension in [".cpp", ".obj", ".o"]:
                        os.remove(os.path.join(root, filename))


def fixup_wheel(filepath):
    pass


def fixup_wheels():
    for wheel in glob.glob(os.path.join(ROOT_DIR, "dist", "*.whl")):
        fixup_wheel(wheel)


def test_wheels(single_wheel=False):
    pass


def build_wheels(py_envs=DEFAULT_PY_ENVS, single_wheel=False,
                 cleanup=False, wheel_names=None):

    prepare_build_env("27-x64")
    prepare_build_env("35-x64")
    prepare_build_env("36-x64")

    with push_dir(directory=STANDALONE_DIR, make_directory=True):

        cmake_executable = "cmake.exe"
        tools_venv = os.path.join(ROOT_DIR, "venv-27-x64")
        pip_install(tools_venv, "ninja")
        ninja_executable = os.path.join(tools_venv, "Scripts", "ninja.exe")

        # Build standalone project and populate archive cache
        check_call([
            cmake_executable,
            "-DVTKPythonPackage_BUILD_PYTHON:PATH=0",
            "-G", "Ninja",
            "-DCMAKE_MAKE_PROGRAM:FILEPATH=%s" % ninja_executable,
            ROOT_DIR
        ])

        check_call([ninja_executable])

    # Compile wheels re-using standalone project and archive cache
    for py_env in py_envs:
        build_wheel(
            py_env, single_wheel=single_wheel,
            cleanup=cleanup, wheel_names=wheel_names)


def main(py_envs=DEFAULT_PY_ENVS, wheel_names=None, cleanup=True):
    single_wheel = False

    build_wheels(
        single_wheel=single_wheel, cleanup=cleanup,
        py_envs=py_envs, wheel_names=wheel_names)
    fixup_wheels()
    test_wheels(single_wheel=single_wheel)


if __name__ == "__main__":
    main()
