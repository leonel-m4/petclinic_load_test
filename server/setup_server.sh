#!/bin/bash
# Lab 15 - Preparación del servidor (Ubuntu 22.04/24.04). Ejecutar: bash setup_server.sh
set -e
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y openjdk-21-jdk mysql-server nginx   # el jar se compiló con Java 21
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Tecsup2023\$';"
sudo mysql -uroot -p'Tecsup2023$' -e "CREATE USER IF NOT EXISTS 'admin'@'localhost' IDENTIFIED BY 'A\$dmin123'; GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' WITH GRANT OPTION; FLUSH PRIVILEGES;"
mysql -u admin -p'A$dmin123' < ../data/schema-mysql.sql
mysql -u admin -p'A$dmin123' < ../data/data-mysql.sql
sudo cp nginx-default.conf /etc/nginx/sites-available/default
sudo ufw allow 'Nginx HTTP' || true
sudo systemctl restart nginx
echo "Listo. Ejecuta: mvn clean install -DskipTests -P prod && java -jar ../target/petclinic.jar --spring.profiles.active=prod"
