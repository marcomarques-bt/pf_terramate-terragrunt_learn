locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl")).locals
  region_vars       = read_terragrunt_config(find_in_parent_folders("region.hcl")).locals
  application_vars  = read_terragrunt_config(find_in_parent_folders("application.hcl")).locals
  lookup            = read_terragrunt_config(find_in_parent_folders("lookups.hcl")).locals

  stripped_application_name = replace(local.application_vars.name, "-", "")
}

generate "provider.extra" {
  path      = "provider.extra.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "azapi" {
  use_oidc = true
}
EOF
}

inputs = {
  account_replication_type      = "LRS"
  account_tier                  = "Standard"
  account_kind                  = "StorageV2"
  location                      = local.region_vars.region
  name                          = "sa${local.stripped_application_name}${local.region_vars.short_name}${local.environment_vars.environment}"
  https_traffic_only_enabled    = true
  resource_group_name           = "rg-${local.application_vars.name}-${local.environment_vars.environment}"
  min_tls_version               = "TLS1_2"
  shared_access_key_enabled     = true
  public_network_access_enabled = true
  enable_telemetry              = false

  managed_identities = {
    system_assigned            = true
  }

  blob_properties = {
    versioning_enabled = true
  }

  network_rules = {
    bypass                     = ["AzureServices"]
    default_action             = "Allow"
  }

  shares = {
    otel-config = {
      name  = "otel-config"
      quota = 1
    }
  }
}
