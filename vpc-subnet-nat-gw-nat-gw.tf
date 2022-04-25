#Get Linux AMI ID using SSM Parameter endpoint in Bastion
data "aws_ssm_parameter" "linuxAmi" {
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#Get Linux AMI ID using SSM Parameter endpoint in Wavelength
data "aws_ssm_parameter" "linuxAmiWl" {
 name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}



#Create VPC in Bastion 

resource "aws_vpc" "test_public" {
  cidr_block           = "10.0.0.0/16"
 enable_dns_support    = true
  enable_dns_hostnames = true
   tags = {
      Name = "test-vpc"
  }
}
# Internet gateway 
 resource "aws_internet_gateway" "igw" {
     vpc_id = aws_vpc.test_public.id
 }

 # route table for Public-Bastion
 
resource "aws_route_table" "rt-table-public-ig" {
    vpc_id = aws_vpc.test_public.id
        route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
             tags = {
        Name = "test-public-rt"
    }
  
}
# Create subnet  Bastion
resource "aws_subnet" "test_public" {
  vpc_id                   = aws_vpc.test_public.id
  cidr_block               = "10.0.1.0/24"
  map_public_ip_on_launch  = "true"
  availability_zone        = "us-east-1a"
  
}

  # Private Wavelength subnets
resource "aws_subnet" "test_private" {
  vpc_id                    = aws_vpc.test_public.id
  cidr_block                = "10.0.2.0/24"
  map_public_ip_on_launch   = "false"
  availability_zone         = "us-east-1-wl1-nyc-wlz-1"
  
}



#Overwrite default route table of VPC(Master) with our route table entries
resource "aws_route_table_association" "set-master-default-rt-assoc" {
 # vpc_id         = aws_vpc.test_public.id
  subnet_id      = aws_subnet.test_public.id 
  route_table_id = aws_route_table.rt-table-public-ig.id
}


#  route table associtation to public subnets...
# $resource "aws_route_table_association" "rt-public-association" {
#    subnet_id = aws_subnet.external_01.id
#    route_table_id = aws_route_table.rt-table-public-ig.id
#}



## external subnets

#resource "aws_subnet" "external_01" {
#  vpc_id     = aws_vpc.test_public.id
#  cidr_block = "10.0.2.0/24"
#  map_public_ip_on_launch = "true"
#  availability_zone= "us-east-1a"
#}
 

  
 # Internet gateway for WL
 #resource "aws_internet_gateway" "igw-wl" {
 #    vpc_id = aws_vpc.test_public.id
 #}

# create carrier gateway
resource "aws_ec2_carrier_gateway" "cgw" {
  vpc_id = aws_vpc.test_public.id

  tags = {
    Name = "test-cgw"
  }
}
# route table for Private-Wavelength
 
resource "aws_route_table" "rt-table-private" {
    vpc_id = aws_vpc.test_public.id
        route {
        cidr_block = "0.0.0.0/0"
        carrier_gateway_id = aws_ec2_carrier_gateway.cgw.id

    }
    tags = {
        Name = "test-private-rt"
    }
  
}


#Overwrite default route table of VPC(Worker) with our route table entries
resource "aws_route_table_association" "set-worker-default-rt-assoc" {
  #vpc_id         = aws_vpc.test_public.id
  subnet_id       = aws_subnet.test_private.id 
  route_table_id = aws_route_table.rt-table-private.id
}



#  route table associtation to private subnets...
#resource "aws_route_table_association" "rt-private-association" {
#    subnet_id =  aws_subnet.external_01.id
#    route_table_id = aws_route_table.rt-table-private-ig.id
#}


