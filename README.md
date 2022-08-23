# proton-terraform-s3-bucket-environments

Deploys Proton environments using GitHub Actions and Terraform Cloud and stores versioned Terraform templates.


## Usage

1. Provision GitHub / AWS integration:

Edit [terraform.tfvars](./setup/terraform.tfvars) and set your github org and names

```hcl
namespace   = "proton-terraform-s3-bucket"
github_org  = "xyz"
github_repo = "proton-terraform-s3-bucket-environments"
```

Provision the cloud resources

```sh
cd setup
terraform init && terraform apply
```

2. Take the newly provisioned role arn from step 1 and add it to the [GitHub Action configuration](./.github/workflows/proton.yml). Be sure to change the account number.

```yaml
  ROLE_TO_ASSUME: arn:aws:iam::123456789012:role/proton-terraform-s3-bucket
```

3. Add your Terraform Cloud organization to the [GitHub Action configuration](./.github/workflows/proton.yml)

```yaml
env:
  TF_ORG: my-org
```

4. Add your Terraform Cloud User API Token as a GitHub Action secret named `TF_TOKEN_app_terraform_io`


Your final configuration section should looks something like this

```yaml
env:
  TF_ORG: xyz
  TF_TOKEN_app_terraform_io: ${{ secrets.TF_TOKEN_app_terraform_io }}
  ROLE_TO_ASSUME: arn:aws:iam::123456789012:role/proton-terraform-s3-bucket
```
