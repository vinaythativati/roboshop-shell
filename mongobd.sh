#!/bin/bash

LOGS="/var/log/roboshop"
sudo mkdir -p $LOGS
sudo chown -R ec2-user:ec2-user $LOGS
sudo chmod -R 755 $LOGS
file="$LOGS/$0.log".


time=$(date '+%Y-%m-%d %H:%M:%S')
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color (Reset)


user=$(id -u)

if [ $user -ne 0 ]; then
        echo "$time [ERROR] $R run with super user $N" | tee -a $file
        exit 1
fi
validate() {

        if [ $1 -ne 0 ]; then
                echo "$time [ERR] $2 .. $RED failure" | tee -a $file

        else
                echo "$time  [INFO] $2 .. $GREEN success" | tee -a $file
        fi

}

cp mongo.repo /etc/apt/sources.list.d/
validate $? "Adding repo"

