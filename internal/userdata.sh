#!/bin/bash


yum -y install wget
cd /root
wget "https://github.internet2.edu/docker/grouper_training/raw/GROUPER_BUILD_CLOUD_FORMATION/internal/mkstudent.sh"
chmod +x mkstudent.sh
/root/mkstudent.sh
