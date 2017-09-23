set -e -x

# Due to arrogance on the part of @yyuu, we need to use some bash here (pyenv/pyenv#602)
ALLOWED_VERSIONS="$TRAVIS_PYTHON_VERSION.[0-9]"
CANDIDATE_VERSIONS="$(echo ${PYTHON_VERSIONS} | grep -Eio $ALLOWED_VERSIONS)"
SELECTED_VERSION="$(echo ${CANDIDATE_VERSIONS} | tr " " "\n" | grep -v - | tail -1)"
echo $SELECTED_VERSION

pyenv install $SPECIFIC_VERSION
pyenv global $SPECIFIC_VERSION

brew install gcc ccache

# Try to activate the virtualenv
python -m venv venv || true
source venv/bin/activate || true

which ccache
ln -s ccache /usr/local/bin/gcc
ln -s ccache /usr/local/bin/g
ln -s ccache /usr/local/bin/cc
ln -s ccache /usr/local/bin/c
ln -s ccache /usr/local/bin/clang
ln -s ccache /usr/local/bin/clang

export USE_CCACHE=1
export CCACHE_MAXSIZE=200M
export CCACHE_CPP2=1

source scripts/build.sh
