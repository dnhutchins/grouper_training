#!/usr/bin/env python
# -*- coding: UTF-8 -*-# enable debugging
import cgitb
import os 

cgitb.enable()

print("Content-Type: text/html;charset=utf-8")
print("\n")
print("<html><head><title>User Attributes</title></head>")
print("<body><p><a href=\"/Shibboleth.sso/Logout\">SP Logout</a></p>")

for k, v in sorted(os.environ.items()): 
    if k == "REMOTE_USER" or k.startswith('Shib') or not k[0].isupper():
        print "%s = %s<br>" % (k, v)

print("<p>* This list is a filtered list of environment variables containing the <a href=\"/Shibboleth.sso/Session\">Shibboleth SP attributes</a>.</p>")
print("</body></html>")