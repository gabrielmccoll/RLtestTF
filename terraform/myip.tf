data "http" "myip" {
  url = "http://icanhazip.com"
}

output "my_terraform_environmnet_public_ip" {
  value = chomp(data.http.myip.response_body)
}