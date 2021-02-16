resource "aws_key_pair" "blog_key" {
  key_name   = "deployer-key"
  public_key = var.blog_key_pub
}

resource "aws_instance" "blog_instance" {
  ami                         = "ami-03d315ad33b9d49c4" # us-east-1 Ubuntu 20.04
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.blog_public_subnet_1.id
  vpc_security_group_ids      = [aws_security_group.blog_sec_group_public.id]
  key_name                    = aws_key_pair.blog_key.key_name
  user_data                   = templatefile("scripts/blog_instance_prereqs.sh",
      {
        site_name = var.site_name
        domain_name = var.domain_name
        db_endpoint = aws_rds_cluster.blog_db.endpoint
        db_user = var.rds_master_username
        db_pass = var.rds_master_password
        url = var.url
      }
    )

  tags = {
    Name = "Blog Instance"
  }

  depends_on = [
    aws_rds_cluster.blog_db
  ]
}

output "instance_ip_addr" {
  value = aws_instance.blog_instance.public_ip
}
