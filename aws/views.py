from django.shortcuts import render

# Create your views here.
"""課題1：”AMAZON” と表示"""
from django.http import HttpResponse
def index(request):
    return HttpResponse("AMAZON\n")

"""課題2 ベーシック認証"""
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

"""課題3 四則演算の計算"""
def calc(request):
    parameter = request.META['QUERY_STRING']
    try:
        result = int(eval(parameter))
        return HttpResponse(str(result)+'\n')
    except:
        return HttpResponse("ERROR\n")

"""課題4 : 在庫管理"""
from aws.models import Aws
import json
from django.core.exceptions import ObjectDoesNotExist
from django.db.models.functions import Lower
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
                # 小文字，大文字の順番
                # 在庫が 0 のものは表示しない
                for member in Aws.objects.all().order_by(Lower('name')):
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
