variable "v_fdname" {
  type = string

}
variable "v_resource_group_name" {
  type = string

}
variable "v_load_enabled" {
  type = bool

}
variable "v_enforce_certificate_check" {
  type = bool
}
### Front Door's rules
variable "v_routing_rule" {
  type = map

}

### Front Door's frontend variables
variable "v_fe_endpoints" {
  type = map(any)
}
variable "v_kv_id" {
  type = string
}

variable "v_env_ref" {
  type = string
}


### Front Door's backend variables
variable "v_bk_pool" {
  type        = map(any)
  description = "(Required) Name of Front Door's Backend pool"
}

variable "v_bk_load_balancing" {
  type        = map(any)
  description = "Load Balancing name"
  
}
variable "v_bk_health_probe" {
  type        = map(any)
  description = "required"
}
