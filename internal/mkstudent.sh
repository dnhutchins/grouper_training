#!/bin/bash

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
usermod -aG docker student

# Student uses sudo to become root. 
#usermod -aG wheel student

# Echo the password
echo "$MY_IP, student, $PASS"
