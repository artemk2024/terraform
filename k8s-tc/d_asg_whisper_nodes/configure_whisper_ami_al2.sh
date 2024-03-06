#!/bin/bash

###
# Yum installations must occur prior to updating Python to newer version
###

sudo yum update -y

sudo yum install -y vim
sudo yum install -y git

# Docker
# sudo yum install docker -y
# sudo systemctl start docker
# sudo docker run hello-world

cd /data
git clone https://github.com/jianfch/stable-ts.git

###
# Hard-code to test if this is an optimization worth proceeding with
###

# cri approach
aws ecr get-login-password --region ${AWS_REGION} | sudo ctr -n=k8s.io images pull --user AWS:$(aws ecr get-login-password --region ${AWS_REGION}) ${ECR_REPO}:${IMAGE_TAG}

# Docker approach
# aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin 058264251394.dkr.ecr.us-east-1.amazonaws.com
# sudo docker pull 058264251394.dkr.ecr.us-east-1.amazonaws.com/whisper:541c2b46-1b7a-433f-8443-a49afdb8aa66
###
# `docker tag` seems not to work with containerd or whatever the kubelet is using on Amazon Linux 2
###
# sudo docker tag 058264251394.dkr.ecr.us-east-1.amazonaws.com/whisper:541c2b46-1b7a-433f-8443-a49afdb8aa66 whisper:541c2b46-1b7a-433f-8443-a49afdb8aa66

# https://tecadmin.net/install-python-3-9-on-amazon-linux/
sudo yum install -y gcc openssl-devel bzip2-devel libffi-devel
cd /opt
sudo wget https://www.python.org/ftp/python/3.9.16/Python-3.9.16.tgz
sudo tar xzf Python-3.9.16.tgz

cd Python-3.9.16
sudo ./configure --enable-optimizations
sudo make altinstall

python3.9 -m pip install --upgrade pip

cd /data
cd ./stable-ts
python3.9 -m pip install .

# Else error that version of SSL used in URL calls is too old
python3.9 -m pip install urllib3==1.26.6
python3.9 -m pip install faster-whisper

cd /data
sudo chmod ugo+x ./download_whisper_data_al2.py
./download_whisper_data_al2.py

###
# Uninstall everything
###

cd /data
python3.9 -m pip freeze >installed_packages.txt
grep -v 'stable-ts @ file:///data/stable-ts' installed_packages.txt | xargs python3.9 -m pip uninstall -y

sudo rm -rf /usr/local/bin/python3.9*

sudo yum remove gcc openssl-devel bzip2-devel libffi-devel -y
# sudo yum remove docker -y

sudo yum clean all
sudo rm -rf /var/cache/yum

sudo rm -rf /opt/Python-3.9.16*

# Fill the free space with zeros and then remove the file to aid in compression
sudo dd if=/dev/zero of=/emptyfile bs=1M
sudo rm -f /emptyfile
