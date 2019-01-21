aws repository
===
## ● Environment
```
OS : Linux version 4.9.32-15.41.amzn1.x86_64
CPU : Intel(R) Xeon(R) CPU E5-2676 v3 @ 2.40GHz
IP : 52.194.222.12
PORT : 80
ID : AMZ000790
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

### 3. ディレクトリ構造
```
.
├── README.md・・・このファイル
├── aws・・・アプリケーション
│   ├── __init__.py
│   ├── admin.py
│   ├── apps.py
│   ├── migrations・・・マイグレーションファイル
│   │   ├── 0001_initial.py
│   │   └── __init__.py
│   ├── models.py・・・モデル
│   ├── tests.py
│   ├── urls.py・・・アプリケーション単位でのルーティングの記述
│   └── views.py・・・ビュー
├── aws_nginx.conf・・・nginx設定ファイル（シンボリックリンクを/etc/nginx/uwsgi_paramsに貼る）
├── create_env.sh・・・環境構築用ファイル
├── db.sqlite3・・・SQLite
├── manage.py
├── mysite
│   ├── __init__.py
│   ├── settings.py・・・django設定ファイル
│   ├── urls.py・・・プロジェクト全体のルーティングの記述
│   └── wsgi.py
├── requirements.txt・・・pythonパッケージ設定ファイル
├── test・・・テスト用
│   ├── kadai1
│   │   └── test1.sh
│   ├── kadai2
│   │   ├── test1.sh
│   │   └── test2.sh
│   ├── kadai3
│   │   └── test1.sh
│   └── kadai4
│       ├── test1.sh
│       ├── test2.sh
│       ├── test3.sh
│       └── test4.sh
└── uwsgi_params
```
## ●イメージ（nginx + uWSGI + Django）
```
the web client <-> the web server(nginx) <-> the socket <-> uWSGI <-> Django
nginx : Webサーバー
uWSGI : Web Server Gateway Interface
Django : Webアプリケーション
```

## ● DB（SQLite）
### admin
```
usr : amazon
email : ctwc0141@mail4.doshisha.ac.jp
pass : candidate
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
## ●課題1~4における共通事項
### 1. 「aws/mysite/urls.py」にawsアプリケーションのルーティングを記述する
```
from django.contrib import admin
from django.urls import include, path

urlpatterns = [
    path('', include('aws.urls')),
    path('admin/', admin.site.urls),
]
```
### 2. 「aws/aws/views.py」にレスポンス内容を記述する
### 3. 「aws/aws/urls.py」にルーティングを記述する
### 4. nginx + uwsgiの起動
#### 4-1. nginxの設定ファイルの記述
#### 4-2. uwsgiの設定ファイルの記述

## ● 課題1 : 作業ログ
### 2. 「aws/aws/views.py」にレスポンス内容を記述する
```
from django.http import HttpResponse
def index(request):
    return HttpResponse("AMAZON\n")
```
### 3. 「aws/aws/urls.py」にルーティングを記述する
```
from django.urls import path
from . import views

urlpatterns = [
    path('', views.index, name='index'),
]
```
## ● 課題2 : 作業ログ
### 2. 「aws/aws/views.py」にレスポンス内容を記述する
```
import base64
def secret(request):
    BASICAUTH_USERNAME = 'amazon'
    BASICAUTH_PASSWORD = 'candidate'
    try:
        authentication = request.META['HTTP_AUTHORIZATION']
        (authmeth, auth) = authentication.split(' ', 1)
        auth = base64.b64decode(auth).decode('utf-8')
        username, password = auth.split(':', 1)
        if username == BASICAUTH_USERNAME and password == BASICAUTH_PASSWORD:
            return HttpResponse("SUCCESS\n")
        else:
            return HttpResponse(status=401)
    except:
        return HttpResponse(status=401)
```
### 3. 「aws/aws/urls.py」にルーティングを記述する
```
from django.urls import path
from . import views

urlpatterns = [
    path('', views.index, name='index'),
	path('secret/', views.secret, name='secret'),
]
```
## ● 課題3 : 作業ログ
### 2. 「aws/aws/views.py」にレスポンス内容を記述する
```
def calc(request):
    parameter = request.META['QUERY_STRING']
    try:
        result = int(eval(parameter))
        return HttpResponse(str(result)+'\n')
    except:
        return HttpResponse("ERROR\n")
```
### 3. 「aws/aws/urls.py」にルーティングを記述する
```
from django.urls import path
from . import views

urlpatterns = [
    path('', views.index, name='index'),
	path('secret/', views.secret, name='secret'),
	path('calc', views.calc, name='calc'),
]
```
## ● 課題4 : 作業ログ
### 2. 「aws/aws/views.py」にレスポンス内容を記述する
```
from aws.models import Aws
import json
from django.core.exceptions import ObjectDoesNotExist
from cerberus import Validator

# バリデーション定義 (Cerberus)
schema = {
    'function': {
        'type': 'string',
        'regex': 'deleteall|addstock|checkstock|sell|checksales',
        'nullable' : False
    },
    'name': {
        'type': 'string',
        'empty': False, 
        'regex': '^[a-zA-Z0-9]{0,8}', 
        'nullable': True
    },
    'amount': {
        'type': 'string',
        'regex': '^[1-9][0-9]*$',
        'nullable': True
    },
    'price': {
        'type': 'string',
        'regex': '^[1-9][0-9]*$', 
        'nullable': True
    }
}

def stocker(request):
    # バリデーションチェック
    v = Validator(schema)
    request_parameter = {
        'function': request.GET['function'] if 'function' in request.GET else None,
        'name': request.GET['name'] if 'name' in request.GET else None,
        'amount': request.GET['amount'] if 'amount' in request.GET else None,
        'price': request.GET['price'] if 'price' in request.GET else None,
    }
    ischecked = v.validate(request_parameter)
    # print(ischecked)
    # print(v.errors)

    ResultResponse = ''  # レスポンス
    if ischecked == False:
        return HttpResponse('ERROR\n')
    else:
        request_function = request.GET['function']
        # 全削除
        if request_function == 'deleteall':
            Aws.objects.all().delete()
        # 在庫の追加
        elif request_function == 'addstock':
            try:  # 登録されたnameの場合
                request_name = request.GET['name']
                obj = Aws.objects.all().get(name=request_name)
            except ObjectDoesNotExist:  # 新規nameの場合
                obj = Aws(name=request.GET['name'])
                obj.save()
            request_amount = eval(
                request.GET['amount']) if 'amount' in request.GET else 1  # 追加数
            obj.amount += request_amount
            obj.save()
        # 在庫チェック
        elif request_function == 'checkstock':
            try:
                # nameが指定された場合
                # そのnameの商品の在庫の数を "[name]: [amount]" の形式で出力する
                # 在庫が無い場合は amountを 0 として表示する
                try:
                    request_name = request.GET['name']
                    obj = Aws.objects.all().get(name=request_name)
                except ObjectDoesNotExist:
                    obj = Aws(name=request.GET['name'])  # 新規作成 (insert) 
                    obj.save()  # db更新 (update) 
                ResultResponse = '{}: {}\n'.format(obj.name, obj.amount)
            except:
                # nameが指定されない場合
                # 全ての商品の在庫の数をnameをキーに昇順ソートして出力する
                # 在庫が 0 のものは表示しない
                for member in Aws.objects.all().order_by('amount'):
                    if Aws.objects.all().get(name=member).amount == 0:
                        pass
                    else:
                        ResultResponse += '{}: {}\n'.format(
                            Aws.objects.all().get(name=member).name, 
                            Aws.objects.all().get(name=member).amount
                        )
        # 販売
        elif request_function == 'sell':
            try:  # 登録されたnameの場合
                request_name = request.GET['name']
                obj = Aws.objects.all().get(name=request_name)
            except ObjectDoesNotExist:  # 新規nameの場合
                obj = Aws(name=request.GET['name'])
                obj.save()
            request_amount = eval(request.GET['amount']) if 'amount' in request.GET else 1  # 追加数
            obj.amount -= request_amount
            obj.save()
            try:  # amountが与えられた場合
                request_price = eval(request.GET['price'])
                obj.price = request_price
                result_sales = request_amount * request_price
                obj.sales += result_sales
                obj.save()
            except:  # amountが省略された場合
                pass
        # 売り上げチェック
        # その時点の売り上げを "sales: [sales]" の形式で表示する
        # 小数の場合は小数点第二位まで表示する
        elif request_function == 'checksales':
            for member in Aws.objects.all().order_by('name'):
                if Aws.objects.all().get(name=member).sales == 0:
                    pass
                else:
                    ResultResponse += 'sales: {}\n'.format(Aws.objects.all().get(name=member).sales)
            
        return HttpResponse(ResultResponse)

```
### 3. 「aws/aws/urls.py」にルーティングを記述する
```
from django.urls import path
from . import views

urlpatterns = [
    path('', views.index, name='index'),
	path('secret/', views.secret, name='secret'),
	path('calc', views.calc, name='calc'),
	path('stocker', views.stocker, name='stocker'),
]
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