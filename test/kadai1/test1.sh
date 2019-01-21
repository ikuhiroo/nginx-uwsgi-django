#!/usr/bin/bash

HOST_NAME="127.0.0.1"
PORT="80"

# basic認証なし
curl "http://${HOST_NAME}:${PORT}/"
# 出力結果
# AMAZON
