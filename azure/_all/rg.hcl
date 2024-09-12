locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl")).locals
  region_vars       = read_terragrunt_config(find_in_parent_folders("region.hcl")).locals
  application_vars  = read_terragrunt_config(find_in_parent_folders("application.hcl")).locals
  lookup            = read_terragrunt_config(find_in_parent_folders("lookups.hcl")).locals

  stripped_application_name = replace(local.application_vars.name, "-", "")
}

inputs = {
  rg_name = "rg-agw-${local.environment_vars.environment}-we"
}