resource "aci_rest" "trigSchedP" {
  dn         = "uni/fabric/schedp-${var.name}"
  class_name = "trigSchedP"
  content = {
    name  = var.name
    descr = var.description
  }
}

resource "aci_rest" "trigRecurrWindowP" {
  for_each   = { for win in var.recurring_windows : win.name => win }
  dn         = "${aci_rest.trigSchedP.id}/recurrwinp-${each.value.name}"
  class_name = "trigRecurrWindowP"
  content = {
    name   = each.value.name
    day    = each.value.day != null ? each.value.day : "every-day"
    hour   = each.value.hour != null ? each.value.hour : 0
    minute = each.value.minute != null ? each.value.minute : 0
  }
}
