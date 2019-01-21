#!/usr/bin/bash

# 1 : 在庫及び売り上げを全て削除
curl "http://127.0.0.1:8000/stocker?function=deleteall"

# 2 : 在庫の追加：商品xxxを1.1個仕入れる -> ERROR
curl "http://127.0.0.1:8000/stocker?function=addstock&name=xxx&amount=1.1"

# 出力結果
# ERROR