#!/usr/bin/bash

HOST_NAME="52.194.222.12"
PORT="80"

# basic認証あり
curl -u amazon:candidate "http://${HOST_NAME}:${PORT}/secret/"

# 出力結果
# SUCCESS
