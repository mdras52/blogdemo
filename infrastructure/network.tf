resource "aws_vpc" "blog_vpc" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "Blog VPC"
  }
}

resource "aws_subnet" "blog_public_subnet_1" {
  vpc_id     = aws_vpc.blog_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags = {
    Name = "Blog Public Subnet 1"
  }
}

resource "aws_subnet" "blog_public_subnet_2" {
  vpc_id     = aws_vpc.blog_vpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"

  tags = {
    Name = "Blog Public Subnet 2"
  }
}

resource "aws_subnet" "blog_public_subnet_3" {
  vpc_id     = aws_vpc.blog_vpc.id
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1c"

  tags = {
    Name = "Blog Public Subnet 3"
  }
}

resource "aws_db_subnet_group" "blog_db_subnet_group" {
  name       = "blog_db_subnet"
  subnet_ids = [aws_subnet.blog_public_subnet_2.id, aws_subnet.blog_public_subnet_3.id]

  tags = {
    Name = "Blog DB Subnet Group"
  }
}

resource "aws_internet_gateway" "blog_ig" {
  vpc_id = aws_vpc.blog_vpc.id

  tags = {
    Name = "Blog IG"
  }
}

resource "aws_route_table" "blog_ig_public_rt" {
    vpc_id = aws_vpc.blog_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.blog_ig.id
    }

    tags = {
        Name = "Blog Route Table Internet Gateway"
    }
}

resource "aws_route_table_association" "blog_rta_ig_public_subnet_1" {
    subnet_id = aws_subnet.blog_public_subnet_1.id
    route_table_id = aws_route_table.blog_ig_public_rt.id
}

resource "aws_route_table_association" "blog_rta_ig_public_subnet_2" {
    subnet_id = aws_subnet.blog_public_subnet_2.id
    route_table_id = aws_route_table.blog_ig_public_rt.id
}

resource "aws_route_table_association" "blog_rta_ig_public_subnet_3" {
    subnet_id = aws_subnet.blog_public_subnet_3.id
    route_table_id = aws_route_table.blog_ig_public_rt.id
}

resource "aws_security_group" "blog_sec_group_public" {
  name        = "blog_sec_group_public"
  description = "Allow inbound public web traffic and SSH for admin"
  vpc_id      = aws_vpc.blog_vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Blog Public Sec Group"
  }
}

resource "aws_security_group" "blog_db_sec_group" {
  name        = "blog_db_sec_group"
  description = "Allow inbound traffic from pub sec group"
  vpc_id      = aws_vpc.blog_vpc.id

  ingress {
    description = "MYSQL Blog Sec Group"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.blog_sec_group_public.id]
  }

# Aurora Serverless cannot be accessed publicly
  # ingress {
  #   description = "MYSQL Personal"
  #   from_port   = 3306
  #   to_port     = 3306
  #   protocol    = "tcp"
  #   cidr_blocks = [var.my_ip]
  # }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Blog DB Sec Group"
  }
}
