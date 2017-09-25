brew install ccache
if [ $TRAVIS_PYTHON_VERSION != '2.7' ]; then
    brew tap zoidbergwill/python
    brew install python${PYTHON_TAG}

    python${TRAVIS_PYTHON_VERSION} -m venv venv
    source venv/bin/activate
fi

export PATH=/usr/local/opt/ccache/libexec:$PATH
which clang

export CC=clang
export CXX=clang++

export USE_CCACHE=1
export CCACHE_MAXSIZE=200M
export CCACHE_CPP2=1

source scripts/build.sh
