
output "company_name" {
  value = local.baseref["company_name"]  
}

### common variables ###
output "environment" {
  value = local.environment
}
output "resource_group_name" {
  value = local.workspace["resource_group_name"]
}
output "location" {
  value = local.workspace["location"]
}
output "env_ref" {
  value = local.workspace["env_ref"]
}

output "frondoor_name" {
  value = local.workspace["frondoor_name"]
}

output "host_name" {
  value = local.workspace["host_name"]
}

output "load_balancing_name" {
  value = local.workspace["load_balancing_name"]
}

output "health_probe_name" {
  value = local.workspace["health_probe_name"]
}
