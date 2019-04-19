docker build --tag=tier/gte:ex201.1.1-$tag ex201.1.1-$tag \
&& docker build --tag=tier/grouper-training-env:ex201.1.end ex201.1.end \
&& docker build --tag=tier/grouper-training-env:ex201.2.1 ex201.2.1 \
&& docker build --tag=tier/grouper-training-env:ex201.2.end ex201.2.end \
&& docker build --tag=tier/grouper-training-env:ex201.3.1 ex201.3.1 \
&& docker build --tag=tier/grouper-training-env:ex201.3.end ex201.3.end \
&& docker build --tag=tier/grouper-training-env:ex201.4.1 ex201.4.1 \
&& docker build --tag=tier/grouper-training-env:ex201.4.end ex201.4.end \
&& docker build --tag=tier/grouper-training-env:ex201.5.1 ex201.5.1 \
&& docker build --tag=tier/grouper-training-env:ex201.5.end ex201.5.end

if [[ "$OSTYPE" == "darwin"* ]]; then
  say exercises for 201 build complete
fi
