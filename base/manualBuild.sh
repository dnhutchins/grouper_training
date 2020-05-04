source ../buildVersion.sh
echo "Building tier/gte version ${VERSION_TAG}"
docker build --tag=tier/gte:base-${VERSION_TAG} .
