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

if [ -z "${1}" ]; then
  echo "Error: A virtual host name (i.e. vbroker1) is required"
  exit 1
fi

echo "Installing RabbitMQ"
sudo yum -y install rabbitmq-server

echo "Enabling RabbitMQ Management Plugin"
rabbitmq-plugins enable rabbitmq_management

# firewall is off for Vagrant
#echo "Configuring RabbitMQ firewalls"
#sudo firewall-cmd --zone=public --add-port=5672/tcp --permanent
#sudo firewall-cmd --zone=public --add-port=15672/tcp --permanent
#sudo firewall-cmd --reload

echo "Restarting RabbitMQ"
sudo systemctl restart rabbitmq-server
sudo systemctl stop rabbitmq-server

echo "Configuring /var/lib/rabbitmq/.erlang.cookie"
rm -f /var/lib/rabbitmq/.erlang.cookie
echo "AQKZMIKKNOZHFEENNNQF" > /var/lib/rabbitmq/.erlang.cookie
chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie
chmod 400 /var/lib/rabbitmq/.erlang.cookie

echo "Starting up rabbitmq-server"
sudo systemctl restart rabbitmq-server
echo "Setting up virtual host: $1"
rabbitmqctl add_vhost $1
rabbitmqctl set_permissions -p $1 guest ".*" ".*" ".*"
echo "Creating initial set of exchanges"

systemctl rabbitmq-server.service
systemctl rabbitmq-server.service

echo "Log into the RabbitMQ Management Console using guest/guest as the credentials"

# Start it as a service to /usr/lib/systemd/system
# https://github.com/rabbitmq/rabbitmq-server/blob/master/docs/rabbitmq-server.service.example
