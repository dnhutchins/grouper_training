source ./buildVersion.sh
echo "Building tier/gte version ${VERSION_TAG}"
docker build --pull --tag=tier/gte:base-${VERSION_TAG} base/ \
#&& docker build --build-arg VERSION_TAG=${VERSION_TAG} --tag=tier/gte:full_demo-${VERSION_TAG} full-demo \

pushd ex101
./manualBuild.sh
popd

pushd ex201
./manualBuild.sh
popd

# pushd ex211
# ./manualBuild.sh
# popd
#
# pushd ex301
# ./manualBuild.sh
# popd

pushd ex401
./manualBuild.sh
popd

if [[ "$OSTYPE" == "darwin"* ]]; then
  say full build complete
fi
