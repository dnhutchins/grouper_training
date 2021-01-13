#!/bin/bash

export GROUPER_GTE_BRANCH=GROUPER_BUILD_CLOUD_FORMATION
#export GROUPER_GTE_DOCKER_BRANCH=GROUPER_BUILD_CLOUD_FORMATION
export GROUPER_GTE_DOCKER_BRANCH=202102

echo "$GROUPER_GTE_BRANCH" > /root/grouperGteBranch.txt
chmod a+r /root/grouperGteBranch.txt
echo "$GROUPER_GTE_DOCKER_BRANCH" > /root/grouperGteDockerBranch.txt
chmod a+r /root/grouperGteDockerBranch.txt

yum -y update
yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-devel wget mlocate emacs nano nslookup mlocate patch gawk

yum -y install docker

systemctl start docker

docker pull "tier/gte:401.4.end-$GROUPER_GTE_DOCKER_BRANCH"
docker pull "tier/gte:401.4.1-$GROUPER_GTE_DOCKER_BRANCH"
docker pull "tier/gte:401.3.end-$GROUPER_GTE_DOCKER_BRANCH"
docker pull "tier/gte:401.3.1-$GROUPER_GTE_DOCKER_BRANCH"
docker pull "tier/gte:401.2.end-$GROUPER_GTE_DOCKER_BRANCH"
docker pull "tier/gte:401.2.1-$GROUPER_GTE_DOCKER_BRANCH"
docker pull "tier/gte:401.1.end-$GROUPER_GTE_DOCKER_BRANCH"
docker pull "tier/gte:401.1.1-$GROUPER_GTE_DOCKER_BRANCH"
docker pull "tier/gte:301.4.1-$GROUPER_GTE_DOCKER_BRANCH"
docker pull "tier/gte:211.1.1-$GROUPER_GTE_DOCKER_BRANCH"
docker pull "tier/gte:201.5.end-$GROUPER_GTE_DOCKER_BRANCH"
docker pull "tier/gte:201.5.1-$GROUPER_GTE_DOCKER_BRANCH"
docker pull "tier/gte:201.4.end-$GROUPER_GTE_DOCKER_BRANCH"
docker pull "tier/gte:201.4.1-$GROUPER_GTE_DOCKER_BRANCH"
docker pull "tier/gte:201.3.end-$GROUPER_GTE_DOCKER_BRANCH"
docker pull "tier/gte:201.3.1-$GROUPER_GTE_DOCKER_BRANCH"
docker pull "tier/gte:201.2.end-$GROUPER_GTE_DOCKER_BRANCH"
docker pull "tier/gte:201.2.1-$GROUPER_GTE_DOCKER_BRANCH"
docker pull "tier/gte:201.1.end-$GROUPER_GTE_DOCKER_BRANCH"
docker pull "tier/gte:201.1.1-$GROUPER_GTE_DOCKER_BRANCH"
docker pull "tier/gte:101.1.1-$GROUPER_GTE_DOCKER_BRANCH"
docker pull "tier/gte:full_demo-$GROUPER_GTE_DOCKER_BRANCH"
docker pull "tier/gte:base-$GROUPER_GTE_DOCKER_BRANCH"
docker pull rabbitmq:management


# Who am i?
MY_IP=$(curl icanhazip.com)

# Generate a password
PASS=$(od -An -N32 -i /dev/random | md5sum | cut -c1-8)
#ENCRYPTED_PASS=$(perl -e 'print crypt($ARGV[0], "password")' $PASS)

groupadd -g 1002 student

# Make the student account
#useradd -u 1002 -g 1002 -m -p $ENCRYPTED_PASS student

useradd -u 1002 -g 1002 -m student
echo "student:$PASS" | chpasswd

# Add the student account to docker group.
#usermod -aG docker student

# Student uses sudo to become root. 
usermod -G wheel,docker student

echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/99wheel

sed -i "s|PasswordAuthentication no|PasswordAuthentication yes|g" /etc/ssh/sshd_config

systemctl restart sshd.service

cd /home/student/

echo >> /home/student/.bashrc
echo 'export PATH=/home/student:$PATH' >> /home/student/.bashrc
echo >> /home/student/.bashrc

wget "https://github.internet2.edu/docker/grouper_training/raw/$GROUPER_GTE_BRANCH/gte"
wget "https://github.internet2.edu/docker/grouper_training/raw/$GROUPER_GTE_BRANCH/gte-gsh"
wget "https://github.internet2.edu/docker/grouper_training/raw/$GROUPER_GTE_BRANCH/gte-logs"
wget "https://github.internet2.edu/docker/grouper_training/raw/$GROUPER_GTE_BRANCH/gte-shell"
wget "https://github.internet2.edu/docker/grouper_training/raw/$GROUPER_GTE_BRANCH/start-rabbitmq.sh"
wget "https://github.internet2.edu/docker/grouper_training/raw/$GROUPER_GTE_BRANCH/README.md"

chown student.student /home/student/*

chmod +x /home/student/gte
chmod +x /home/student/gte-gsh
chmod +x /home/student/gte-logs
chmod +x /home/student/gte-shell
chmod +x /home/student/start-rabbitmq.sh


updatedb

# Echo the IP and password with no whitespace so it doesnt wrap
echo "abcdefg12345678,$MY_IP,$PASS,"

