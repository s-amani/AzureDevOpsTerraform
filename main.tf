provider "azurerm" {
  features {
    
  }
}
terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "=3.0.0"
    }
  }
  backend "azurerm" {
    resource_group_name     = "tf_rg_blob_storage"
    storage_account_name    = "tfstorageaccountsaber"
    container_name          = "tfstate"
    key                     = "terraform.tfstate"
  }
}

variable "imagebuild" {
  type                  = string
  description           = "Latest Image Build"
}

resource "azurerm_resource_group" "tf_test" {
  name                  = "tfmainrg"
  location              = "UK South"
}

resource "azurerm_container_group" "tfcg_test" {
  name                  = "weatherapi"
  location              = azurerm_resource_group.tf_test.location
  resource_group_name   = azurerm_resource_group.tf_test.name

  ip_address_type       = "Public"
  dns_name_label        = "saberamaniwa"
  os_type               = "Linux"

  container {
    name                = "weatherapi"
    image               = "saberamani/weatherapi:${var.imagebuild}"
    cpu                 = "1"
    memory              = "1"

    ports {
      port              = 80
      protocol          = "TCP"
    }

  }
}