output "dn" {
  value       = aci_rest.trigSchedP.id
  description = "Distinguished name of `trigSchedP` object."
}

output "name" {
  value       = aci_rest.trigSchedP.content.name
  description = "Fabric scheduler name."
}
