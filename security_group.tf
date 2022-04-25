
resource "aws_security_group" "test-bastion-sg" {
  
  name        = "test-Bastion-sg"
  description = "Allow TCP/8080 & TCP/22"
  vpc_id     = aws_vpc.test_public.id
  ingress {
    description = "Allow 22 from our public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.external_ip]
  }
    
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}



resource "aws_security_group" "test-sg-wl" {
  
  name        = "test-Wl-sg"
  description = "Allow TCP/8080 & TCP/22"
  vpc_id     = aws_vpc.test_public.id
  # This Will chage as per ISV requrements 
 # ingress {
 #   description = "Allow 443 from our public IP"
 #   from_port   = 443
 #   to_port     = 443
 #   protocol    = "tcp"
 #   cidr_blocks = [var.external_ip]
 # }

    ingress {
    description     = "allow traffic from bastion on port 22"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.test-bastion-sg.id]
    }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


