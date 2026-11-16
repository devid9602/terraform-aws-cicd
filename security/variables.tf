variable "vpc_id" {}

variable "ssh_allowed_cidrs" {
  description = "IPv4 CIDRs allowed to connect to the public instance over SSH. Empty disables SSH ingress."
  type        = list(string)
  default     = []
}

variable "service_3000_allowed_cidrs" {
  description = "IPv4 CIDRs allowed to connect to the example service on port 3000. Empty disables this ingress."
  type        = list(string)
  default     = []
}
