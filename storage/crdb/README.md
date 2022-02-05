# crdb

Provides a primary storage mechanism for my homelab.

Deploys a 3 node CockroachDB cluster on top of Raspberry Pi 4 nodes. The cluster is run from within a container, making 
it easy to introspect from my laptop. This is managed using terraform as it provides a convenient way to bring up and 
tear down the entire cluster. My home systems can tolerate a little downtime for maintenance. 

```
cd storage/crdb

terraform init

terraform plan

terraform apply --auto-approve
terraform destroy --auto-approve
```
