#!/bin/bash
#
# Copyright 2020 kkdt
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
# Software, and to permit persons to whom the Software is furnished to do so, subject
# to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
# CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
# OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#


port=80
if [ ! -z "${1}" ]; then
  port=${1}
fi

echo "Installing /etc/yum.repos.d/nginx.repo"

tee -a /etc/yum.repos.d/nginx.repo << END
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/\$releasever/\$basearch/ gpgcheck=0 enabled=1
END

echo "Installing nginx"
yum install -y nginx

if [ -f /etc/nginx/conf.d/default.conf ]; then
  cat /etc/nginx/conf.d/default.conf
else
  tee -a /etc/nginx/conf.d/default.conf << END

# rabbitmq
#upstream rabbitmq {
#  server 127.0.0.1:15672;
#}

# couchdb
#upstream couchdb {
#  server 127.0.0.1:5984;
#}

server {
    listen ${port};
    server_name ${HOSTNAME};

# Example reverse proxy
#    location / {
#        proxy_set_header   X-Forwarded-For \$remote_addr;
#        proxy_set_header   Host \$http_host;
#        proxy_pass         http://localhost:8080;
#    }

#  location /rabbitmq/ {
#    rewrite /rabbitmq/(.*)\$ /\$1 break;
#    proxy_set_header X-Real-IP \$remote_addr;
#    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
#    proxy_set_header Host \$http_host;
#    proxy_set_header X-NginX-Proxy true;
#    proxy_pass http://rabbitmq;
#    proxy_redirect off;
#  }

#  location /couchdb/ {
#    rewrite /couchdb/(.*)\$ /\$1 break;
#    proxy_set_header X-Real-IP \$remote_addr;
#    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
#    proxy_set_header Host \$http_host;
#    proxy_set_header X-NginX-Proxy true;
#    proxy_pass http://couchdb;
#    proxy_redirect off;
#  }

}
END
fi


systemctl enable nginx.service
systemctl start nginx.service
