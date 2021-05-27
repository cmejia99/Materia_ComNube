#!/usr/bin/env bash   

apt-get update -y
sleep 10
apt-upgrade -y
sleep 10
apt-get install net-tools 
apt-get install vim 