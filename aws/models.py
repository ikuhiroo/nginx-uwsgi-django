from django.db import models

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
    name_regex = RegexValidator(
        regex=r'^[a-zA-Z0-9]{0,8}',
        message=_("8文字以内"),
        code='Disallowed Tags',
        inverse_match=None,
        flags=None,
    )
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
        # validators=[name_regex]
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
