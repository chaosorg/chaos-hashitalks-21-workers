resource "aws_key_pair" "worker_key" {
  key_name   = "worker-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDlTHEu4QU2AUEQM/mF4OzLBdGFVUUvZxJu951g2tew4u3JCsRVvIQQ6FtpsR1O4TIi370hhWT4TqwTiiWCqIjHfpdfPXrQ011CuWQ7M83aozZsRq5Oi4KG9K/qHvxQPKKGfkRgRzaqfqm5JNt4Q0Nnn7Wxu4kqnrFM1eyGda/cTN+/ric+1hXi/6EZgpf2vpyi3w2Rj/Aa46zrZCcNRjaR8fCR0JlREXITx8YUNDqWI4jGGl7ulXmWTGuK7yhc7+aJRu7bF4l8lF28b9puzg7RPse/DplxjYaguXv6h3+76fconzrYeZLWwGz2aHEOsKd2YpaMR/2Jjv1iVgsSDA4l jhonnatan.gil@ip-10-230-6-117.us-east-2.compute.internal"
}


resource "aws_security_group" "security_group" {
  name   = "worker-sg"
  vpc_id = data.aws_vpc.vpc_account.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["186.86.34.5/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "worker_node1" {
  ami                         = "ami-0e999cbd62129e3b1"
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnet.subnet_az2.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.worker_key.key_name
  security_groups             = [aws_security_group.security_group.id]
  user_data                   = filebase64("install_worker.sh")


  tags = {
    k8stype = "woker-k8s"
    owner   = "chaos"
    Name    = "worker1"
  }
}