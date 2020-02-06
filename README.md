aws repository
===
## ●設計のポイント
* nginx（Webサーバー） + Django（WebApp） + WSGI（gateway，インターフェース）
* データストアに軽量なSQLiteを採用
* 仕様書に対してなるべく早くチェックするためにバリデーションチェックをした
* バリデーションチェックのために「cerberus（ケルベロス）」を用いる
* 構成管理ツール（Ansibleなど）を用いてインフラ構築の自動化
* CIツールを用いたDevOps
## ● Environment
```
OS : Linux version 4.9.32-15.41.amzn1.x86_64
CPU : Intel(R) Xeon(R) CPU E5-2676 v3 @ 2.40GHz
IP : 52.194.222.12
PORT : 80
ID : ***********
```
## ● 環境構築
### 1.リポジトリをクローン
```
git clone https://i_nishiyama@bitbucket.org/i_nishiyama/aws.git
cd aws
```
### 2. パッケージの構築
```
sh ${ProjectRoot}/create_env.sh

${ProjectRoot}/requirements.txt
--------------------------------------------------------------------------------
Django==2.1.4
requests==2.14.2
Cerberus==1.2
flake8==3.5.0
uwsgi
--------------------------------------------------------------------------------
```
| パッケージ | version |
|:----:|:----:|
| Python |Python 3.6.0 :: Anaconda 4.3.1 (64-bit)|
| Django |2.1.4|

### 3. プロジェクトの作成とWebアプリのテンプレートの作成
```
django-admin startproject aws
cd mySite
python manage.py startapp aws
```

### 4. Djangoプロジェクト（aws）のディレクトリ構造
```
aws
├── README.md
├── aws・・・アプリケーション
│   ├── __init__.py
│   ├── admin.py
│   ├── apps.py
│   ├── migrations・・・マイグレーションファイル
│   │   ├── 0001_initial.py・・・設計したマイグレーションファイル
│   │   └── __init__.py
│   ├── models.py・・・テーブルレイアウトの記述
│   ├── tests.py
│   ├── urls.py・・・アプリケーション単位でのルーティングの記述
│   └── views.py・・・ビュー（HttpResponseオブジェクトを返す）
├── aws_nginx.conf・・・nginx設定ファイル（シンボリックリンクを/etc/nginx/uwsgi_paramsに貼る）
├── create_env.sh・・・環境構築用ファイル（pyenv，conda，nginxなど）
├── db.sqlite3
├── manage.py
├── mysite
│   ├── __init__.py
│   ├── settings.py・・・django設定ファイル
│   ├── urls.py・・・プロジェクト全体のルーティングの記述
│   └── wsgi.py
├── requirements.txt・・・pythonパッケージの設定ファイル
├── test・・・テスト用
│   ├── kadai1・・・課題1のテスト
│   │   └── test1.sh
│   ├── kadai2・・・課題2のテスト
│   │   ├── test1.sh・・・Basic認証なし
│   │   └── test2.sh・・・Basic認証あり
│   ├── kadai3・・・課題3のテスト
│   │   └── test1.sh
│   └── kadai4・・・課題4のテスト
│       ├── test1.sh
│       ├── test2.sh
│       ├── test3.sh
│       └── test4.sh
└── uwsgi_params・・・「/etc/nginx/uwsgi_params」をコピー
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
usr : *****************
email : *****************
pass : *****************
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
### 1. アプリケーションの追加
### 1-1. アプリケーションのルーティング設定
* 「${ProjectRoot}/mysite/urls.py」にawsアプリケーションのルーティングを記述する
```
from django.contrib import admin
from django.urls import include, path

urlpatterns = [
    path('', include('aws.urls')), # 追加
    path('admin/', admin.site.urls),
]
```
### 1-2. django設定ファイルの変更（${ProjectRoot}/mysite/settings.py）の変更
* 「aws_nginx.conf」にawsアプリケーションのルーティングを記述する
```
# Application definition
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'aws.apps.AwsConfig', # 追加
]
```
### 2. モデル作成
* 「${ProjectRoot}/aws/model.py」にテーブルレイアウトを記述する
### 3. ビュー作成
* 「${ProjectRoot}/aws/views.py」にレスポンス内容を記述する
### 4. url追加
* 「${ProjectRoot}/aws/urls.py」にルーティングを記述する
### 5. nginx + uwsgiの起動
### 5-1. nginxの設定ファイル（${ProjectRoot}/aws_nginx.conf）の記述
* WSGIゲートウェイにポート8001を解放
* ポート80でリクエストを受け付ける
```
upstream django {
    server 127.0.0.1:8001; # for a web port socket (we'll use this first)
}
 
# configuration of the server
server {
    # the port your site will be served on
    listen      80;
    # the domain name it will serve for
    server_name 52.194.222.12; # substitute your machine's IP address or FQDN
    charset     utf-8;
 
    # max upload size
    client_max_body_size 75M;   # adjust to taste
 
    # location /static {
    #     alias /path/to/your/mysite/static; # your Django project's static files - amend as required
    # }
 
    # Finally, send all non-media requests to the Django server.
    location / {
        uwsgi_pass  django;
        include     /home/ec2-user/aws/uwsgi_params; # the uwsgi_params file you installed
    }
}
```
### 5-2. uwsgiの設定ファイルの記述
* 「/etc/nginx/uwsgi_params」のコピー
### 5-3. nginxの起動
```
sudo nginx
```
### 5-4. uwsgiの起動
```
nohup uwsgi --socket :8001 --module mysite.wsgi &
```

## ● 課題1 : 作業ログ
### 1. アプリケーションの追加
### 2. モデル作成
### 3. ビュー作成（${ProjectRoot}/aws/views.py）
```
from django.http import HttpResponse
def index(request):
    return HttpResponse("AMAZON\n")
```
### 4. ルーティングの記述（${ProjectRoot}/aws/urls.py）
```
from django.urls import path
from . import views

urlpatterns = [
    path('', views.index, name='index'),
]
```
### 5. nginx + uwsgiの起動

## ● 課題2 : 作業ログ
### 1. アプリケーションの追加
### 2. モデル作成
### 3. ビュー作成（${ProjectRoot}/aws/views.py）
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
### 4. ルーティングの記述（${ProjectRoot}/aws/urls.py）
```
from django.urls import path
from . import views

urlpatterns = [
    path('', views.index, name='index'),
	path('secret/', views.secret, name='secret'),
]
```
### 5. nginx + uwsgiの起動

## ● 課題3 : 作業ログ
### 1. アプリケーションの追加
### 2. モデル作成
### 3. ビュー作成（${ProjectRoot}/aws/views.py）
```
def calc(request):
    parameter = request.META['QUERY_STRING']
    try:
        result = int(eval(parameter))
        return HttpResponse(str(result)+'\n')
    except:
        return HttpResponse("ERROR\n")
```
### 4. ルーティングの記述（${ProjectRoot}/aws/urls.py）
```
from django.urls import path
from . import views

urlpatterns = [
    path('', views.index, name='index'),
	path('secret/', views.secret, name='secret'),
	path('calc', views.calc, name='calc'),
]
```
### 5. nginx + uwsgiの起動

## ● 課題4 : 作業ログ
### 1. アプリケーションの追加
### 2. モデル作成（${ProjectRoot}/aws/model.py）
```
# Create your models here.
from django.core.validators import MinValueValidator
from django.core.validators import MaxValueValidator
from django.core.validators import RegexValidator
from django.utils.translation import gettext_lazy as _

# テーブルレイアウトの設計
# 変更時
# python manage.py makemigrations aws
# python manage.py migrate
class Aws(models.Model):
    name = models.CharField(
        verbose_name='商品名',
        name='name',
        primary_key=True,
        max_length=8,
        unique=True,
        blank=True,
        null=False,
        default='',
        help_text='リクエストパラメータのnameを格納',
    )
    amount_regex = RegexValidator(
        regex=r'^[1-9][0-9]*$',
        message=_("正の整数を格納してください"),
        code='Disallowed Tags',
        inverse_match=None,
        flags=None,
    )
    amount = models.IntegerField(
        verbose_name='在庫数',
        name='amount',
        max_length=None,
        unique=False,
        blank=True,
        null=False,
        default=0,
        help_text='リクエストパラメータのamountを格納',
        validators=[amount_regex]
    )
    price_regex = RegexValidator(
        regex=r'^[1-9][0-9]*$',
        message=_("正の整数を格納してください"),
        code='Disallowed Tags',
        inverse_match=None,
        flags=None,
    )
    price = models.IntegerField(
        verbose_name='商品価格',
        name='price',
        max_length=None,
        unique=False,
        blank=True,
        null=False,
        default=1,
        help_text='リクエストパラメータのpriceを格納',
        validators=[price_regex]
    )
    sales_regex = RegexValidator(
        regex=r'^[0-9]*$',
        message=_("0以上の整数を格納してください"),
        code='Disallowed Tags',
        inverse_match=None, 
        flags=None, 
    )
    sales = models.IntegerField(
        verbose_name='売り上げ',
        name='sales',
        max_length=None,
        unique=False,
        blank=True,
        null=False,
        default=0,
        help_text='リクエストパラメータpriceが設定されたら，price x amountを格納',
        validators=[sales_regex]
    )
    # バックグラウンドの変更なのでmigratesする必要なし
    # aws.objects.all()で表示されるメッセージ
    def __str__(self):
        return self.name

```
### 3. ビュー作成（${ProjectRoot}/aws/views.py）
* バリデーションチェックのために「cerberus」を用いる
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
### 4. ルーティングの記述（${ProjectRoot}/aws/urls.py
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
### 5. nginx + uwsgiの起動

## ● リクエスト・レスポンステスト
```
check1 ... [PASS]
 accessing http://52.194.222.12:80/ (expects 'AMAZON') -> 'AMAZON' [OK]

check2 ... [PASS]
 accessing http://52.194.222.12:80/secret/ (expects 401) -> 401 Unauthorized [OK]
 accessing http://amazon:candidate@52.194.222.12:80/secret/ (expects 'SUCCESS') -> 'SUCCESS' [OK]

check3 ... [PASS]
 accessing http://52.194.222.12:80/calc?hTiAyhIx (expects ERROR) ... ERROR [OK]
 accessing http://52.194.222.12:80/calc?1+2 (expects 3) ... 3 [OK]
 accessing http://52.194.222.12:80/calc?6-95 (expects -89) ... -89 [OK]
 accessing http://52.194.222.12:80/calc?88*22 (expects 1936) ... 1936 [OK]
 accessing http://52.194.222.12:80/calc?4970/70 (expects 71) ... 71 [OK]
 accessing http://52.194.222.12:80/calc?-43+36 (expects -7) ... -7 [OK]
 accessing http://52.194.222.12:80/calc?4*(7+1) (expects 32) ... 32 [OK]
 accessing http://52.194.222.12:80/calc?(7-4)*7 (expects 21) ... 21 [OK]


check4 ... [PASS]
 accessing http://52.194.222.12:80/stocker?function=deleteall
 accessing http://52.194.222.12:80/stocker?function=addstock&name=xxx&amount=32
 accessing http://52.194.222.12:80/stocker?function=sell&name=xxx&amount=2
 accessing http://52.194.222.12:80/stocker?function=checkstock&name=xxx
 accessing http://52.194.222.12:80/stocker?function=addstock&name=yyy&amount=20
 accessing http://52.194.222.12:80/stocker?function=checkstock (expects xxx: 30
yyy: 20) ... xxx: 30
yyy: 20 [OK]
 accessing http://52.194.222.12:80/stocker?function=deleteall
 accessing http://52.194.222.12:80/stocker?function=addstock&name=xxx&amount=1.8603382606786114 (expects ERROR) ... ERROR [OK]
 accessing http://52.194.222.12:80/stocker?function=deleteall
 accessing http://52.194.222.12:80/stocker?function=addstock&name=aaa&amount=135
 accessing http://52.194.222.12:80/stocker?function=addstock&name=bbb&927
 accessing http://52.194.222.12:80/stocker?function=sell&name=aaa&amount=6&price=287
 accessing http://52.194.222.12:80/stocker?function=sell&name=aaa&price=15
 accessing http://52.194.222.12:80/stocker?function=checksales (expects sales: 1737) ... sales: 1737 [OK]
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
