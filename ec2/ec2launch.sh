#!/bin/bash 

echo "Creating your keypair"

aws ec2 create-key-pair \
	--key-name KeyPair4 \
	--query 'KeyMaterial' \
	--output text > KeyPair4.pem 

sudo chmod 400 KeyPair4.pem
sleep 5

echo "Create the VPC:"

aws ec2  create-vpc \
	--cidr-block 10.0.0.0/16 \
	--query Vpc.VpcId \
	--output text > vpc-id.txt

echo "step2"

sleep 5

export VPC_ID=$(cat vpc-id.txt)

echo "Create the Subnet in your VPC:"

aws ec2 create-subnet \
	--vpc-id $VPC_ID \
	--cidr-block 10.0.1.0/24 \
	--query Subnet.SubnetId \
	--output text > subnet-id.txt

export SUBNET_ID=$(cat subnet-id.txt)

echo "step3"

echo "Modify the Subnet to assign Public IP on Launch:"

aws ec2 modify-subnet-attribute \
	--subnet-id $SUBNET_ID \
	--map-public-ip-on-launch

aws ec2 create-internet-gateway \
	--query InternetGateway.InternetGatewayId \
	--output text > igw-id.txt

export IGW_ID=$(cat igw-id.txt)
echo "step4"
sleep 5

echo " Create an Internet Gateway:"


aws ec2 attach-internet-gateway \
	--internet-gateway-id $IGW_ID \
	--vpc-id $VPC_ID

echo " Create an Internet Gateway:"

aws ec2 create-security-group \
	--group-name my-sg \
	--description "My security group" \
	--vpc-id $VPC_ID --query GroupId \
	--output text > sg-id.txt

export SG_ID=$(cat sg-id.txt)

read -p "Insert AMI ID" AMI

export AMI_ID=$AMI

echo "step5"
sleep 5

echo "Create a new EC2 Instance with User data:"

aws ec2 run-instances \
	--image-id $AMI_ID \
	--count 1 \
	--instance-type t2.micro \
	--key-name KeyPair2 \
	--security-group-ids $SG_ID \
	--subnet-id $SUBNET_ID \
	--user-data file://bash.sh