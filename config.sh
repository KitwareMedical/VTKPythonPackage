function timeout {
  perl -e 'alarm shift; exec @ARGV' "$@"; 
}

function pre_build {
  if [ -n "$IS_OSX" ]; then
      :
  else
      yum install -y libXt-devel
  fi
  timeout 2400 python setup.py build
}
