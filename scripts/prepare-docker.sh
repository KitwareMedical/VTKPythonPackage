mkdir -p $HOME/.ccache

if [ $TARGET_ARCH = "x86" ]; then
   DOCKER_IMAGE=quay.io/pypa/manylinux1_i686
else
   DOCKER_IMAGE=quay.io/pypa/manylinux1_x86_64
fi

docker pull $DOCKER_IMAGE
docker run --rm -v ${HOME}/.ccache:/ccache -v `pwd`:/io -e TRAVIS_PYTHON_VERSION=$TRAVIS_PYTHON_VERSION \
   -e TARGET_ARCH=$TARGET_ARCH $DOCKER_IMAGE /io/scripts/prepare-linux.sh
