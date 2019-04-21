#!/bin/bash
#
# After a fresh installation of MySQL, this script will determine the temporary
# password and re-establishes the root user to be mysql with a simple password.
#

# http://repo.mysql.com/
# https://centos.pkgs.org/7/mysql-5.7-x86_64/mysql-community-server-5.7.18-1.el7.x86_64.rpm.html

which mysqld
if [ $? -ne 0 ]; then
    echo "mysqld cannot be found, nothing to do..."
    exit 1
fi

sudo service mysqld status
if [ $? -ne 0 ]; then
    echo "mysqld is not running"
    sudo service mysqld start
fi

tmp=$(cat /var/log/mysqld.log | grep "temporary password" | xargs -n1 | tail -1)
echo "Temporary password $tmp"

cat <<EOF > /tmp/init.mysql
alter user 'root'@'localhost' identified by 'V@Gr@nt!!is!!c00L';
uninstall plugin validate_password;
alter user 'root'@'localhost' identified by 'password';
update user set user = 'mysql' where user = 'root';
commit;
flush privileges;
EOF

echo ""
echo "mysql initialization script"
cat /tmp/init.mysql

echo ""
echo "Executing mysql initialization script"
mysql -uroot -Dmysql -p${tmp} --connect-expired-password < /tmp/init.mysql

cat <<EOF >> /home/vagrant/README.mysql
MySQL information
Root User/Password: mysql/password
EOF
chmod 777 /home/vagrant/README.mysql
