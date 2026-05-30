AMI_ID="ami-0220d79f3f480ecf5"
 ZONE_ID="Z1012324J9RVO2S2GZ98"
 DOMAIN_NAME="styleloom.store"

 for instance in $@ 
 do 
INSTANCE_ID=$(ws ec2 run-instances \
    --image-id ami-0220d79f3f480ecf5 \
    --instance-type t3.micro \
    --security-groups roboshop-common \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=roboshop-$instance}]" \
    --query 'Instances[0].InstanceId' \
    --output text
)
echo "Launched instance with ID: $INSTANCE_ID"
if [ $instance == "frontend" ]; then
    IP=$(aws ec2 describe-instances --instance-ids i-0998ba329fe18e70d --query "Reservations[*].Instances[*].PublicIpAddress" --output text
)
R53_RECORD="$DOMAIN_NAME"
else
IP=$(aws ec2 describe-instances --instance-ids i-0998ba329fe18e70d --query "Reservations[*].Instances[*].PrivateIpAddress" --output text
)
R53_RECORD="$instance.$DOMAIN_NAME"
fi

 

 

 #update r53 record

 aws route53 change-resource-record-sets \
    --hosted-zone-id $ZONE_ID \
    --change-batch '
    {
    "comment": "Updating record for",
      "Changes": [
        {
          "Action": "UPSERT",
          "ResourceRecordSet": {
            "Name": "'$R53_RECORD'",
            "Type": "A",
            "TTL": 1,
            "ResourceRecords": [
              {
                "Value": "'$IP'"
              }
            ]
          }
        }
      ]
    }
    '
    done