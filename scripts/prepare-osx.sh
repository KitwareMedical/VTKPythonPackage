set -e -x

brew install gcc ccache
brew upgrade pyenv

# Due to arrogance on the part of @yyuu, we need to use some bash here (pyenv/pyenv#602)
ALLOWED_VERSIONS="$TRAVIS_PYTHON_VERSION.[0-9]"
CANDIDATE_VERSIONS="$(pyenv install -l | grep -Eio $ALLOWED_VERSIONS)"
SELECTED_VERSION="$(echo ${CANDIDATE_VERSIONS} | tr " " "\n" | grep -v - | tail -1)"
echo $SELECTED_VERSION

pyenv install $SELECTED_VERSION
pyenv global $SELECTED_VERSION

export PATH=/usr/local/opt/ccache/libexec:$PATH
which ccache
which gcc

export USE_CCACHE=1
export CCACHE_MAXSIZE=200M
export CCACHE_CPP2=1

source scripts/build.sh
