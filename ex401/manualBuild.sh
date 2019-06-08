source ../buildVersion.sh
echo "Building gte:401 version ${VERSION_TAG}"
docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.1.1-${VERSION_TAG} ex401.1.1 \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.1.end-${VERSION_TAG} ex401.1.end \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.2.1-${VERSION_TAG} ex401.2.1 \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.2.end-${VERSION_TAG} ex401.2.end \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.3.1-${VERSION_TAG} ex401.3.1 \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.3.end-${VERSION_TAG} ex401.3.end \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.4.1-${VERSION_TAG} ex401.4.1 \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.4.end-${VERSION_TAG} ex401.4.end

if [[ "$OSTYPE" == "darwin"* ]]; then
  say exercises for 401 build complete
fi
