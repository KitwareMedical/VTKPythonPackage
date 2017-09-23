set -e -x

& brew install gcc ccache

# Due to arrogance on the part of @yyuu, we need to use some bash here (pyenv/pyenv#602)
SPECIFIC_VERSION="$(pyenv install -l | grep -e '${TRAVIS_PYTHON_VERSION}.[0-9]' | grep -v - | tail -1)"
pyenv install $SPECIFIC_VERSION
pyenv global $SPECIFIC_VERSION

wait

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
