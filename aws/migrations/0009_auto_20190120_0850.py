# Generated by Django 2.1.4 on 2019-01-20 08:50

import django.core.validators
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('aws', '0008_auto_20190120_0847'),
    ]

    operations = [
        migrations.AlterField(
            model_name='aws',
            name='amount',
            field=models.FloatField(blank=True, default=0, help_text='リクエストパラメータのamountを格納', validators=[django.core.validators.RegexValidator(message='正の整数を格納してください', regex='^[1-9][0-9]*$')], verbose_name='在庫数'),
        ),
        migrations.AlterField(
            model_name='aws',
            name='price',
            field=models.IntegerField(blank=True, default=1, help_text='リクエストパラメータのpriceを格納', validators=[django.core.validators.RegexValidator(message='正の整数を格納してください', regex='^[1-9][0-9]*$')], verbose_name='商品価格'),
        ),
        migrations.AlterField(
            model_name='aws',
            name='sales',
            field=models.IntegerField(blank=True, default=0, help_text='リクエストパラメータpriceが設定されたら，price x amountを格納', validators=[django.core.validators.RegexValidator(message='0以上の整数を格納してください', regex='^[0-9]*$')], verbose_name='売り上げ'),
        ),
    ]
