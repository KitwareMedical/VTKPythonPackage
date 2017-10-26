function timeout() { 
  perl -e 'alarm shift; exec @ARGV' "$@"; 
}
function pre_build {
  timeout 2400 python setup.py build  
}
