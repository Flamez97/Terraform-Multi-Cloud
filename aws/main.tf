#####
##AWS
#####
provider "aws" {
  region     = var.aws_region
}

############
#----vpc----
############
#resource "aws_vpc" "test" {
#  name         = var.vpc_name
#  }
#}
#################
#----Instance----
#################

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

############
#----RDS----
############

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 2.0"

  identifier = "oradev1"

  engine            = "oracle-ee"
  engine_version    = "12.2.0.1.ru-2020-01.rur-2020-01.r1"
  instance_class    = "db.r5.large"
  allocated_storage = 20
  storage_encrypted = true
  license_model     = "bring-your-own-license"

  # Make sure that database name is capitalized, otherwise RDS will try to recreate RDS instance every time
  name                                = var.db_name
  username                            = var.db_user
  password                            = var.db_password
  port                                = "1525"
  iam_database_authentication_enabled = false

  vpc_security_group_ids = ["${data.aws_security_group.default.id}"]
  maintenance_window     = "Mon:00:00-Mon:03:00"
  backup_window          = "03:00-06:00"

  # disable backups to create DB faster
  backup_retention_period = 14

  tags = {
    "System Owner" = var.user_owner
    Environment = var.env
    Domain = var.domain
    Purpose = "RDS DEV"
  }

  # DB subnet group
subnet_ids = ["${var.subnet_id1}", "${var.subnet_id2}"]

  # DB parameter group
  family = "oracle-ee-12.2"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "oradev1"

  # Database Character Set
  character_set_name = var.character

  # Database Deletion Protection
  deletion_protection = true
}
