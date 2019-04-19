docker build --tag=tier/gte:101-$tag ex101-$tag

if [[ "$OSTYPE" == "darwin"* ]]; then
  say exercises for 101 build complete
fi
