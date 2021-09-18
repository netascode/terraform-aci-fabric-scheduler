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

  name        = "SCHED1"
  description = "My Description"
  recurring_windows = [{
    name   = "EVEN-DAY"
    day    = "even-day"
    hour   = 2
    minute = 10
  }]
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

  equal "descr" {
    description = "descr"
    got         = data.aci_rest.trigSchedP.content.descr
    want        = "My Description"
  }
}

data "aci_rest" "trigRecurrWindowP" {
  dn = "${data.aci_rest.trigSchedP.id}/recurrwinp-EVEN-DAY"

  depends_on = [module.main]
}

resource "test_assertions" "trigRecurrWindowP" {
  component = "trigRecurrWindowP"

  equal "name" {
    description = "name"
    got         = data.aci_rest.trigRecurrWindowP.content.name
    want        = "EVEN-DAY"
  }

  equal "day" {
    description = "day"
    got         = data.aci_rest.trigRecurrWindowP.content.day
    want        = "even-day"
  }

  equal "hour" {
    description = "hour"
    got         = data.aci_rest.trigRecurrWindowP.content.hour
    want        = "2"
  }

  equal "minute" {
    description = "minute"
    got         = data.aci_rest.trigRecurrWindowP.content.minute
    want        = "10"
  }
}
