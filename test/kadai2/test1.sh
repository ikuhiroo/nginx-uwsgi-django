#!/usr/bin/bash

HOST_NAME="52.194.222.12"
PORT="80"

# basic認証なし
curl "http://${HOST_NAME}:${PORT}/secret/"

# 出力結果
# <!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
# <html><head>
# <title>401 Authorization Required</title>
# </head><body>
# <h1>Authorization Required</h1>
# <p>This server could not verify that you
# are authorized to access the document
# requested.  Either you supplied the wrong
# credentials (e.g., bad password), or your
# browser doesn't understand how to supply
# the credentials required.</p>
# <hr>
# <address>Apache/2.2.29 (Amazon) Server at 1.2.3.4 Port 80</address>
# </body></html>
