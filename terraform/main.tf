terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.37.1"
    }
#     azurerm = {
#       source = "hashicorp/azurerm"
#       version = "3.53.0"
#     }
  }
}

provider "azuread" {
}
provider "azurerm" {
  features {}
}
data "azuread_client_config" "current" {}
# data "azurerm_client_config" "current" {}
data "azuread_application_template" "dbx" {
  display_name = "Azure Databricks SCIM Provisioning Connector"
}

resource "azuread_application" "scim" {
  display_name = "scim-dbx"
  template_id  = data.azuread_application_template.dbx.template_id
#   owners = [ data.azuread_client_config.current.object_id ]
  app_role {
    allowed_member_types = [ "User" ]
    description = "Users/Groups Permission"
    display_name = "User"
    enabled = true
    id = data.azuread_client_config.current.object_id
    value = "User.Write"
  }
  feature_tags {
    enterprise = true
    gallery    = true
  }
}

# resource "azuread_service_principal" "test" {
#   application_id = azuread_application.scim.application_id
#   use_existing   = true
# }

# resource "azuread_synchronization_secret" "example" {
#   service_principal_id = azuread_service_principal.test.application_id

#   credential {
#     key   = "BaseAddress"
#     value = "https://adb-2923826945884909.9.azuredatabricks.net/api/2.0/preview/scim"
#   }
#   credential {
#     key   = "SecretToken"
#     value = "dapi8f26127c0ee5b2f1289b2b41dd7764df-3"
#   }
# }

# resource "azuread_synchronization_job" "sync" {
#   service_principal_id = azuread_service_principal.test.id
#   template_id          = "dataBricks"
#   enabled              = true
# }
