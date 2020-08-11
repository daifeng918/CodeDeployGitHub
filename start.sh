#!/bin/bash
AWS_ACCESS_KEY_ID=$(grep aws_access_key_id tmpc | sort -u | awk '{print $3}')
AWS_SECRET_ACCESS_KEY=$(grep aws_secret_access_key tmpc | sort -u | awk '{print $3}')
# Configure the AWS CLI inside the container
aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
aws configure set region us-east-1
aws configure set output json

cp /opt/cloudmapper/tmpc ~/.aws/credentials
Account=$(cat tmpc |grep '-'|sed 's/^.//' | sed 's/.$//')
python cloudmapper.py collect --account $Account --regions us-east-1
python cloudmapper.py collect --account $Account --regions us-east-2
python cloudmapper.py report --account $Account 
python cloudmapper.py prepare --account $Account
python cloudmapper.py webserver


