# Ops

Ops code for personal projects

## Getting Started

Before actually creating real infrastructure automatically, we need to create a Service Account for Terraform to use, as well as a Storage bucket for Terraform to store state in.

The `getting-started` directory is where we make this happen, as is intended to be run locally against Google Cloud.

Requirements to run:
- Google Cloud Organisation Admin
- Google Cloud SDK installed
- Create Application Default Credentials - `gcloud auth application-default login`

## Infrastructure

Inside the `infrastructure` directory is where the central infrastructure is defined for personal projects. For example:

- Enabling of Cloud APIs
- Kubernetes Cluster & Node pool
- Central Database for re-use

This is run in a CI/CD pipeline, using the Storage bucket and Service Account created in the [Getting Started](#Getting_Started) section.
