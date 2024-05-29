#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

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

dnf module disable nodejs -y &>> $LOGFILE

VALIDATE $? "Disabling current NodeJS"

dnf module enable nodejs:18 -y &>> $LOGFILE

VALIDATE $? "Enabling NodeJS:18"

dnf install nodejs -y &>> $LOGFILE

VALIDATE $? "Installing NodeJS:18"

id roboshop
if [ $? -ne 0 ]
then
    useradd roboshop
    VALIDATE $? "roboshop user creation"
ellse
    echo -e "roboshop user already exist $Y SKIPPING $N"
fi 

mkdir -p /app

VALIDATE $? "Creating app directoty"

curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>> $LOGFILE

VALIDATE $? "Downloading cart Application"

cd /app 

unzip -o /tmp/cart.zip &>> $LOGFILE

VALIDATE $? "Unzipping cart"

npm install 

VALIDATE $? "Installing Dependencies"

# use absoult path, bacaues catalogue.service exists there
cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service

VALIDATE $? "Copying cart service file"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "cart daemon reload"

systemctl enable cart &>> $LOGFILE

VALIDATE $? "Enabling cart"

systemctl start cart &>> $LOGFILE

VALIDATE $? "Satarting cart"

