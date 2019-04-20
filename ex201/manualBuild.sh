source ../buildVersion.sh
echo "Building gte:201 version ${VERSION_TAG}"
docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:201.1.1-${VERSION_TAG} ex201.1.1 \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:201.1.end-${VERSION_TAG} ex201.1.end \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:201.2.1-${VERSION_TAG} ex201.2.1 \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:201.2.end-${VERSION_TAG} ex201.2.end \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:201.3.1-${VERSION_TAG} ex201.3.1 \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:201.3.end-${VERSION_TAG} ex201.3.end \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:201.4.1-${VERSION_TAG} ex201.4.1 \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:201.4.end-${VERSION_TAG} ex201.4.end \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:201.5.1-${VERSION_TAG} ex201.5.1 \
&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:201.5.end-${VERSION_TAG} ex201.5.end

if [[ "$OSTYPE" == "darwin"* ]]; then
  say exercises for 201 build complete
fi
