module "exafunction_kube" {
  source  = "Exafunction/exafunction-kube/gcp"
  version = "0.1.0"

  exadeploy_helm_chart_version = var.exadeploy_helm_chart_version
  exadeploy_helm_values_path   = var.values_file_path
  exafunction_api_key          = var.api_key

  scheduler_image         = var.scheduler_image
  module_repository_image = var.module_repository_image
  runner_image            = var.runner_image

  module_repository_backend = "remote"
  gcs_bucket_name           = data.terraform_remote_state.cloud.outputs.exafunction_module_repo_backend.gcs_bucket_name
  gcs_credentials_json      = data.terraform_remote_state.cloud.outputs.exafunction_module_repo_backend.gcs_credentials_json
  cloud_sql_address         = data.terraform_remote_state.cloud.outputs.exafunction_module_repo_backend.cloud_sql_address
  cloud_sql_port            = data.terraform_remote_state.cloud.outputs.exafunction_module_repo_backend.cloud_sql_port
  cloud_sql_username        = data.terraform_remote_state.cloud.outputs.exafunction_module_repo_backend.cloud_sql_username
  cloud_sql_password        = data.terraform_remote_state.cloud.outputs.exafunction_module_repo_backend.cloud_sql_password
}
