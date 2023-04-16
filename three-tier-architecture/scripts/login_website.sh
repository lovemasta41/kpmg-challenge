#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

cd /var/www/html

sudo echo "<h1>COMPANY LOGIN PAGE</h1>" > index.html 