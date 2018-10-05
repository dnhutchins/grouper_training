docker build --pull --tag=tier/grouper-training-env:base base/ \
&& docker build --tag=tier/grouper-training-env:full_demo full-demo \

pushd ex201
./manualBuild.sh
popd

pushd ex401
./manualBuild.sh
popd


if [[ "$OSTYPE" == "darwin"* ]]; then
  say full build complete
fi
