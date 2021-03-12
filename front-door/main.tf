data "azurerm_key_vault_certificate" "environment_cert" {
  name         = join("",[var.v_env_ref, "pfx"])
  key_vault_id = var.v_kv_id
}

resource "azurerm_frontdoor" "frontdoor" {
  name                                         = var.v_fdname
  #location                                     = "Global"
  resource_group_name                          = var.v_resource_group_name
  enforce_backend_pools_certificate_name_check = var.v_enforce_certificate_check
  load_balancer_enabled                        = var.v_load_enabled


  dynamic "backend_pool_load_balancing" {
    for_each = var.v_bk_load_balancing
    content {
      name                            = backend_pool_load_balancing.value.name
      sample_size                     = backend_pool_load_balancing.value.sample_size 
      successful_samples_required     = backend_pool_load_balancing.value.successful_samples_required
      additional_latency_milliseconds = backend_pool_load_balancing.value.additional_latency_milliseconds
    }
  }


  dynamic "routing_rule" {
    for_each = var.v_routing_rule
    content {
      name               = routing_rule.value.name
      accepted_protocols = routing_rule.value.accepted_protocols
      patterns_to_match  = routing_rule.value.patterns_to_match
      frontend_endpoints = [routing_rule.value.endpoint] #values({ for x, endpoint in var.v_fe_endpoints : x => endpoint.name })
      
      dynamic "forwarding_configuration" {
        for_each = routing_rule.value.configuration == "Forwarding" ? [routing_rule.value.forwarding_configuration]: []
        content {
          backend_pool_name                     = forwarding_configuration.value.backend_pool_name
          forwarding_protocol                   = forwarding_configuration.value.forwarding_protocol
        }
      }
    dynamic "redirect_configuration"{
      for_each = routing_rule.value.configuration=="Redirecting" ? [routing_rule.value.redirect_configuration]:[]
      content{

          custom_host                         = forwarding_configuration.value.custom_host
          redirect_protocol                   = forwarding_configuration.value.redirect_protocol
          redirect_type                       = forwarding_configuration.value.redirect_type

      }
    }
   
   }
  }

  dynamic "backend_pool_health_probe" {
    for_each = var.v_bk_health_probe
    content {
      name                = backend_pool_health_probe.value.name
      enabled             = backend_pool_health_probe.value.enabled
      path                = backend_pool_health_probe.value.path
      protocol            = backend_pool_health_probe.value.protocol
      probe_method        = backend_pool_health_probe.value.probe
      interval_in_seconds = backend_pool_health_probe.value.interval
    }
  }

  dynamic "backend_pool" {
    for_each = var.v_bk_pool
    content {
      name                = backend_pool.value.name
      load_balancing_name = backend_pool.value.loadbalancing_name
      health_probe_name   = backend_pool.value.health_probe_name
      dynamic "backend" {
        for_each = backend_pool.value.backend
        content {
          enabled     = backend.value.enabled
          address     = backend.value.address
          host_header = backend.value.host_header
          http_port   = backend.value.http_port
          https_port  = backend.value.https_port

        }
      }
    }
  }

  dynamic "frontend_endpoint" {
    for_each = var.v_fe_endpoints
    content {
      name                              = frontend_endpoint.value.name
      host_name                         = frontend_endpoint.value.host_name
      custom_https_provisioning_enabled = frontend_endpoint.value.custom_https
      dynamic "custom_https_configuration" {
        for_each = try(frontend_endpoint.value.custom_https, false) == true ? [frontend_endpoint.value.custom_https_configuration]:[]
        content {
          certificate_source                         =  frontend_endpoint.value.custom_https_configuration.certificate_source
          azure_key_vault_certificate_vault_id       =  var.v_kv_id #frontend_endpoint.value.custom_https_configuration.azure_key_vault_certificate_vault_id 
          azure_key_vault_certificate_secret_name    =  frontend_endpoint.value.custom_https_configuration.azure_key_vault_certificate_secret_name != null ? frontend_endpoint.value.custom_https_configuration.azure_key_vault_certificate_secret_name : data.azurerm_key_vault_certificate.environment_cert.name #frontend_endpoint.value.custom_https_configuration.azure_key_vault_certificate_secret_name
          azure_key_vault_certificate_secret_version =  frontend_endpoint.value.custom_https_configuration.azure_key_vault_certificate_secret_version != null ? frontend_endpoint.value.custom_https_configuration.azure_key_vault_certificate_secret_version : data.azurerm_key_vault_certificate.environment_cert.version #frontend_endpoint.value.custom_https_configuration.azure_key_vault_certificate_secret_version 
        }
        
      }
    }
  }


  lifecycle {
      ignore_changes = all
  }

}