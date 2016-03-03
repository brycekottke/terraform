#!/bin/bash

# Check if user exists. If not, create user
cat /etc/passwd |grep datapipe

if [ $? -eq 1 ]; then
  useradd -d /home/datapipe -m -s /bin/bash datapipe
else
  echo "User 'datapipe' already exists."
  exit 0
fi

# create .ssh directory
ls -la /home/datapipe |grep .ssh

if [ $? -eq 1 ]; then
  mkdir /home/datapipe/.ssh
else
  echo "Directory '.ssh' already exists."
  exit 0
fi

# add key to authorized_keys file
ls -la /home/datapipe/.ssh/ |grep authorized_keys

if [ $? -eq 1 ]; then
  touch /home/datapipe/.ssh/authorized_keys
else
  echo "authorized_keys file already exists."
  exit 0
fi

echo ${var.pub_key} >> /home/datapipe/.ssh/authorized_keys
echo ${var.pub_key} >> /tmp/test01.txt

