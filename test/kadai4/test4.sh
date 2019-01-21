#!/usr/bin/bash

HOST_NAME="52.194.222.12"
PORT="80"

# 1 : 在庫及び売り上げを全て削除
curl "http://${HOST_NAME}:${PORT}/stocker?function=deleteall"

# 2 : 在庫の追加：商品xxxbbbbを100個仕入れる
curl "http://${HOST_NAME}:${PORT}/stocker?function=addstock&name=xxxbbbbb&amount=100"

# 3 : 販売：商品xxxbbbbbを4個売る -> 96個
curl "http://${HOST_NAME}:${PORT}/stocker?function=addstock&name=xxxbbbbbb&amount=100"

# 出力結果
# ERROR ({'name': ["value does not match regex '^[a-zA-Z0-9]{0,8}'"]})
