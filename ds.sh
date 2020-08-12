#!/bin/bash
read -p "Enter your AWS Profile name :" profile
read -p "Enter your AWS Account ID :" accoutid
#echo $profile
cat ~/.aws/credentials | grep -A  4 $profile |grep -A  1 aws_access_key_id > tmp
#cat tmp
AWS_ACCESS_KEY_ID=$(sed -n '1p' < tmp)
AWS_SECRET_ACCESS_KEY=$(sed -n '2p' < tmp)

#Create Temp credentials file
echo "[default]" > tmpc
cat ~/.aws/credentials | grep -A  4 $profile | grep -A  2 aws_access_key_id >> tmpc
echo "[$profile]" >> tmpc
cat ~/.aws/credentials | grep -A  4 $profile | grep -A  2 aws_access_key_id >> tmpc
cat tmpc
echo "{ \"accounts\": [ {\"default\": true,\"id\": \"$accoutid\",\"name\" : \"$profile\"}], \"cidrs\": {} }" >  config.json

cat  config.json
docker build -t cloudmapper .
docker run -ti  -e 'echo $AWS_ACCESS_KEY_ID' -e 'echo $AWS_SECRET_ACCESS_KEY' -p 8000:8000 cloudmapper /bin/bash
rm tmp tmpc
