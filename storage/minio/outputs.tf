output "user" {
  value = random_string.user.result
  sensitive = true
}

output "password" {
  value = random_password.password.result
  sensitive = true
}
