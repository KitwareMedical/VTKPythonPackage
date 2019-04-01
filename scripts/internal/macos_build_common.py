__all__ = ['DEFAULT_PY_ENVS', 'venv_paths']

from subprocess import check_call
import os

DEFAULT_PY_ENVS = ["3.5", "3.6", "3.7"]

SCRIPT_DIR = os.path.dirname(__file__)
ROOT_DIR = os.path.abspath(os.path.join(SCRIPT_DIR, "..", ".."))


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
    py_lib = os.path.join(SCRIPT_DIR, 'libpython-not-needed-symbols-exported-by-interpreter')

    if not os.path.exists(py_lib):
        with open(py_lib, 'w') as fp:
            fp.write('')
    return py_lib


def venv_paths(python_version):

    # Create venv
    venv_executable = "/Library/Frameworks/Python.framework/Versions/%s/bin/pyvenv" % (python_version)
    venv_dir = os.path.join(ROOT_DIR, "venv-%s" % python_version)
    check_call([venv_executable, venv_dir])

    python_executable = os.path.join(venv_dir, "bin", "python")
    python_include_dir = "/Library/Frameworks/Python.framework/Versions/%s/include/python%sm" % (python_version, python_version)

    python_library = get_dummy_python_lib()

    print("")
    print("PYTHON_EXECUTABLE: %s" % python_executable)
    print("PYTHON_INCLUDE_DIR: %s" % python_include_dir)
    print("PYTHON_LIBRARY: %s" % python_library)

    pip = os.path.join(venv_dir, "bin", "pip")

    ninja_executable = os.path.join(
        ROOT_DIR, "venv-%s" % DEFAULT_PY_ENVS[0], "bin", "ninja")
    print("NINJA_EXECUTABLE: %s" % ninja_executable)

    # Update PATH
    path = os.path.join(venv_dir, "bin")

    return python_executable, \
        python_include_dir, \
        python_library, \
        pip, \
        ninja_executable, \
        path
