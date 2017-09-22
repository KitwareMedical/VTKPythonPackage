brew install gcc ccache python3

# Activate the virtualenv
python3 -m venv venv
source venv/bin/activate

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
export CFLAGS="-arch x86_64"
export CXXFLAGS="-arch x86_64"

source scripts/build.sh
