source ../buildVersion.sh
echo "Building gte:301 version ${VERSION_TAG}"
docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:301.4.1-${VERSION_TAG} ex301.4.1

if [[ "$OSTYPE" == "darwin"* ]]; then
  say exercises for 301 build complete
fi
