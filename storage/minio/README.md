# minio

Provides an erasure-coded small-blob store backed by MinIO.

Deploys a single node on top of the Apple Mini, currently backed by two physical drives. I'll likely add more drives 

```
cd storage/minio

terraform init

terraform plan

terraform apply --auto-approve
terraform destroy --auto-approve
```
