# k3s

Provides the primary compute mechanism for my home cluster.

This is currently a mix of `amd64` and `arm64` machines that I had around the house.

```
cd compute/k3s

terraform init

terraform plan

terraform apply --auto-approve
terraform destroy --auto-approve
```
