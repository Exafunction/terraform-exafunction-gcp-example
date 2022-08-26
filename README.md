# terraform-exafunction-gcp-example

## Overview
This repository acts as a quickstart to setup ExaDeploy for GCP. It is specifically designed for users that want to spin up an ExaDeploy system in a new GKE cluster and offload remote GPU computations from applications running in either existing GCP infrastructure (such as on GCE instances or in a different GKE cluster) or within the newly created GKE cluster.

This installation is responsible for creating a new VPC, new GKE cluster, ExaDeploy system in that cluster, and optional VPC peering mechanism (along with associated firewall rules) between an existing VPC and the newly created VPC.

Users should clone this repository locally and follow the steps below to setup ExaDeploy.

## Prerequisites
This repository is dependent on Terraform, Helm, kubectl, and GCloud CLI which can be installed according to these directions:
* [Terraform](https://www.terraform.io/downloads)
* [Helm](https://helm.sh/docs/intro/install/)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [GCloud CLI](https://cloud.google.com/sdk/docs/install)

After installation you should be able to run both `terraform`, `helm`, `kubectl`, and `gcloud` as commands in the command line (these commands will show documentation when run without arguments).

It also requires enabling the Service Networking API in GCP which can be done by following the instructions at [Getting Started with the Service Networking API ](https://cloud.google.com/service-infrastructure/docs/service-networking/getting-started#enabling_the_service).

## Configuration
There are a few configuration files that must be modified prior to running this installation. If you will be running applications in existing GCP infrastructure outside of the newly created GKE cluster, you will need to configure VPC peering (see below).

### [`config.tfvars`](/config.tfvars)
This file contains the configuration for the Terraform modules. Users should modify:
* `project`: The GCP project for the new VPC and GKE cluster.
    * If VPC peering, this should be the same project your existing VPC is in.
* `region`: The GCP region for the new VPC and GKE cluster.
    * If VPC peering, this should be the same region as your existing VPC to avoid cross-regional egress charges due to sending data between the VPCs.
* `vpc_ip_range_config`: The configuration for the new VPC to create.
    * `instances_primary_range`: The primary IP range for the subnet used for all node IP addresses. We recommend choosing a /20 range from the 10.0.0.0/8 private IP range, such as 10.0.0.0/20.
    * `pods_secondary_range`: A secondary IP range for the subnet used for all pod IP addresses. We recommend choosing a /16 range from the 10.0.0.0/8 private IP range, such as 10.1.0.0/16.
    * `services_secondary_range`: A secondary IP range for the subnet used for all service IP addresses. We recommend choosing a /20 range from the 10.0.0.0/8 private IP range, such as 10.2.0.0/20.
    * If VPC peering, these IP ranges **cannot** overlap with the IP ranges of your existing VPC to peer with.
* `vpc_peering_config`: The configuration for VPC peering.
    * `enabled`: Whether to enable VPC peering.
    * `peer_vpc_name`: The name of the VPC to peer with.
        * This should be the name for the VPC where the applications will run.
    * `peer_subnet_names`: The names of the subnets to peer with.
        * This should be the list of names for all subnets running applications that will interact with ExaDeploy.
        * The set of subnet names can be easily updated later if you end up running applications in a new subnet.
* `gpu_node_config`: The configuration for the GPU node pool.
    * `machine_type`: The machine type for the GPU nodes. If you are not sure which to use, we recommend `n1-standard-4`.
    * `min_gpu_nodes`: The minimum number of GPU nodes to create.
    * `max_gpu_nodes`: The maximum number of GPU nodes to create.
    * `accelerator_type`: The type of GPU accelerator to use. If you are not sure which to use, we recommend `nvidia-tesla-t4`.
    * `accelerator_count`: The number of accelerators to attach to each GPU node. If you are not sure which to use, we recommend `1`.
    * `node_zones`: The zones to create the GPU nodes in. Zones must be within the same region as the cluster and must have accelerators of `accelerator_type` available. To check which zones in the region have available accelerators, check the [GCP GPU regions and zones availability page](https://cloud.google.com/compute/docs/gpus/gpu-regions-zones#gpu_regions_and_zones) or run `gcloud compute accelerator-types list`.
* `api_key`: The API key used to identify your company to Exafunction.
    * This should be provided by Exafunction.
* `exafunction_chart_version`: The version of the Exafunction Helm chart to install.
    * This should be in the release provided by Exafunction.

### [`values.yaml`](/values.yaml)
Users should modify this file to provide the image names for ExaDeploy system components. These image names should be in the release provided by Exafunction.

## Create
After finishing configuration, run
```bash
./create.sh
```
from the repository's root directory. It may take some time (up to 30 minutes) to finish applying as it needs to spin up and configure many new GCP resources. Note that `create.sh` is idempotent and can be rerun with updated configuration to update the deployed infrastructure.

## Running applications with ExaDeploy
For instructions on how to write and run applications that offload GPU computations to ExaDeploy, see our Quickstart Guide.

Applications running on external GCP infrastructure (i.e. not within the ExaDeploy cluster) will need to use the load balancer addresses for the ExaDeploy module repository and scheduler services.

To get these addresses, run these commands from the repository's root directory:

### Update Local Kubeconfig
```bash
gcloud container clusters get-credentials \
    --project $(terraform -chdir=gcp output -raw project) \
    --region $(terraform -chdir=gcp output -raw region) \
    $(terraform -chdir=gcp output -raw cluster_id)
```

### Module Repository
```bash
kubectl get service module-repository-service \
    -o jsonpath='{.status.loadBalancer.ingress[0].ip}{"\n"}'
```

### Scheduler
```bash
kubectl get service scheduler-service \
    -o jsonpath='{.status.loadBalancer.ingress[0].ip}{"\n"}'
```

Both should return IP addresses within the Exafunction VPC's subnet's primary address range.

## Destroy
In order to destroy all the infrastructure set up by the repository, run
```bash
./destroy.sh
```
from the repository's root directory. This will delete all resources created by the installation including the ExaDeploy system, VPC peering connection, GKE cluster, and VPC.
