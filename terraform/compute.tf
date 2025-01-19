# Public subnet EC2 instance 1
resource "aws_instance" "lenon-2-tier-web-server-1" {
  ami             = "ami-0866a3c8686eaeeba"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.lenon-2-tier-ec2-sg.id]
  subnet_id       = aws_subnet.lenon-2-tier-pub-sub-1.id
  key_name   = "test"

  tags = {
    Name = "lenon-2-tier-web-server-1"
  }

  user_data = <<-EOF
#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install nginx1 -y 
sudo systemctl enable nginx
sudo systemctl start nginx
EOF
}

# Public subnet  EC2 instance 2
resource "aws_instance" "lenon-2-tier-websr-2" {
  ami             = "ami-0866a3c8686eaeeba"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.lenon-2-tier-ec2-sg.id]
  subnet_id       = aws_subnet.lenon-2-tier-pub-sub-2.id
  key_name   = "test"

  tags = {
    Name = "lenon-2-tier-websr-2"
  }

  user_data = <<-EOF
#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install nginx1 -y 
sudo systemctl enable nginx
sudo systemctl start nginx
EOF
}

#EIP

resource "aws_eip" "lenon-2-tier-websr-1eip" {
  domain = "vpc"

  instance                  = aws_instance.lenon-2-tier-web-server-1.id
  depends_on                = [aws_internet_gateway.lenon-2-tier-igw]
}

resource "aws_eip" "lenon-2-tier-websr-2-eip" {
  domain = "vpc"

  instance                  = aws_instance.lenon-2-tier-websr-2.id
  depends_on                = [aws_internet_gateway.lenon-2-tier-igw]
}