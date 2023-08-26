# EC2 Getting Started

# *WORK IN PROGRESS* - some commands are not working fully yet, check with me for updates.

## Before you launch:

Before you create an EC2 Instance you need a few things:
* `awscli` installed, on your Cloud9 instance this is preinstalled - no action needed.
* An SSH keypair
* A VPC and Security Group in AWS

### Creating the Key Pair

The following command in AWS CLI will create your keypair:

`aws ec2 create-key-pair --key-name KeyPairName --query 'KeyMaterial' --output text > KeyPairName.pem`

Before you can use this key pair, you must change it's permissions. 

`chmod 400 KeyPairName.pem`

For more information about key pair creation see: https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-keypairs.html#creating-a-key-pair

Note the name of your key pair and it's location, as you will need it in the future.


### Creating the VPC

Virtual Private Cloud is a networking isolation in AWS. Before we can start a server we must have the networking piece working.

* Create the VPC: `aws ec2 create-vpc --cidr-block 10.0.0.0/16 --query Vpc.VpcId --output text > vpc-id.txt`
* Set the VPC ID in your Bash Environment:  `export VPC_ID=$(cat vpc-id.txt)`
* Create the Subnet in your VPC:`aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.0.1.0/24 --query Subnet.SubnetId --output text > subnet-id.txt`
* Set the Subnet ID in your Bash Environment: `export SUBNET_ID=$(cat subnet-id.txt)`
* Modify the Subnet to assign Public IP on Launch: `aws ec2 modify-subnet-attribute --subnet-id $SUBNET_ID --map-public-ip-on-launch`    
* Create an Internet Gateway:  `aws ec2 create-internet-gateway --query InternetGateway.InternetGatewayId --output text > igw-id.txt`
* Set the IGW ID in your Bash Environment: `export IGW_ID=$(cat igw-id.txt)`
* Attach the IGW to your VPC: `aws ec2 attach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID`

### Creating the Security Group

A Security Group in AWS is what allows us to control traditional remote access via common protocols like RDP and SSH.

* Create the Security Group for your instance: `aws ec2 create-security-group --group-name my-sg --description "My security group" --vpc-id $VPC_ID --query GroupId --output text > sg-id.txt`
* Set the SG_ID in your Bash Environment: `export SG_ID=$(cat sg-id.txt)`

### Creating the EC2 Instance
Ubuntu AMI Locator: https://cloud-images.ubuntu.com/locator/ec2/

This example uses Ubuntu 23.04 in us-east-1

* Set the AMI ID in your Bash Environment: `export AMI_ID="ami-0d2fcfe4f5c4c5b56"`
* Create a new EC2 Instance with User data: `aws ec2 run-instances --image-id $AMI_ID --count 1 --instance-type t2.micro --key-name KeyPairName --security-group-ids $SG_ID --subnet-id $SUBNET_ID --user-data file://bash.sh`

