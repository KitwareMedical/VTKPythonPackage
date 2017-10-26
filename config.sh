
function pre_build {
  export PYTHON_LIBRARY=$(cd $(dirname $0); pwd)/libpython-not-needed-symbols-exported-by-interpreter
  touch ${PYTHON_LIBRARY}
}
