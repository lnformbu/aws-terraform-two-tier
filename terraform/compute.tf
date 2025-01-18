# Public subnet EC2 instance 1
resource "aws_instance" "Lenon-2-tier-web-server-1" {
  ami             = "ami-064eb0bee0c5402c5"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.Lenon-2-tier-ec2-sg.id]
  subnet_id       = aws_subnet.Lenon-2-tier-pub-sub-1.id
  key_name   = "Lenon-2-tier-key"

  tags = {
    Name = "Lenon-2-tier-web-server-1"
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
resource "aws_instance" "Lenon-2-tier-websr-2" {
  ami             = "ami-064eb0bee0c5402c5"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.Lenon-2-tier-ec2-sg.id]
  subnet_id       = aws_subnet.Lenon-2-tier-pub-sub-2.id
  key_name   = "Lenon-2-tier-key"

  tags = {
    Name = "Lenon-2-tier-websr-2"
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

resource "aws_eip" "Lenon-2-tier-websr-1eip" {
  vpc = true

  instance                  = aws_instance.Lenon-2-tier-web-server-1.id
  depends_on                = [aws_internet_gateway.Lenon-2-tier-igw]
}

resource "aws_eip" "Lenon-2-tier-websr-2-eip" {
  vpc = true

  instance                  = aws_instance.Lenon-2-tier-websr-2.id
  depends_on                = [aws_internet_gateway.Lenon-2-tier-igw]
}