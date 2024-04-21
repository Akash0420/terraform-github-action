terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "cloud-shell-storage-centralindia"
    storage_account_name = "csg10032003730c9146"
    container_name       = "tfstate"
    key                  = "demo.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "resgrp" {
  name     = "bugsrepro-uploadfile"
  location = "WestUS2"
}

resource "azurerm_storage_account" "storageaccount" {
  name                     = "uploadfileblob2storage"
  resource_group_name      = "${azurerm_resource_group.resgrp.name}"
  location                 = "${azurerm_resource_group.resgrp.location}"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_storage_container" "blobstorage" {
  name                  = "bugsrepro-uploadfileblob-container"
  #resource_group_name   = "${azurerm_resource_group.resgrp.name}"
  storage_account_name  = "${azurerm_storage_account.storageaccount.name}"
  container_access_type = "blob"
}

resource "azurerm_storage_blob" "blobobject" {
  #depends_on             = ["azurerm_storage_container.blobstorage"]
  name                   = "index.html"
 # resource_group_name    = "${azurerm_resource_group.resgrp.name}"
  storage_account_name   = "${azurerm_storage_account.storageaccount.name}"
  storage_container_name = "${azurerm_storage_container.blobstorage.name}"
  type                   = "block"
  source                 = "index.html"
}

output "url" {
  value = "http://${azurerm_storage_account.storageaccount.name}.blob.core.windows.net/${azurerm_storage_container.blobstorage.name}/index.html"
}