terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "netascode/aci"
      version = ">=0.2.0"
    }
  }
}

module "main" {
  source = "../.."

  name = "SCHED1"
}

data "aci_rest" "trigSchedP" {
  dn = "uni/fabric/schedp-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "trigSchedP" {
  component = "trigSchedP"

  equal "name" {
    description = "name"
    got         = data.aci_rest.trigSchedP.content.name
    want        = module.main.name
  }
}
