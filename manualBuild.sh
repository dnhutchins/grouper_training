docker build --tag=tier/grouper_training_env:base base/ \
&& docker build --tag=tier/grouper_training_env:ex1 exercise1 \
&& docker build --tag=tier/grouper_training_env:ex2 exercise2 \
&& docker build --tag=tier/grouper_training_env:full_demo full-demo

if [[ "$OSTYPE" == "darwin"* ]]; then
  say build complete
fi
