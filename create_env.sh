#!/bin/bash

# Dependenciesの構築
echo 'Install Dependencies'
sudo sudo yum -y install git
sudo yum groupinstall "Development Tools"
sudo yum install python-devel

# nginxの構築
sudo yum install nginx

# /etc/nginx/uwsgi_params を Djangoプロジェクトmysiteディレクトリにコピー
# sudo cp /etc/nginx/uwsgi_params /home/ec2-user/aws/

# シンボリックリンクを貼る
# sudo mkdir /etc/nginx/sites-enabled
# sudo ln -s /home/ec2-user/aws/aws_nginx.conf /etc/nginx/sites-enabled/

# pyenv環境の構築
# instructions from https://github.com/yyuu/pyenv.git
echo 'Install pyenv'
git clone https://github.com/yyuu/pyenv.git ~/.pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile
echo 'eval "$(pyenv init -)"' >> ~/.profile
. ~/.profile

# conda環境の構築
echo 'Install anaconda3-4.3.1'
pyenv install anaconda3-4.3.1
pyenv global anaconda3-4.3.1
echo 'export PATH="$PYENV_ROOT/versions/anaconda3-4.3.1/bin:$PATH"' >> ~/.profile
. ~/.profile

# Install Dependencies
echo 'Install packages'
pip install --upgrade pip
pip install -r ./requirements.txt

