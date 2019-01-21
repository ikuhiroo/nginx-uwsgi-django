#!/usr/bin/bash

HOST_NAME="127.0.0.1"
PORT="80"

# 1 : 在庫及び売り上げを全て削除
curl "http://${HOST_NAME}:${PORT}/stocker?function=deleteall"

# 2 : 在庫の追加：商品xxxを100個仕入れる
curl "http://${HOST_NAME}:${PORT}/stocker?function=addstock&name=xxx&amount=100"

# 3 : 販売：商品xxxを4個売る -> 96個
curl "http://${HOST_NAME}:${PORT}/stocker?function=sell&name=xxx&amount=4"

# 4 : 在庫チェック：商品xxxの在庫をチェックする -> xxx: 96
curl "http://${HOST_NAME}:${PORT}/stocker?function=checkstock&name=xxx"

# 5 : 在庫の追加：商品yyyを100個仕入れる
curl "http://${HOST_NAME}:${PORT}/stocker?function=addstock&name=yyy&amount=100"

# 6 : 在庫の追加：商品YYYを100個仕入れる
curl "http://${HOST_NAME}:${PORT}/stocker?function=addstock&name=YYY&amount=100"

# 7 : 売り上げチェック : xxx: 96, yyy: 100, YYY: 100
curl "http://${HOST_NAME}:${PORT}/stocker?function=checkstock"

# 出力結果
# xxx: 96
# xxx: 96
# yyy: 100
# YYY: 100
