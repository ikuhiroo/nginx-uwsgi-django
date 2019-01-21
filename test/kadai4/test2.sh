#!/usr/bin/bash

HOST_NAME="127.0.0.1"
PORT="80"

# 1 : 在庫及び売り上げを全て削除
curl "http://${HOST_NAME}:${PORT}/stocker?function=deleteall"

# 2 : 在庫の追加：商品xxxを1.1個仕入れる -> ERROR
curl "http://${HOST_NAME}:${PORT}/stocker?function=addstock&name=xxx&amount=1.1"

# 出力結果
# ERROR
