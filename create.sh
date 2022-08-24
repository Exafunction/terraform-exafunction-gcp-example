#!/bin/bash
set -euxo pipefail

# Get directory of this script
ROOT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TERRAFORM_EXAFUNCTION_GCP_PREFIX="gcp"
TERRAFORM_EXAFUNCTION_KUBE_PREFIX="kube"

# Get shell variables from config.gcs.tfbackend
source $ROOT_DIR/config.gcs.tfbackend

# Apply remote-state Terraform module
cd $ROOT_DIR/remote-state
terraform init
terraform apply \
    -var-file=$ROOT_DIR/config.gcs.tfbackend \
    -var-file $ROOT_DIR/config.tfvars \
    -compact-warnings \
    -auto-approve

# Apply gcp Terraform module
cd $ROOT_DIR/gcp
terraform init \
    -backend-config=$ROOT_DIR/config.gcs.tfbackend \
    -backend-config="prefix=$TERRAFORM_EXAFUNCTION_GCP_PREFIX"
terraform apply \
    -var-file $ROOT_DIR/config.tfvars \
    -compact-warnings \
    -auto-approve

# Apply kube Terraform module
cd $ROOT_DIR/kube
terraform init \
    -backend-config=$ROOT_DIR/config.gcs.tfbackend \
    -backend-config="prefix=$TERRAFORM_EXAFUNCTION_KUBE_PREFIX"
terraform apply \
    -var-file $ROOT_DIR/config.tfvars \
    -var="values_file_path=$ROOT_DIR/values.yaml" \
    -var="remote_state_config={\"bucket\":\"$bucket\",\"prefix\":\"$TERRAFORM_EXAFUNCTION_GCP_PREFIX\"}" \
    -compact-warnings \
    -auto-approve
