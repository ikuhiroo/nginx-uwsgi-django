#!/usr/bin/bash

HOST_NAME="127.0.0.1"
PORT="8000"

# basic認証あり
curl -u amazon:candidate "http://${HOST_NAME}:${PORT}/secret/"

# 出力結果
# SUCCESS