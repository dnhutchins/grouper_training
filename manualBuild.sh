docker build --tag=tier/grouper-training-env:base base/ \
&& docker build --tag=tier/grouper-training-env:ex1 exercise1 \
&& docker build --tag=tier/grouper-training-env:ex2 exercise2 \
&& docker build --tag=tier/grouper-training-env:full_demo full-demo

if [[ "$OSTYPE" == "darwin"* ]]; then
  say build complete
fi
