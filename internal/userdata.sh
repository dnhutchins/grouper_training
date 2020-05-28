#!/bin/bash
yum -y update
/root/mkstudent.sh
usermod -G wheel,docker student
docker pull rabbitmq:management
/home/student/start-rabbitmq.sh 
