variable "v_secrets" {
  type = map
}
locals {
    env = {
        root = {
 
            company_name                = "cloudzilla"
            resource_group_name         = "Root"
            location                    = "brazilsouth"
            env_ref                     = "root"
            #Front-Door's base environment
            frondoor_name       = "frontdoor-root-cloudzilla"
            host_name           = "frontdoor-root-cloudzilla.azurefd.net"
            load_balancing_name = "frontdoor-load-balance"
            health_probe_name   = "frontdoor-health-probe"
           
        }     
        dev = {

            company_name                = "cloudzilla"
            resource_group_name         = "Development"
            location                    = "brazilsouth"
            env_ref                     = "dev"
            #Front-Door's development environment
            frondoor_name       = "frontdoor-dev-cloudzilla"
            host_name           = "frontdoor-dev-cloudzilla.azurefd.net"
            load_balancing_name = "frontdoor-load-balance"
            health_probe_name   = "frontdoor-health-probe"

        }      
        hmg = {
            company_name                = "cloudzilla"
            resource_group_name         = "Homolog"
            location                    = "brazilsouth"
            env_ref                     = "hmg"
            #Front-Door's homolog environment            
            frondoor_name       = "frontdoor-hmg-cloudzilla"
            host_name           = "frontdoor-hmg-cloudzilla.azurefd.net"
            load_balancing_name = "frontdoor-load-balance"
            health_probe_name   = "frontdoor-health-probe"

        }  
        prd = {
            company_name                = "cloudzilla"
            resource_group_name         = "Production"
            location                    = "brazilsouth"
            env_ref                     = "prd"
            #Front-Door's production environment            
            frondoor_name       = "frontdoor-prd-cloudzilla"
            host_name           = "frontdoor-prd-cloudzilla.azurefd.net"
            load_balancing_name = "frontdoor-load-balance"
            health_probe_name   = "frontdoor-health-probe"

        }
    }
}
locals {
    baseref         = local.env["root"]
    environment     = "${replace(terraform.workspace, "/.*-/", "")}"
    workspace       = "${merge(local.baseref, local.envref)}"
}
