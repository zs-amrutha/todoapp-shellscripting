#!/bin/bash

source components/common.sh

OS_PREREQ

Head "Installing NGINX and npm"
apt install npm -y &>>$LOG
Stat $?

ADD_USER

DOWNLOAD_COMPONENT

Head "run and build npm"
npm install -g npm@latest &>>$LOG
# npm install shelljs &>>$LOG
# npm install --save-dev  --unsafe-perm node-sass &>>$LOG
npm run build  &>>$LOG
Stat $?

Head "configure environmental variables"
sed -i -e '32 s/127.0.0.1/login.zsdevops.online/g' -e '36 s/127.0.0.1/todo.zsdevops.online/g' /var/www/html/todoapp/frontend/config/index.js
Stat $?

Head "start NGINX and npm Services"
mv /var/www/html/todoapp/frontend/systemd.service /etc/systemd/system/frontend.service && systemctl daemon-reload && systemctl start frontend && systemctl enable frontend &>>$LOG
# npm start
Stat $?