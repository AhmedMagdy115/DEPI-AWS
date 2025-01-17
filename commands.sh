aws ec2 create-vpc --cidr-block 10.0.0.0/16
aws ec2 create-tags --resources vpc-02e6ee0b53fa1230a --tags Key=Name,Value="Lab VPC"
aws ec2 modify-vpc-attribute --vpc-id vpc-02e6ee0b53fa1230a --enable-dns-hostnames "{\"Value\":true}"


aws ec2 create-subnet --vpc-id vpc-02e6ee0b53fa1230a --cidr-block 10.0.0.0/24 --availability-zone us-east-1a 
aws ec2 create-tags --resources subnet-04614234cff522335 --tags Key=Name,Value="Public Subnet"
aws ec2 modify-subnet-attribute --subnet-id subnet-04614234cff522335 --map-public-ip-on-launch
aws ec2 create-subnet --vpc-id vpc-02e6ee0b53fa1230a --cidr-block 10.0.2.0/23 --availability-zone us-east-1a --tag-specifications "ResourceType=subnet, Tags=[{Key=Name,Value='Private Subnet'}]"


aws ec2 create-internet-gateway --tag-specifications "ResourceType=internet-gateway,Tags=[{Key=Name,Value='Lab IGW'}]"
aws ec2 attach-internet-gateway --vpc-id vpc-02e6ee0b53fa1230a --internet-gateway-id igw-0e18809a2f9e30f99


aws ec2 describe-route-tables --filters "Name=vpc-id,Values=vpc-02e6ee0b53fa1230a"
aws ec2 create-tags --resources rtb-0a777c8817a553ca6 --tags Key=Name,Value="Private Route Table"
aws ec2 create-route-table --vpc-id vpc-02e6ee0b53fa1230a 
aws ec2 create-tags --resources rtb-091b41c1f9f5882d2 --tags Key=Name,Value="Public Route Table"
aws ec2 create-route --route-table-id rtb-091b41c1f9f5882d2 --destination-cidr-block 0.0.0.0/0 --gateway-id igw-0e18809a2f9e30f99
aws ec2 associate-route-table --route-table-id rtb-091b41c1f9f5882d2 --subnet-id subnet-04614234cff522335


aws ec2 create-security-group --group-name App-SG --description "Security group for App Server" --vpc-id vpc-02e6ee0b53fa1230a
aws ec2 authorize-security-group-ingress --group-id sg-0120bb9aab4b923d0 --protocol tcp --port 80 --cidr 0.0.0.0/0



aws ec2 run-instances --image-id ami-0fff1b9a61dec8a5f --count 1 --instance-type t2.micro --key-name vockey --subnet-id subnet-04614234cff522335 --security-group-ids sg-0120bb9aab4b923d0  --iam-instance-profile Name=Inventory-App-Role --user-data file://E:\DEPI\project\user-data-script.txt --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value='App Server'}]"


