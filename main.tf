provider "aws" {
  region  = "us-east-1"
  profile = "arkose-development"
}

resource "aws_instance" "example" {
  ami           = "ami-40d28157"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.instance.id ]

  user_data = <<-EOF
            #!/bin/bash
            echo "Hello, world" > index.html
            nohup busybox httpd -f -p 8080 &
            EOF

  tags = {
    "Name" = "nicks-terraform-example"
  }
}

resource "aws_security_group" "instance" {
  name = "nicks-terraform-example-instance"

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks=["0.0.0.0/0"]
  }
}