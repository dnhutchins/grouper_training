source ../buildVersion.sh
echo "Building gte:211 version ${VERSION_TAG}"
docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:211.1.1-${VERSION_TAG} ex211.1.1

if [[ "$OSTYPE" == "darwin"* ]]; then
  say exercises for 211 build complete
fi
