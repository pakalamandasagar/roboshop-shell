#!/bin/bash

AMI=ami-0b4f379183e5706b9
SG_ID=sg-053247f007b858182 #replace with your SG ID
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web") 

for i in "${INSTANCES[@]}"
do 
    echo "instance is: $i"
    if [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
    then
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.small"
    fi

    aws ec2 run-instances --image-id ami-0b4f379183e5706b9 --instance-type $INSTANCE_TYPE --security-group-ids sg-053247f007b858182 --tag-specifications "ResourceType=instance, Tags=[{key=Name,Value=$i}]"
done
