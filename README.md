# Ops

Ops code for personal projects

## Init Infrastructure

Before actually creating real infrastructure automatically, we need to set up some things for the CICD tool (GitHub Actions/GitLab CI/whatever) to use when running Terraform, or any other Google API calls.  
This means we need to:

- Create a GCP Project to create this infrastructure in.
- Enable some initial APIs.
- Create a Service Account for CICD to use.
- Create a Workload Identity Federation for our CICD tool to authenticate with GCP.
- Give IAM permissions to the Service Account.
- Create a Storage bucket for Terraform to store state in.

The `init-infrastructure` directory is where we make this happen, as is intended to be run locally against Google Cloud.

Requirements to run:
- Be a Google Cloud Organisation Admin for `harmelodic.com`
- Google Cloud SDK installed
- `gcloud auth login`
- `gcloud auth application-default login`
- Terraform installed

## Infrastructure

Inside the `infrastructure` directory is where the central infrastructure is defined for personal projects. For example:

- Enabling of Cloud APIs
- Kubernetes Cluster & Node pool
- Central Database for re-use (since I'm too cheap to do proper microservice DB isolation)

This is run in a CI/CD pipeline, using the Storage bucket and Service Account created in the [Getting Started](#Getting_Started) section.
