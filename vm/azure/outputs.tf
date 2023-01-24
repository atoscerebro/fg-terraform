output "admin_private_key" {
  value = (
    var.output_admin_private_key ?
    tls_private_key.vm_private_key.private_key_pem :
    null
  )
  sensitive = true
}
