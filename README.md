3FIS repository
===
## ● Environment
```
OS : Linux version 4.9.32-15.41.amzn1.x86_64
CPU : Intel(R) Xeon(R) CPU E5-2676 v3 @ 2.40GHz
```

## ● 環境構築
### 1.リポジトリをクローン
```
git clone https://i_nishiyama@bitbucket.org/i_nishiyama/aws.git
cd aws
```
### 2. パッケージの構築
```
sh ./create_env.sh
```
| パッケージ | version |
|:----:|:----:|
| Python |Python 3.6.0 :: Anaconda 4.3.1 (64-bit)|
| Django |2.1.4|

## ●イメージ（nginx + uWSGI + Django）
```
the web client <-> the web server(nginx) <-> the socket <-> uWSGI <-> Django
nginx : Webサーバー
uWSGI : Web Server Gateway Interface
Django : Webアプリケーション
```

## ● nginxの起動（ポート80）
### 起動
```
sudo service nginx start
```
### 再起動
```
sudo nginx -s reload
```
### 停止
```
nginx -s stop
```

## ● uwsgiでdjangoプロジェクトを起動（ポート8001）
```
uwsgi --socket :8001 --module mysite.wsgi &
```
## ● テスト
### 課題1（”AMAZON” と表示）
```
sh test/kadai1/test1.py
-> AMAZON
```
### 課題2（ベーシック認証）
#### ベーシック認証なし
```
sh test/kadai2/test1.py
-> 
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>401 Authorization Required</title>
</head><body>
<h1>Authorization Required</h1>
<p>This server could not verify that you
are authorized to access the document
requested.  Either you supplied the wrong
credentials (e.g., bad password), or your
browser doesn't understand how to supply
the credentials required.</p>
<hr>
<address>Apache/2.2.29 (Amazon) Server at 1.2.3.4 Port 80</address>
</body></html>
```
#### ベーシック認証あり
```
sh test/kadai2/test2.py
-> 
SUCCESS
```
### 課題3（四則演算）
```
sh test/kadai3/test1.py
-> 
ERROR
2
1
6
2
7
9
```
### 課題4（在庫管理）
#### ケース1
```
sh test/kadai4/test1.py
-> 
xxx: 96
xxx: 96
yyy: 100
YYY: 100
```
#### ケース2
```
sh test/kadai4/test2.py
-> 
ERROR
```
#### ケース3
```
sh test/kadai4/test3.py
-> 
aaa: 5
sales: 480
```
#### ケース4（自分で作成）
```
sh test/kadai4/test4.py
-> ERROR
```