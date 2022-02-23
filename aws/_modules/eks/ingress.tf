resource "aws_route53_zone" "current" {
  count = var.disable_default_ingress ? 0 : 1

  name = "${var.metadata_fqdn}."
  tags = {
    yor_trace = "e2969893-64f2-4866-8f46-86775031efba"
  }
}
