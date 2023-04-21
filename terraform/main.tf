terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.37.1"
    }
  }
}

provider "azuread" {
}
data "azuread_client_config" "current" {}

data "azuread_application_template" "dbx" {
  display_name = "Azure Databricks SCIM Provisioning Connector"
}

resource "azuread_application" "scim" {
  display_name = "scim-connector"
  template_id  = data.azuread_application_template.dbx.template_id
  
  app_role {
    allowed_member_types = [ "User" ]
    description = "Users/Groups Permission"
    display_name = "User"
    enabled = true
    id = data.azuread_client_config.current.object_id
    value = "User.Read"
  }
  feature_tags {
    enterprise = true
    gallery    = true
  }
}
