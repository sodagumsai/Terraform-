#Create and bootstrap EC2 Bastion 

resource "aws_instance" "Terraform-test-Bastion" {
  ami                    = data.aws_ssm_parameter.linuxAmi.value
  instance_type          = var.instance-type
  vpc_security_group_ids = [aws_security_group.test-bastion-sg.id]
  iam_instance_profile   = "${aws_iam_instance_profile.ec2_profile.name}"
  subnet_id              = aws_subnet.test_public.id
  key_name               = "terraform"
  tags = {
    Name = "Terraform-test-Bastion - ${terraform.workspace}"
  }
}  

  resource "aws_instance" "Terraform-test-WL" {
    ami                    = data.aws_ssm_parameter.linuxAmiWl.value
    instance_type          = var.instance-type-wl
    vpc_security_group_ids = [aws_security_group.test-sg-wl.id]
    subnet_id              = aws_subnet.test_private.id
    iam_instance_profile   = "${aws_iam_instance_profile.ec2_profile.name}"
    key_name               = "terraform"
    tags = {
      Name = "Terraform-test-WL- ${terraform.workspace}"
    }
    user_data = <<-EOF
 #!/bin/bash
    exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
    /usr/bin/apt-get update
    DEBIAN_FRONTEND=noninteractive /usr/bin/apt-get upgrade -yq
    /usr/bin/apt-get install apache2 -y
    /usr/sbin/ufw allow in "Apache Full"
	/bin/echo "Hello world " >/var/www/html/index.html
    instance_ip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
    echo $instance_ip >>/var/www/html/index.html
 EOF
  }

