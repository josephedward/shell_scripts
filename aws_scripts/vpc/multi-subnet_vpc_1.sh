aws ec2 create-vpc --cidr-block 192.168.0.0/24 --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=ATD_VPC}]' 
    
python3 -c "import sys, json; print(json.load(sys.stdin)['vpc']['VpcId'])" 

local res = $?

