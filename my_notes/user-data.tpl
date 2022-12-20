#!/bin/bash
#ALLOCATION_ID=eipalloc-011437d91b9099215
#REGION='curl --silent http://169.254.169.254/latest/dynamic/instance-identity/document|grep region|awk -F\" '{print $4}'`
#aws ec2 associate-address --allow-reassociation --instance-id $instance_id $INSTANCE_ID --allocation id $ALLOCATION_ID -region=$REGION
instance_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
aws ec2 associate-address --instance-id $instance_id --public-ip ${static_public_ip} --region ${region_name}
