##############
##Azure# Cloud
##############
provider "azurerm" {
  version = "1.43.0"
}

################
##Azure Resource
################
resource "azure_virtual_network" "default" {
  name                 = "test-network"
  address_space        = ["10.1.2.0/24"]
  location             = "West US"
  resource_group_name  = ""

  subnet {
    name           = "subnet1"
    address_prefix = "10.1.2.0/25"
  }
}

resource "azure_security_group_rule" "ssh_access" {
  name                       = "ssh-access-rule"
  security_group_names       = ["${azure_security_group.web.name}", "${azure_security_group.apps.name}"]
  type                       = "Inbound"
  action                     = "Allow"
  priority                   = 200
  source_address_prefix      = "100.0.0.0/32"
  source_port_range          = "*"
  destination_address_prefix = "10.0.0.0/32"
  destination_port_range     = "22"
  protocol                   = "TCP"
}

#resource "azure_hosted_service" "terraform-service" {
#  name               = "terraform-service"
#  location           = "North Europe"
#  ephemeral_contents = false
#  description        = "Hosted service created by Terraform."
#  label              = "tf-hs-01"
#}

resource "azure_instance" "web" {
  name                 = "terraform-test"
  hosted_service_name  = "${azure_hosted_service.terraform-service.name}"
  image                = "Ubuntu Server 14.04 LTS"
  size                 = "Basic_A1"
  storage_service_name = "yourstorage"
  location             = "West US"
  username             = "terraform"
  password             = "Pass!admin123"
  domain_name          = "contoso.com"
  domain_ou            = "OU=Servers,DC=contoso.com,DC=Contoso,DC=com"
  domain_username      = "Administrator"
  domain_password      = "Pa$$word123"

  endpoint {
    name         = "SSH"
    protocol     = "tcp"
    public_port  = 22
    private_port = 22
  }
}

resource "azure_sql_database_server" "sql-serv" {
  name     = "<computed>"
  location = "West US"
  username = "SuperUser"
  password = "SuperSEKR3T"
  version  = "2.0"
  url      = "<computed>"
}

resource "azure_sql_database_server_firewall_rule" "constraint" {
  name     = "terraform-testing-rule"
  start_ip = "154.0.0.0"
  end_ip   = "154.0.0.255"

  database_server_names = [
    "${azure_sql_database_server.sql-serv1.name}",
    "${azure_sql_database_server.sql-serv2.name}",
  ]
}

resource "azure_sql_database_service" "sql-server" {
  name                 = "terraform-testing-db-renamed"
  database_server_name = "flibberflabber"
  edition              = "Standard"
  collation            = "SQL_Latin1_General_CP1_CI_AS"
  max_size_bytes       = "5368709120"
  service_level_id     = "f1173c43-91bd-4aaa-973c-54e79e15235b"
}
