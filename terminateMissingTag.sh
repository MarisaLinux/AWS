#!/bin/bash

echo 'Subnet ID?'
read SUBNET
echo 'Tag to search for?'
read TAG
 
IDS=$(aws ec2 describe-instances \
  --output text \
  --filters Name=subnet-id, Values="$SUBNET"
  --query 'Reservations[].Instances[?!not_null(Tags[?Key == `"$TAG"`].Value)] | [].[InstanceId]')
echo "instances to be deleted are $IDS"
echo "testing..."
aws ec2 terminate-instances --dry-run --instance-ids $ids
read -p "Continue to terminate? Y/N " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
  aws ec2 terminate-instances -instance-ids $IDS
else
  exit 0
fi
