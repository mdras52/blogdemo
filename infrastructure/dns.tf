resource "aws_route53_record" "blog_dns" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = "60"
  records = [aws_instance.blog_instance.public_ip]
}
