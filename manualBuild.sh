docker build --pull --tag=tier/gte:base-201906 base/ \
&& docker build --tag=tier/gte:full_demo-201906 full-demo \

pushd ex101
./manualBuild.sh
popd

pushd ex201
./manualBuild.sh
popd

pushd ex211
./manualBuild.sh
popd

pushd ex301
./manualBuild.sh
popd

pushd ex401
./manualBuild.sh
popd


if [[ "$OSTYPE" == "darwin"* ]]; then
  say full build complete
fi
