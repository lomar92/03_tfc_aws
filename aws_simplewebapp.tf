data "hcp_packer_iteration" "ubuntu" {
  bucket_name = "richemont"
  channel     = "dev"
}

data "hcp_packer_image" "webapp" {
  bucket_name    = "richemont"
  iteration_id   = data.hcp_packer_iteration.ubuntu.ulid
  cloud_provider = "aws"
  region         = "eu-central-1"
}

resource "aws_instance" "webapp" {
  ami                         = data.hcp_packer_image.webapp.cloud_image_id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.demo.id
  vpc_security_group_ids      = [aws_security_group.allow_tcp.id]

  tags = {
    Name = "packer-webapp-instance"
  }
}

output "WebService" {
  description = "Public IP of your EC2 instance"
  value       = aws_instance.webapp.public_ip
}

output "ami-image-id" {
  value = data.hcp_packer_image.webapp.cloud_image_id
}

output "iteration_id" {
  value = data.hcp_packer_iteration.ubuntu.ulid
}