docker build --tag=tier/grouper_training_base:latest base/ \
&& docker build --tag=tier/grouper_training_lesson1:latest lesson1 \
&& docker build --tag=tier/grouper_training_lesson2:latest lesson2

if [[ "$OSTYPE" == "darwin"* ]]; then
  say build complete
fi
