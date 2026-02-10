#!/bin/bash

# Since the terraform state for this repo is handled locally, re-importing may be necessary in case of state data loss.

billing_account_id=$1
organization_id=$2

if [ -z "$billing_account_id" ] || [ -z "$organization_id" ]; then
    echo "Please provide a billing account ID and an organization ID:"
    echo "$ ./import.sh 010101-F0FFF0-10XX01 123456789012"
    exit 1
fi

automation_project_suffix_result=220928
terraform import random_integer.automation_project_suffix "$automation_project_suffix_result,100000,999999"

automation_project_id="automation-$automation_project_suffix_result"

terraform import google_project.automation "$automation_project_id"

terraform import google_project_iam_audit_config.automation "$automation_project_id allServices"

terraform import 'google_project_service.automation_apis["cloudbilling.googleapis.com"]' "$automation_project_id/cloudbilling.googleapis.com"
terraform import 'google_project_service.automation_apis["cloudkms.googleapis.com"]' "$automation_project_id/cloudkms.googleapis.com"
terraform import 'google_project_service.automation_apis["cloudresourcemanager.googleapis.com"]' "$automation_project_id/cloudresourcemanager.googleapis.com"
terraform import 'google_project_service.automation_apis["iam.googleapis.com"]' "$automation_project_id/iam.googleapis.com"
terraform import 'google_project_service.automation_apis["iamcredentials.googleapis.com"]' "$automation_project_id/iamcredentials.googleapis.com"
terraform import 'google_project_service.automation_apis["serviceusage.googleapis.com"]' "$automation_project_id/serviceusage.googleapis.com"
terraform import 'google_project_service.automation_apis["storage.googleapis.com"]' "$automation_project_id/storage.googleapis.com"
terraform import 'google_project_service.automation_apis["sts.googleapis.com"]' "$automation_project_id/sts.googleapis.com"
terraform import 'google_project_service.automation_apis["container.googleapis.com"]' "$automation_project_id/container.googleapis.com"
terraform import 'google_project_service.automation_apis["servicenetworking.googleapis.com"]' "$automation_project_id/servicenetworking.googleapis.com"
terraform import 'google_project_service.automation_apis["sqladmin.googleapis.com"]' "$automation_project_id/sqladmin.googleapis.com"

automation_service_account_email="automation@$automation_project_id.iam.gserviceaccount.com"
terraform import google_service_account.automation "projects/$automation_project_id/serviceAccounts/$automation_service_account_email"

automation_project_number="401363556022"
workload_pool="github"
github_user="Harmelodic"
principal_workload_pool="principalSet://iam.googleapis.com/projects/$automation_project_number/locations/global/workloadIdentityPools/$workload_pool"

terraform import google_service_account_iam_member.automation_workload_identity_user "projects/$automation_project_id/serviceAccounts/$automation_service_account_email roles/iam.workloadIdentityUser $principal_workload_pool/attribute.owner_and_branch/Harmelodic::branch::refs/heads/main"
terraform import google_service_account_iam_member.automation_project_perms "projects/$automation_project_id/serviceAccounts/$automation_service_account_email roles/iam.serviceAccountViewer serviceAccount:$automation_service_account_email"

terraform_verifier_service_account_email="terraform-verifier@$automation_project_id.iam.gserviceaccount.com"
terraform import google_service_account.terraform_verifier "projects/$automation_project_id/serviceAccounts/$terraform_verifier_service_account_email"
terraform import google_service_account_iam_member.terraform_verifier_workload_identity_user "projects/$automation_project_id/serviceAccounts/$terraform_verifier_service_account_email roles/iam.workloadIdentityUser $principal_workload_pool/attribute.owner/$github_user"

location="europe-north1"
key_ring="automation"
key="terraform-state"
terraform import google_kms_key_ring.automation "projects/$automation_project_id/locations/$location/keyRings/$key_ring"
terraform import google_kms_crypto_key.terraform_state "projects/$automation_project_id/locations/$location/keyRings/$key_ring/cryptoKeys/$key"
terraform import google_kms_crypto_key_iam_binding.terraform_state "$automation_project_id/$location/$key_ring/$key roles/cloudkms.cryptoKeyEncrypterDecrypter"

bucket="harmelodic-tfstate"
terraform import google_storage_bucket.terraform_state "$automation_project_id/$bucket"
terraform import google_storage_bucket_iam_member.automation_terraform_state_perms "b/$bucket roles/storage.admin serviceAccount:$automation_service_account_email"
terraform import google_storage_bucket_iam_member.terraform_verifier_terraform_state_perms "b/$bucket roles/storage.objectUser serviceAccount:$terraform_verifier_service_account_email"

workload_pool_provider="github-oidc"

terraform import google_iam_workload_identity_pool.github "projects/$automation_project_id/locations/global/workloadIdentityPools/$workload_pool"
terraform import google_iam_workload_identity_pool_provider.automation_github "projects/$automation_project_id/locations/global/workloadIdentityPools/$workload_pool/providers/$workload_pool_provider"

terraform import 'google_billing_account_iam_member.automation_billing_perms["roles/billing.user"]' "$billing_account_id roles/billing.user serviceAccount:$automation_service_account_email"
terraform import 'google_billing_account_iam_member.automation_billing_perms["roles/billing.viewer"]' "$billing_account_id roles/billing.viewer serviceAccount:$automation_service_account_email"

terraform import 'google_organization_iam_member.automation_organisation_perms["roles/resourcemanager.folderAdmin"]' "$organization_id roles/resourcemanager.folderAdmin serviceAccount:$automation_service_account_email"
terraform import 'google_organization_iam_member.automation_organisation_perms["roles/resourcemanager.organizationViewer"]' "$organization_id roles/resourcemanager.organizationViewer serviceAccount:$automation_service_account_email"
terraform import 'google_organization_iam_member.automation_organisation_perms["roles/resourcemanager.projectCreator"]' "$organization_id roles/resourcemanager.projectCreator serviceAccount:$automation_service_account_email"
