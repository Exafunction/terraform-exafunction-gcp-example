#!/bin/bash
set -euxo pipefail

# Note: this script will not work if any of these Terraform modules haven't been applied at all.

# Get directory of this script
ROOT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
REMOTE_STATE_GCP_PREFIX="gcp"
REMOTE_STATE_KUBE_PREFIX="kube"

# Get remote state output variables.
cd $ROOT_DIR/remote-state
REMOTE_STATE_BUCKET=$(terraform output -raw bucket)

# TODO(nick): add check for approval.

# Destroy kube Terraform module
cd $ROOT_DIR/kube
terraform init \
    -backend-config="bucket=$REMOTE_STATE_BUCKET" \
    -backend-config="prefix=$REMOTE_STATE_KUBE_PREFIX" \
    -reconfigure
terraform destroy \
    -var-file $ROOT_DIR/config.tfvars \
    -var="values_file_path=$ROOT_DIR/values.yaml" \
    -var="remote_state_config={\"bucket\":\"$REMOTE_STATE_BUCKET\",\"prefix\":\"$REMOTE_STATE_GCP_PREFIX\"}" \
    -compact-warnings \
    -auto-approve

# Destroy gcp Terraform module
cd $ROOT_DIR/gcp
terraform init \
    -backend-config="bucket=$REMOTE_STATE_BUCKET" \
    -backend-config="prefix=$REMOTE_STATE_GCP_PREFIX" \
    -reconfigure
terraform destroy \
    -var-file $ROOT_DIR/config.tfvars \
    -compact-warnings \
    -auto-approve

# Destroy remote-state Terraform module
cd $ROOT_DIR/remote-state
terraform init \
    -reconfigure
terraform destroy \
    -var-file $ROOT_DIR/config.tfvars \
    -compact-warnings \
    -auto-approve
