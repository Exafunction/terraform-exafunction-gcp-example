#!/bin/bash
set -euxo pipefail

# Get directory of this script
ROOT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
REMOTE_STATE_GCP_PREFIX="gcp"
REMOTE_STATE_KUBE_PREFIX="kube"

# Apply remote-state Terraform module
cd $ROOT_DIR/remote-state
terraform init \
    -reconfigure
terraform apply \
    -var-file $ROOT_DIR/config.tfvars \
    -compact-warnings \
    -auto-approve

# Get remote state output variables.
REMOTE_STATE_BUCKET=$(terraform output -raw bucket)

# Apply gcp Terraform module
cd $ROOT_DIR/gcp
terraform init \
    -backend-config="bucket=$REMOTE_STATE_BUCKET" \
    -backend-config="prefix=$REMOTE_STATE_GCP_PREFIX" \
    -reconfigure
terraform apply \
    -var-file $ROOT_DIR/config.tfvars \
    -compact-warnings \
    -auto-approve

# Apply kube Terraform module
cd $ROOT_DIR/kube
terraform init \
    -backend-config="bucket=$REMOTE_STATE_BUCKET" \
    -backend-config="prefix=$REMOTE_STATE_KUBE_PREFIX" \
    -reconfigure
terraform apply \
    -var-file $ROOT_DIR/config.tfvars \
    -var="values_file_path=$ROOT_DIR/values.yaml" \
    -var="remote_state_config={\"bucket\":\"$REMOTE_STATE_BUCKET\",\"prefix\":\"$REMOTE_STATE_GCP_PREFIX\"}" \
    -compact-warnings \
    -auto-approve
