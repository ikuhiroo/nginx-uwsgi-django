# 独自のURLconf
from django.urls import path
from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('secret/', views.secret, name='secret'),
    path('calc', views.calc, name='calc'),
    path('stocker', views.stocker, name='stocker'),
]
