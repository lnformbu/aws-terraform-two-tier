# VPC
resource "aws_vpc" "lenon-2-tier-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "lenon-2-tier-vpc"
  }
}

# Public Subnets 
resource "aws_subnet" "lenon-2-tier-pub-sub-1" {
  vpc_id                  = aws_vpc.lenon-2-tier-vpc.id
  cidr_block              = "10.0.0.0/18"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "lenon-2-tier-pub-sub-1"
  }
}

resource "aws_subnet" "lenon-2-tier-pub-sub-2" {
  vpc_id                  = aws_vpc.lenon-2-tier-vpc.id
  cidr_block              = "10.0.64.0/18"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "lenon-2-tier-pub-sub-2"
  }
}

# Private Subnets
resource "aws_subnet" "lenon-2-tier-pvt-sub-1" {
  vpc_id                  = aws_vpc.lenon-2-tier-vpc.id
  cidr_block              = "10.0.128.0/18"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "lenon-2-tier-pvt-sub-1"
  }
}
resource "aws_subnet" "lenon-2-tier-pvt-sub-2" {
  vpc_id                  = aws_vpc.lenon-2-tier-vpc.id
  cidr_block              = "10.0.192.0/18"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false
  tags = {
    Name = "lenon-2-tier-pvt-sub-2"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "lenon-2-tier-igw" {
  tags = {
    Name = "lenon-2-tier-igw"
  }
  vpc_id = aws_vpc.lenon-2-tier-vpc.id
}

# Route Table
resource "aws_route_table" "lenon-2-tier-rt" {
  tags = {
    Name = "lenon-2-tier-rt"
  }
  vpc_id = aws_vpc.lenon-2-tier-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lenon-2-tier-igw.id
  }
}

# Route Table Association
resource "aws_route_table_association" "lenon-2-tier-rt-as-1" {
  subnet_id      = aws_subnet.lenon-2-tier-pub-sub-1.id
  route_table_id = aws_route_table.lenon-2-tier-rt.id
}

resource "aws_route_table_association" "lenon-2-tier-rt-as-2" {
  subnet_id      = aws_subnet.lenon-2-tier-pub-sub-2.id
  route_table_id = aws_route_table.lenon-2-tier-rt.id
}


# Create Load balancer
resource "aws_lb" "lenon-2-tier-lb" {
  name               = "lenon-2-tier-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lenon-2-tier-alb-sg.id]
  subnets            = [aws_subnet.lenon-2-tier-pub-sub-1.id, aws_subnet.lenon-2-tier-pub-sub-2.id]

  tags = {
    Environment = "lenon-2-tier-lb"
  }
}

resource "aws_lb_target_group" "lenon-2-tier-lb-tg" {
  name     = "lenon-2-tier-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.lenon-2-tier-vpc.id
}

# Create Load Balancer listener
resource "aws_lb_listener" "lenon-2-tier-lb-listner" {
  load_balancer_arn = aws_lb.lenon-2-tier-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lenon-2-tier-lb-tg.arn
  }
}

# Create Target group
resource "aws_lb_target_group" "lenon-2-tier-loadb_target" {
  name       = "target"
  depends_on = [aws_vpc.lenon-2-tier-vpc]
  port       = "80"
  protocol   = "HTTP"
  vpc_id     = aws_vpc.lenon-2-tier-vpc.id

}

resource "aws_lb_target_group_attachment" "lenon-2-tier-tg-attch-1" {
  target_group_arn = aws_lb_target_group.lenon-2-tier-loadb_target.arn
  target_id        = aws_instance.lenon-2-tier-web-server-1.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "lenon-2-tier-tg-attch-2" {
  target_group_arn = aws_lb_target_group.lenon-2-tier-loadb_target.arn
  target_id        = aws_instance.lenon-2-tier-websr-2.id
  port             = 80
}

# Subnet group database
resource "aws_db_subnet_group" "lenon-2-tier-db-sub" {
  name       = "lenon-2-tier-db-sub"
  subnet_ids = [aws_subnet.lenon-2-tier-pvt-sub-1.id, aws_subnet.lenon-2-tier-pvt-sub-2.id]
}