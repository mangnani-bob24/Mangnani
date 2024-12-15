output "api_gateway_url" {
  value = aws_api_gateway_deployment.api.invoke_url
}

output "ec2_instance_id" {
  value = aws_instance.ctf_instance.id
}