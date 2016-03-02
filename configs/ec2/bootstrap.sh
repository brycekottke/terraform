#!/bin/bash

# Check if user exists. If not, create user
cat /etc/passwd |grep datapipe

if [ $? -eq 1 ]; then
  useradd -d /home/datapipe -m -s /bin/bash datapipe
else
  echo "User 'datapipe' already exists, exiting..."
  exit 0
fi

# create .ssh directory
mkdir /home/datapipe/.ssh

