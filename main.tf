provider "aws" {
  region  = "us-east-1"
  profile = "arkose-development"
}

resource "aws_launch_configuration" "example" {
  image_id                    = "ami-40d28157"
  instance_type          = "t2.micro"
  security_groups = [aws_security_group.instance.id]

  user_data = <<-EOF
            #!/bin/bash
            echo "Hello, world" > index.html
            nohup busybox httpd -f -p ${var.server_port} &
            EOF

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_availability_zones" "all" {

}
resource "aws_autoscaling_group" "asg-example" {
  launch_configuration = aws_launch_configuration.example.id
  availability_zones = data.aws_availability_zones.all.names

  min_size = 2
  max_size = 10

  tag {
    key                 = "Name"
    value               = "nicks-terraform-asg-example"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "instance" {
  name = "nicks-terraform-example-instance"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default     = 8080
}

# output "ip" {
#   value = aws_instance.example.public_ip
# }
