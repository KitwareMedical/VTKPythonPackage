mkdir -p $HOME/.ccache
mkdir -p $HOME/.cache

if [ $TARGET_ARCH = "x86" ]; then
   DOCKER_IMAGE=quay.io/pypa/manylinux1_i686
else
   DOCKER_IMAGE=quay.io/pypa/manylinux1_x86_64
fi

docker pull $DOCKER_IMAGE
docker run --rm -v ${HOME}/.ccache:/ccache -v ${HOME}/.cache:/cache -v `pwd`:/io \
   -e TRAVIS_PYTHON_VERSION=$TRAVIS_PYTHON_VERSION \
   -e PYTHON_TAG=$PYTHON_TAG
   -e TARGET_ARCH=$TARGET_ARCH $DOCKER_IMAGE /io/scripts/prepare-linux.sh
