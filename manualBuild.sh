docker build --tag=tier/grouper_training_base:latest base/ \
&& docker build --tag=tier/grouper_training_ex1:latest exercise1 \
&& docker build --tag=tier/grouper_training_ex2:latest exercise2 \
&& docker build --tag=tier/grouper_training_full_demo:latest full-demo

if [[ "$OSTYPE" == "darwin"* ]]; then
  say build complete
fi
