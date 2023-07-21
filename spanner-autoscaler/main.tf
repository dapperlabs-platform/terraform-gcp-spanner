module "autoscaler-base" {
  source = "./modules/autoscaler-base"

  project_id = var.project_id
  region     = var.region
}

module "autoscaler-functions" {
  source = "./modules/autoscaler-functions"

  project_id      = var.project_id
  poller_sa_email = module.autoscaler-base.poller_sa_email
  region          = var.region
  scaler_sa_email = module.autoscaler-base.scaler_sa_email
  bucket_gcf_name = var.bucket_gcf_name
}

module "spanner" {
  source = "./modules/spanner"

  terraform_spanner_state        = var.terraform_spanner_state
  terraform_spanner_test         = false
  project_id                     = var.project_id
  spanner_name                   = var.spanner_name
  spanner_state_name             = var.spanner_state_name
  spanner_state_processing_units = var.spanner_state_processing_units
  poller_sa_email                = module.autoscaler-base.poller_sa_email
  scaler_sa_email                = module.autoscaler-base.scaler_sa_email
}

module "scheduler" {
  source = "./modules/scheduler"

  max_size                  = var.max_size
  min_size                  = var.min_size
  poller_job_name           = var.poller_job_name
  project_id                = var.project_id
  pubsub_topic              = module.autoscaler-functions.poller_topic
  scale_in_cooling_minutes  = var.scale_in_cooling_minutes
  scale_out_cooling_minutes = var.scale_out_cooling_minutes
  scaling_method            = var.scaling_method
  schedule                  = var.schedule
  spanner_name              = var.spanner_name
  spanner_state_name        = var.spanner_state_name
  target_pubsub_topic       = module.autoscaler-functions.scaler_topic
  terraform_spanner_state   = var.terraform_spanner_state

  // Example of passing config as json
  // json_config             = base64encode(jsonencode([{
  //   "projectId": "${var.project_id}",
  //   "instanceId": "${module.spanner.spanner_name}",
  //   "scalerPubSubTopic": "${module.autoscaler.scaler_topic}",
  //   "units": "NODES",
  //   "minSize": 1
  //   "maxSize": 3,
  //   "scalingMethod": "LINEAR"
  // }]))
}
