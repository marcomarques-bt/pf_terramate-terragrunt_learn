locals {
  # Provider Versions
  versions = {
    terraform = "1.7.5"
    azurerm   = "3.112.0"
  }

  company        = "marcomarques"
  resource-owner = "marcopolo"
  rg_name        = "rg-terramate-marco"

  # AzureRM
  azurerm_tenant_id = "63cf25f8-c036-4f27-a8a2-348176eda41d"

  # Get the variables from the environment.hcl, region.hcl and application.hcl files deeper in the folder structure
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  application_vars = read_terragrunt_config(find_in_parent_folders("application.hcl"))

  environment = local.environment_vars.locals.environment
  region      = local.region_vars.locals.region
  application = local.application_vars.locals.name
}

generate "provider" {
  path      = "provider.azurerm.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = "${local.environment_vars.locals.subscription_id}"
  use_oidc        = true
}
EOF
}

remote_state {
  backend = "azurerm"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    tenant_id            = local.azurerm_tenant_id
    subscription_id      = local.environment_vars.locals.subscription_id
    resource_group_name  = "rg-terramate-marco"
    storage_account_name = "saterramatetest"
    container_name       = "terramate"
    key                  = "${path_relative_to_include()}/terraform.tfstate"

    use_oidc         = get_env("CI", false) # true in GH Workflows
    use_azuread_auth = !get_env("CI", false)
  }
}

inputs = merge(
  local.environment_vars.locals,
  local.region_vars.locals,
  {
    tags = {
      resource-owner = "${local.resource-owner}"
      environment    = "${local.environment}",
      location       = "${local.region}"
      application    = "${local.application}"
    },
    environment = "${local.environment}",
    location    = "${local.region}"
    rg_name     = "${local.rg_name}"
    application = "${local.application}",
    tenant_id   = local.azurerm_tenant_id
  }
)

