!!! NOT ACTUALLY v0.7.x YET !!!

Terraform Remote Config Infrastructure
---------------------------

#### Manual deployment steps (until jenkins server is setup)

Remote config:
```bash
# If you choose to use remote config
rm -v ./*.tfstate* ./.terraform/*.tfstate*
terraform remote config -backend=s3 -backend-config="bucket=forge-dev" -backend-config="key=terraform.tfstate" -backend-config="encrypt=true" -backend-config="region=us-west-1"
```

Terraform plan:
```bash
terraform plan -var-file=./tfvars/forge-dev.tfvars -out=create.tfplan
```

Terraform apply:
```bash
terraform apply deploy.tfplan
```

Terraform destroy:
```bash
terraform plan -destroy -var-file=./tfvars/forge-dev.tfvars -out=destroy.tfplan
### double check the plan results before applying a destroy!
terraform apply destroy.tfplan
```

Disable remote config:
```bash
terraform remote config -disable
rm -v ./*.tfstate* ./.terraform/*.tfstate*
```
