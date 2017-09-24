brew install gcc ccache
brew tap zoidbergwill/python
brew install python${PYTHON_TAG}

python${PYTHON_TAG} -m venv venv
source venv/bin/activate

export PATH=/usr/local/opt/ccache/libexec:$PATH
which ccache
which gcc

export USE_CCACHE=1
export CCACHE_MAXSIZE=200M
export CCACHE_CPP2=1

source scripts/build.sh
