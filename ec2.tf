data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = [
      "amzn2-ami-hvm-*-x86_64-gp2",
    ]
  }
  filter {
    name = "owner-alias"
    values = [
      "amazon",
    ]
  }
}
resource "aws_key_pair" "jenkins_ssh_key" {
  key_name   = "lambda-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCkb60iTBfjKePCjCBnMj5xNamlvfiFKNPX3b0hepV6mGbJ0nTL1lhD7iyxybFBzzS0BKTjWN/DQmykGwJg8HdoO4Co+al5VUaBxqpDnwOBbiYI76EvqebrPvzCJ6UGxuMrRU65pUtbrJqyhpYIyVYkZW/pTd94X/0MZs6UziEmE6UcHcGr58rHRwl5z2nDtHHX51XumPYEp1DrhDRBm9Cy3W2FGGMhH7zZesM5/AtbuSxiV/G1c31ufXxEAUNAuSLRIUIUWRW9QAlLY2HtXNN5fEz3yWg9WJmZ4DVGrG3VgxCQrcUV4h/ytFRaFwdim5KCD1wB2VdEIBQakIKYByUH lambda@lambda-desktop"
}
resource "aws_instance" "jenkins_instance" {
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_ssh_jenkins.id]
  key_name               = aws_key_pair.jenkins_ssh_key.key_name
  user_data              = file("install_jenkins.sh")

  associate_public_ip_address = true
  tags = {
    Name = "Jenkins-Instance"
  }
}

resource "aws_security_group" "allow_ssh_jenkins" {
  name        = "allow_ssh_jenkins"
  description = "Allow SSH and Jenkins inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

output "jenkins_ip_address" {
  value = aws_instance.jenkins_instance.public_dns
}