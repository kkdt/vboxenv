#!/bin/bash
#
# Create a database in mysql - assumes mysql root is mysql/password.
#

if [ $# -ne 2 ]; then
    echo "Error: Require db, user, and password"
    echo "Usage: $0 db user password"
fi

db=${1}
user=${2}
password=${3}

cat <<EOF > /tmp/db.mysql
create database ${db};
create user '${user}'@'localhost' identified by '${password}';
grant usage on *.* to '${user}'@'localhost';
grant all privileges on ${db}.* to '${user}'@'localhost';
flush privileges;
EOF

echo ""
echo "mysqlinit_db.sh data"
cat /tmp/db.mysql
mysql -Dmysql -ppassword -umysql < /tmp/db.mysql

cat <<EOF >> /home/vagrant/README.mysql
Database: ${db}
Database login: ${user}/${password}
EOF
