# initial-infrastructure

Before actually creating real infrastructure automatically, we need to set up some things for the CI/CD tool (GitHub
Actions/GitLab CI/whatever) to use when running Terraform, or any other Google API calls.  
This means we need to:

- Create a GCP Project to create this infrastructure in.
- Enable some initial APIs.
- Create a Service Account for CI/CD to use.
- Create a Workload Identity Federation for our CI/CD tool to authenticate with GCP.
- Give IAM permissions to the Service Account.
- Create a Storage bucket for Terraform to store state in.

The `src` directory is where we make this happen, as is intended to be run locally against Google Cloud.

Requirements to run:

- Be a Google Cloud Organisation Admin for `harmelodic.com`
- Google Cloud SDK installed
- `gcloud auth login`
- `gcloud auth application-default login`
- Terraform installed

Run:

```shell
terraform -chdir=src init
terraform -chdir=src apply
```
