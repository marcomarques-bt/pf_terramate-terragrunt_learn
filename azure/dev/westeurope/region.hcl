locals {
  lookups    = read_terragrunt_config(find_in_parent_folders("lookups.hcl")).locals
  region     = "${basename(get_terragrunt_dir())}"
  short_name = local.lookups.short_region[local.region]
}

