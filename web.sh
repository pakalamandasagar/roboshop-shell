#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGODB_HOST=mongodb.daws77s.online

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script started executing at $TIMESTAMP" &>> $LOGFILE 

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2 ... $R FAILED $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi 
}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROE:: please run this script with root access $N"
    exit 1 # you can give other than 0
else
    echo "you are root user"
fi # fi means reverse of if, indicating codition end

dnf install nginx -y &>> $LOGFILE

VALIDATE $? "Installing Nginx"

systemctl enable nginx &>> $LOGFILE

VALIDATE $? "Enabling Nginx"

systemctl start nginx &>> $LOGFILE

VALIDATE $? "Starting nginx"

rm -rf /usr/share/nginx/html/* &>> $LOGFILE

VALIDATE $? "removed default website"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip 

VALIDATE $? "downloaded web application"

cd /usr/share/nginx/html &>> $LOGFILE

VALIDATE $? "moving nginx html directory"

unzip -o /tmp/web.zip &>> $LOGFILE

VALIDATE $? "unzipping web"

cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf 

VALIDATE $? "copied roboshop reverse proxy config" 

systemctl restart nginx &>> $LOGFILE

VALIDATE $? "restart nginx"