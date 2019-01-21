#!/usr/bin/bash

HOST_NAME="127.0.0.1"
PORT="80"

# 1: 在庫及び売り上げを全て削除
curl "http://${HOST_NAME}:${PORT}/stocker?function=deleteall"

# 2: 在庫の追加：商品aaaを10個仕入れる
curl "http://${HOST_NAME}:${PORT}/stocker?function=addstock&name=aaa&amount=10"

# 3: 在庫の追加：商品bbbを10個仕入れる
curl "http://${HOST_NAME}:${PORT}/stocker?function=addstock&name=bbb&amount=10"

# 4: 販売：商品aaaを100円で4個売る
curl "http://${HOST_NAME}:${PORT}/stocker?function=sell&name=aaa&amount=4&price=100"

# 5: 販売：商品aaaを80円で1個売る
curl "http://${HOST_NAME}:${PORT}/stocker?function=sell&name=aaa&price=80"

# 6: 在庫チェック：商品aaaの在庫をチェックする -> aaa: 5
curl "http://${HOST_NAME}:${PORT}/stocker?function=checkstock&name=aaa"

# 7: 売り上げチェック -> sales: 480
curl "http://${HOST_NAME}:${PORT}/stocker?function=checksales"

# 出力結果
# aaa: 5
# sales: 480
