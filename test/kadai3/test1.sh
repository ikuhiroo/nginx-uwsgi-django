#!/usr/bin/bash

curl 'http://127.0.0.1:8000/calc?abc'
curl 'http://127.0.0.1:8000/calc?1+1' 
curl 'http://127.0.0.1:8000/calc?2-1'
curl 'http://127.0.0.1:8000/calc?3*2'
curl 'http://127.0.0.1:8000/calc?4/2'
curl 'http://127.0.0.1:8000/calc?1+2*3'
curl 'http://127.0.0.1:8000/calc?(1+2)*3'

# 出力結果
# ERROR
# 2
# 1
# 6
# 2
# 7
# 9