# AWS Network and EC2 Terraform Lab

Despite the repository name, this project is a small AWS networking and EC2 lab. It creates a VPC with one public and one private subnet, security-group rules, and one EC2 instance in each subnet.

## Infrastructure in the current configuration

- VPC CIDR: `10.0.0.0/16`.
- Public subnet: `10.0.1.0/24`, routed through an Internet Gateway.
- Private subnet: `10.0.2.0/24`, with no NAT route.
- Security group: TCP ports 80, 443, and 3000 are open to all IPv4 addresses. SSH (port 22) is disabled by default; set `ssh_allowed_cidrs` to trusted IPv4 CIDRs to enable it.
- EC2: one public and one private instance. The root configuration uses hard-coded AMI IDs, and the EC2 module uses the key pair name `him`.
- Outputs: the public instance IP and private instance ID.

The code is split across the local Terraform modules `vpc/`, `security/`, and `ec2/`.

## Requirements

- Terraform installed locally.
- AWS credentials configured for an account where you are authorized to create these resources.
- An existing EC2 key pair and AMI IDs valid for the target region.

Review and replace the hard-coded AMI IDs and key pair name before planning. Initialize and inspect the proposed changes:

```sh
terraform init
terraform validate
terraform plan
```

Only apply after reviewing the plan and confirming the account, region, networking, access rules, and expected cost. To enable SSH, supply a narrowly scoped `ssh_allowed_cidrs` value in a local `.tfvars` file; do not commit that file.

## GitHub Actions

- `.github/workflows/terraform.yml` runs formatting and validation on pull requests and pushes to `main` using a GitHub-hosted runner. It does not access AWS credentials or apply infrastructure.
- `.github/workflows/tfdestroy.yml` is manually triggered from `main`, runs on the configured self-hosted runner, and requires approval through the `terraform-destroy` environment before it can run. It still uses a machine-specific working directory and repository AWS credential secrets; do not dispatch it unless you have reviewed the target state and intended resources.

The automated apply was removed because this repository has no remote Terraform state backend; ephemeral CI runs cannot safely track resources between runs. Apply infrastructure locally only after reviewing a plan. A remote backend and a separately approved apply workflow would need to be designed before automation is restored.

## Security limitations

This is an educational starting point, not a production-ready network design. Ports 80, 443, and 3000 remain open to all IPv4 addresses, the private subnet has no NAT route, and the configuration contains environment-specific AMI IDs and a key pair name. Restrict ingress, configure private-subnet egress intentionally, and replace those values before deployment. Do not use the checked-in defaults for a production workload.
