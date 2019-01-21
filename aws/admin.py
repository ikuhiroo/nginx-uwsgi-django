from django.contrib import admin

# Register your models here.
# usr : amazon
# email : ctwc0141@mail4.doshisha.ac.jp
# pass : candidate
# DBに登録したデータの表示
from .models import Aws

admin.site.register(Aws)
