source ../buildVersion.sh
echo "Building gte:401 version ${VERSION_TAG}"
docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.1.1-${VERSION_TAG} ex401.1.1 \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.1.2-${VERSION_TAG} ex401.1.2 \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.1.3-${VERSION_TAG} ex401.1.3 \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.1.4-${VERSION_TAG} ex401.1.4 \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.1.5-${VERSION_TAG} ex401.1.5 \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.1.6-${VERSION_TAG} ex401.1.6 \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.1.end-${VERSION_TAG} ex401.1.end \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.2.1-${VERSION_TAG} ex401.2.1 \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.2.2-${VERSION_TAG} ex401.2.2 \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.2.3-${VERSION_TAG} ex401.2.3 \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.2.4-${VERSION_TAG} ex401.2.4 \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.2.5-${VERSION_TAG} ex401.2.5 \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.2.6-${VERSION_TAG} ex401.2.6 \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.2.7-${VERSION_TAG} ex401.2.7 \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.2.8-${VERSION_TAG} ex401.2.8 \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.2.9-${VERSION_TAG} ex401.2.9 \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.2.end-${VERSION_TAG} ex401.2.end \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.3.1-${VERSION_TAG} ex401.3.1 \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.3.2-${VERSION_TAG} ex401.3.2 \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.3.3-${VERSION_TAG} ex401.3.3 \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.3.4-${VERSION_TAG} ex401.3.4 \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.3.5-${VERSION_TAG} ex401.3.5 \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.3.6-${VERSION_TAG} ex401.3.6 \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.3.7-${VERSION_TAG} ex401.3.7 \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.3.end-${VERSION_TAG} ex401.3.end \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.4.1-${VERSION_TAG} ex401.4.1 \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:401.4.end-${VERSION_TAG} ex401.4.end

if [[ "$OSTYPE" == "darwin"* ]]; then
  say exercises for 401 build complete
fi
