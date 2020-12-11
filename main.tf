provider "aws" {
    region = "us-east-1"
    profile = "arkose-development"
}

resource "aws_instance" "example" {
  ami = "ami-40d28157"
  instance_type = "t2.micro"

  tags = {
    "Name" = "nicks-terraform-example"
  }
}