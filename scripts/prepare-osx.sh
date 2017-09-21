set -e -x

# Due to arrogance on the part of @yyuu, we need to use some bash here (pyenv/pyenv#602)
ALLOWED_VERSIONS="$TRAVIS_PYTHON_VERSION.[0-9]"
CANDIDATE_VERSIONS="$(pyenv install -l | grep -Eio $ALLOWED_VERSIONS)"
SELECTED_VERSION="$(echo ${CANDIDATE_VERSIONS} | tr " " "\n" | grep -v - | tail -1)"
echo $SELECTED_VERSION

if [ $TARGET_ARCH == "x86" ]; then
  env PYTHON_CONFIGURE_OPTS="--enable-shared" CFLAGS="-m32" LDFLAGS="-m32" pyenv install $SELECTED_VERSION
else
  pyenv install $SELECTED_VERSION
fi
pyenv global $SELECTED_VERSION

brew install gcc ccache

export PATH=/usr/local/opt/ccache/libexec:$PATH
which ccache
which gcc

export USE_CCACHE=1
export CCACHE_MAXSIZE=200M
export CCACHE_CPP2=1

source scripts/build.sh
