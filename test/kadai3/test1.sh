#!/usr/bin/bash

HOST_NAME="127.0.0.1"
PORT="80"

curl "http://${HOST_NAME}:${PORT}/calc?abc"
curl "http://${HOST_NAME}:${PORT}/calc?1+1" 
curl "http://${HOST_NAME}:${PORT}/calc?2-1"
curl "http://${HOST_NAME}:${PORT}/calc?3*2"
curl "http://${HOST_NAME}:${PORT}/calc?4/2"
curl "http://${HOST_NAME}:${PORT}/calc?1+2*3"
curl "http://${HOST_NAME}:${PORT}/calc?(1+2)*3"

# 出力結果
# ERROR
# 2
# 1
# 6
# 2
# 7
# 9
