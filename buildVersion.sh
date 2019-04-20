# This script is sourced from each of the manualBuild.sh scripts.
# The git branch indicates the GTE version and is appended to each docker image tag
# e.g. tier/gte:101.1.1-201906 where 201906 is the git branch
export VERSION_TAG=`git status --porcelain=2 -b | grep branch.head | cut -d ' ' -f 3`

# The Grouper version used to build the entire GTE is configured in ./base/Dockerfile#4
# e.g. FROM tier/grouper:latest
