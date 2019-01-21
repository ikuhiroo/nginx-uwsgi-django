from django.test import TestCase

# Create your tests here.
# 課題１：”AMAZON” と表示されるように設定
def test1(env, start_response):
    start_response('200 OK', [('Content-Type', 'text/html')])
    return [b"AMAZON"]  # python3

