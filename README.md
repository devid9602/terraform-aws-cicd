# AWS Network and EC2 Terraform Lab

Despite the repository name, the current Terraform configuration is a small AWS networking and EC2 lab. It creates a VPC with one public and one private subnet, security-group rules, and one EC2 instance in each subnet. GitHub Actions workflows are also included for Terraform plan/apply and destroy.

## Infrastructure in the current configuration

- VPC CIDR: `10.0.0.0/16`
- Public subnet: `10.0.1.0/24`, with a route through an Internet Gateway.
- Private subnet: `10.0.2.0/24`, with no NAT route configured.
- Security group: inbound TCP ports 22, 80, 443, and 3000 from `0.0.0.0/0`.
- EC2: one public and one private instance; the root configuration uses hard-coded AMI IDs, and the EC2 module uses the key pair name `him`.
- Outputs: public instance IP and private instance ID.

The code is split across the local Terraform modules `vpc/`, `security/`, and `ec2/`.

## Requirements

- Terraform installed locally.
- AWS credentials configured for an account where you are authorized to create these resources.
- An existing EC2 key pair and AMI IDs that are valid for the target region.

Review and replace the hard-coded AMI IDs and key pair name before planning. Initialize and inspect the proposed changes:

```sh
terraform init
terraform validate
terraform plan
```

Only apply after reviewing the plan and confirming the account, region, networking, access rules, and expected cost.

## GitHub Actions workflows

- `.github/workflows/terraform.yml` runs on a self-hosted runner. It plans on pushes and pull requests and automatically applies on pushes to `main`.
- `.github/workflows/tfdestroy.yml` is manually triggered and runs Terraform destroy.

These workflows need review before use. The apply workflow can create billable resources automatically after a push. The destroy workflow contains a machine-specific working directory and expects AWS credentials as repository secrets. Use an isolated account, least-privilege credentials, protected environments, and a plan/approval gate before enabling automated changes.

## Important security limitations

This is an educational starting point, not a production-ready network design. In particular, SSH is allowed from every IPv4 address, the security group also exposes ports 80, 443, and 3000 globally, and the private subnet has no NAT route for outbound access. Restrict ingress to trusted CIDRs, configure private-subnet egress intentionally, and remove hard-coded environment-specific values before deploying. Do not use the checked-in defaults for a production workload.
