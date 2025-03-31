#!/bin/bash

sudo apt-get update -y
sudo apt install openjdk-17-jre-headless -y 
git clone https://github.com/shadibadria/ELK_Stack_Deployment.git

curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.17.4-amd64.deb
sudo dpkg -i filebeat-8.17.4-amd64.deb -y 
