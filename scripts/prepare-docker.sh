DOCKER_IMAGE=quay.io/pypa/manylinux1_x86_64
docker pull $DOCKER_IMAGE
ln -s $PWD/.ccache $HOME/.ccache
docker run --rm -v `pwd`:/io $DOCKER_IMAGE $PRE_CMD /io/scripts/prepare-linux.sh