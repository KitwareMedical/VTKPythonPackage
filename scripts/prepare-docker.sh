mkdir -p $HOME/.ccache

DOCKER_IMAGE=quay.io/pypa/manylinux1_x86_64
docker pull $DOCKER_IMAGE

docker run --rm -v ${HOME}/.ccache:/ccache -v `pwd`:/io $DOCKER_IMAGE $PRE_CMD /io/scripts/prepare-linux.sh
