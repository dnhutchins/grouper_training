#!/bin/bash

export GROUPER_GTE_BRANCH=202006-post
#export GROUPER_GTE_DOCKER_BRANCH=$GROUPER_GTE_BRANCH
export GROUPER_GTE_DOCKER_BRANCH=202006

yum -y install wget
cd /root
wget "https://github.internet2.edu/docker/grouper_training/raw/$GROUPER_GTE_BRANCH/internal/mkstudent.sh"
chmod +x mkstudent.sh
/root/mkstudent.sh
