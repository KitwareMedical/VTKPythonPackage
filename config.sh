function timeout {
  perl -e 'alarm shift; exec @ARGV' "$@"; 
}

function pre_build {
  if [ -n "$IS_OSX" ]; then
      :
  else
      yum install -y libXt-devel
  fi
  pip install command-timeout $BUILD_DEPENDS
  command-timeout 2400 python setup.py build 1>&2
}
