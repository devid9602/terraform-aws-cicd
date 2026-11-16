variable "vpc_id" {}

variable "ssh_allowed_cidrs" {
  description = "IPv4 CIDRs allowed to connect to the public instance over SSH. Empty disables SSH ingress."
  type        = list(string)
  default     = []
}
