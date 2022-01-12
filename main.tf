terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.59.0"
    }
  }
}

provider "aws" {
 
 region = var.region
 access_key= var.access_key
 secret_key= var.secret_key
 
}

#
# Self-Signed TLS Certificate for Testing
#

resource "tls_private_key" "example" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "example" {
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
  dns_names             = [var.rest_api_domain_name]
  key_algorithm         = tls_private_key.example.algorithm
  private_key_pem       = tls_private_key.example.private_key_pem
  validity_period_hours = 12

  subject {
    common_name  = var.rest_api_domain_name
    organization = "ACME Examples, Inc"
  }
}

resource "aws_acm_certificate" "example" {
  certificate_body = tls_self_signed_cert.example.cert_pem
  private_key      = tls_private_key.example.private_key_pem
}