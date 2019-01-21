#!/bin/bash

# Dependenciesの構築
echo 'Install Dependencies'
sudo apt-get -y install build-essential 
sudo apt-get -y install cmake git unzip zip gcc make openssl libssl-dev libbz2-dev libreadline-dev libsqlite3-dev
sudo apt-get -y install python-dev python3-dev python-pip python3-pip

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

