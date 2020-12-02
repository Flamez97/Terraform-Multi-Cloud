#################################
##----root Multi Cloud module----
#################################
provider "aws" {
  region = "${var.aws_region}"
  alias  = "amazon"
}

provider "azurerm" {
  version = "=1.43.0"
  alias   = "microsoft"
}

provider "google" {
  credentials = file("peak.json")
  project     = "peak-hangout-267916"
  region      = "us-east1"
  alias       = "gcp"
}

# Deploy AWS Resources
module "AWS" {
  source       = "./storage"
  project_name = "${var.project_name}"
  provider     = "amazon"
}

# Deploy AZURE Resource
module "AZURE" {
  source       = "./AZURE"
  provider     = "microsoft"
}

#Deploy GCP Resource
module "GCP" {
  source       = "./GCP"
  provider     = "gcp"
}
