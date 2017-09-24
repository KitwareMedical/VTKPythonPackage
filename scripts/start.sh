PYTHON_TAG=${TRAVIS_PYTHON_VERSION//[^[:digit:]]/}
if [[ $TRAVIS_OS_NAME == 'osx' ]]; then
    source scripts/prepare-osx.sh
else
    source scripts/prepare-docker.sh
fi
