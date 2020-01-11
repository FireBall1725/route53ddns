#!/usr/bin/env bash

# Check for required env vars
if [ -z $A_RECORD ]; then
  echo "A_RECORD is required..."
  exit 254
fi

if [ -z $TTL ]; then
  TTL="600"
fi

if [ -z $AWS_ACCESS_KEY_ID ]; then
  echo "AWS_ACCESS_KEY_ID is required..."
  exit 254
fi

if [ -z $AWS_SECRET_ACCESS_KEY ]; then
  echo "AWS_SECRET_ACCESS_KEY is required..."
  exit 254
fi

if [ -z $AWS_ROUTE53_ZONEID ]; then
  echo "AWS_ROUTE53_ZONEID is required..."
  exit 254
fi

echo "Checking $A_RECORD..."

HOST_IP=`dig +short $A_RECORD`
EXT_IP=`curl http://ifconfig.co/ 2>/dev/null`

if [ "$HOST_IP" != "$EXT_IP" ]; then
  echo "$A_RECORD is out of date"
  aws route53 change-resource-record-sets --hosted-zone-id $AWS_ROUTE53_ZONEID --change-batch "{ \"Changes\": [ { \"Action\": \"UPSERT\", \"ResourceRecordSet\": { \"Name\": \"$A_RECORD\", \"Type\": \"A\", \"TTL\": $TTL, \"ResourceRecords\": [ { \"Value\": \"$EXT_IP\" } ] } } ] }"
else
  echo "$A_RECORD is already up to date"
fi
