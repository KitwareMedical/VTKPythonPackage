
function pre_build {
  if [ -n "$IS_OSX" ]; then
      :
  else
      yum install -y libXt-devel
  fi
  python setup.py build
}
