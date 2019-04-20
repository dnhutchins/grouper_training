source ../buildVersion.sh
echo "Building gte:101 version ${VERSION_TAG}"
docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:101.1.1-${VERSION_TAG} ex101.1.1

if [[ "$OSTYPE" == "darwin"* ]]; then
  say exercises for 101 build complete
fi
