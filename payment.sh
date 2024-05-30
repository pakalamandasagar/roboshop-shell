#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGDB_HOST=mongodb.daws77s.online

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

dnf install python36 gcc python3-devel -y &>> $LOGFILE

id roboshop
if [ $? -ne 0 ]
then
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e "roboshop user already exist $Y SKIPPING $N"
fi 

mkdir -p /app &>> $LOGFILE

VALIDATE $? "Creating app directoty"

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>> $LOGFILE

VALIDATE $? "Downloading payment"

cd /app 

unzip -o /tmp/payment.zip &>> $LOGFILE

VALIDATE $? "unzipping payment"

pip3.6 install -r requirements.txt &>> $LOGFILE

VALIDATE $? "Installing dependencies"

cp /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service &>> $LOGFILE

VALIDATE $? "Copying payment service"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "daemon reload"

systemctl enable payment &>> $LOGFILE

VALIDATE $? "enable payment"

systemctl start payment &>> $LOGFILE

VALIDATE $? "start payment"