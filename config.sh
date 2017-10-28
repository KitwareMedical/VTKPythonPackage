function pre_build {
  if [ -n "$IS_OSX" ]; then
      :
  else
      yum install -y libXt-devel
  fi
  pip install command-timeout $BUILD_DEPENDS
}

function build_wheel {
    build_bdist_wheel $@
}

function bdist_wheel_cmd {
    # Builds wheel with bdist_wheel, puts into wheelhouse
    #
    # It may sometimes be useful to use bdist_wheel for the wheel building
    # process.  For example, versioneer has problems with versions which are
    # fixed with bdist_wheel:
    # https://github.com/warner/python-versioneer/issues/121
    local abs_wheelhouse=$1
    command-timeout 2400 python setup.py bdist_wheel 1>&2
    cp dist/*.whl $abs_wheelhouse
}
