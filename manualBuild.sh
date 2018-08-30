docker build --pull --tag=tier/grouper-training-env:base base/ \
&& docker build --tag=tier/grouper-training-env:full_demo full-demo \
&& docker build --tag=tier/grouper-training-env:ex401.1.1 ex401/ex401.1.1 \
&& docker build --tag=tier/grouper-training-env:ex401.1.2 ex401/ex401.1.2 \
&& docker build --tag=tier/grouper-training-env:ex401.1.3 ex401/ex401.1.3 \
&& docker build --tag=tier/grouper-training-env:ex401.1.4 ex401/ex401.1.4 \
&& docker build --tag=tier/grouper-training-env:ex401.1.5 ex401/ex401.1.5 \
&& docker build --tag=tier/grouper-training-env:ex401.1.6 ex401/ex401.1.6 \
&& docker build --tag=tier/grouper-training-env:ex401.1.end ex401/ex401.1.end \
&& docker build --tag=tier/grouper-training-env:ex401.2.1 ex401/ex401.2.1 \
&& docker build --tag=tier/grouper-training-env:ex401.2.2 ex401/ex401.2.2 \
&& docker build --tag=tier/grouper-training-env:ex401.2.3 ex401/ex401.2.3 \
&& docker build --tag=tier/grouper-training-env:ex401.2.4 ex401/ex401.2.4 \
&& docker build --tag=tier/grouper-training-env:ex401.2.5 ex401/ex401.2.5 \
&& docker build --tag=tier/grouper-training-env:ex401.2.6 ex401/ex401.2.6 \
&& docker build --tag=tier/grouper-training-env:ex401.2.7 ex401/ex401.2.7 \
&& docker build --tag=tier/grouper-training-env:ex401.2.8 ex401/ex401.2.8 \
&& docker build --tag=tier/grouper-training-env:ex401.2.9 ex401/ex401.2.9 \
&& docker build --tag=tier/grouper-training-env:ex401.2.end ex401/ex401.2.end 

if [[ "$OSTYPE" == "darwin"* ]]; then
  say build complete
fi
