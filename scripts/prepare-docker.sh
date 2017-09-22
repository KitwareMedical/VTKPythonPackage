mkdir -p $HOME/.ccache

if [ $TARGET_ARCH = "x86" ]; then
   DOCKER_IMAGE=quay.io/pypa/manylinux1_i686
else
   DOCKER_IMAGE=quay.io/pypa/manylinux1_x86_64
fi

docker pull $DOCKER_IMAGE
docker run --rm -v ${HOME}/.ccache:/ccache -v `pwd`:/io $DOCKER_IMAGE -e TARGET_ARCH=$TARGET_ARCH /io/scripts/prepare-linux.sh
