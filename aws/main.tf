#----vpc----

provider "aws" {
  region     = var.aws_region
}

##Linux
resource "aws_instance" "test" {
  instance_type                = "t2.micro"
  ami                          = "ami-0323c3dd2da7fb37d"
  key_name                     = "fire97"
  subnet_id                    = aws_subnet.test-public.id
  monitoring                   = true
  associate_public_ip_address  = true
  tags = {
    Name = "test linux"
  }
}

## Windows
resource "aws_instance" "test2" {
  instance_type                = "t2.micro"
  ami                          = "ami-09d496c26aa745869"
  key_name                     = "fire97"
  subnet_id                    = aws_subnet.test-public.id
  monitoring                   = true
  associate_public_ip_address  = true
  tags = {
    Name = "test windows"
  }
}
