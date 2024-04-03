variable "accept_limited_use_license" {
  description = "Acceptance of the SLULA terms (https://docs.snowplow.io/limited-use-license-1.0/)"
  type        = bool
  default     = false

  validation {
    condition     = var.accept_limited_use_license
    error_message = "Please accept the terms of the Snowplow Limited Use License Agreement to proceed."
  }
}

variable "name" {
  description = "A name which will be pre-pended to the resources created"
  type        = string
}

variable "app_version" {
  description = "App version to use. This variable facilitates dev flow, the modules may not work with anything other than the default value."
  type        = string
  default     = "0.3.3"
}

variable "vpc_id" {
  description = "The VPC to deploy the Postgres Loader within"
  type        = string
}

variable "subnet_ids" {
  description = "The list of subnets to deploy the Postgres Loader across"
  type        = list(string)
}

variable "instance_type" {
  description = "The instance type to use"
  type        = string
  default     = "t3a.micro"
}

variable "associate_public_ip_address" {
  description = "Whether to assign a public ip address to this instance"
  type        = bool
  default     = true
}

variable "ssh_key_name" {
  description = "The name of the SSH key-pair to attach to all EC2 nodes deployed"
  type        = string
}

variable "ssh_ip_allowlist" {
  description = "The list of CIDR ranges to allow SSH traffic from"
  type        = list(any)
  default     = ["0.0.0.0/0"]
}

variable "iam_permissions_boundary" {
  description = "The permissions boundary ARN to set on IAM roles created"
  default     = ""
  type        = string
}

variable "min_size" {
  description = "The minimum number of servers in this server-group"
  default     = 1
  type        = number
}

variable "max_size" {
  description = "The maximum number of servers in this server-group"
  default     = 2
  type        = number
}

variable "amazon_linux_2_ami_id" {
  description = "The AMI ID to use which must be based of of Amazon Linux 2; by default the latest community version is used"
  default     = ""
  type        = string
}

variable "kcl_read_min_capacity" {
  description = "The minimum READ capacity for the KCL DynamoDB table"
  type        = number
  default     = 1
}

variable "kcl_read_max_capacity" {
  description = "The maximum READ capacity for the KCL DynamoDB table"
  type        = number
  default     = 10
}

variable "kcl_write_min_capacity" {
  description = "The minimum WRITE capacity for the KCL DynamoDB table"
  type        = number
  default     = 1
}

variable "kcl_write_max_capacity" {
  description = "The maximum WRITE capacity for the KCL DynamoDB table"
  type        = number
  default     = 10
}

variable "tags" {
  description = "The tags to append to this resource"
  default     = {}
  type        = map(string)
}

variable "cloudwatch_logs_enabled" {
  description = "Whether application logs should be reported to CloudWatch"
  default     = true
  type        = bool
}

variable "cloudwatch_logs_retention_days" {
  description = "The length of time in days to retain logs for"
  default     = 7
  type        = number
}

variable "java_opts" {
  description = "Custom JAVA Options"
  default     = "-XX:InitialRAMPercentage=75 -XX:MaxRAMPercentage=75"
  type        = string
}

# --- Auto-scaling options

variable "enable_auto_scaling" {
  description = "Whether to enable auto-scaling policies for the service (WARN: ensure you have sufficient db_connections available for the max number of nodes in the ASG)"
  default     = true
  type        = bool
}

variable "scale_up_cooldown_sec" {
  description = "Time (in seconds) until another scale-up action can occur"
  default     = 180
  type        = number
}

variable "scale_up_cpu_threshold_percentage" {
  description = "The average CPU percentage that must be exceeded to scale-up"
  default     = 60
  type        = number
}

variable "scale_up_eval_minutes" {
  description = "The number of consecutive minutes that the threshold must be breached to scale-up"
  default     = 5
  type        = number
}

variable "scale_down_cooldown_sec" {
  description = "Time (in seconds) until another scale-down action can occur"
  default     = 600
  type        = number
}

variable "scale_down_cpu_threshold_percentage" {
  description = "The average CPU percentage that we must be below to scale-down"
  default     = 20
  type        = number
}

variable "scale_down_eval_minutes" {
  description = "The number of consecutive minutes that we must be below the threshold to scale-down"
  default     = 60
  type        = number
}

# --- Configuration options

variable "in_stream_name" {
  description = "The name of the input kinesis stream that the Enricher will pull data from"
  type        = string
}

variable "in_max_batch_size_checkpoint" {
  description = "The maximum number events to process before checkpointing progress on the stream"
  type        = number
  default     = 1000
}

variable "in_max_batch_wait_checkpoint" {
  description = "The maximum amount of time to wait before checkpointing progress on the stream"
  type        = string
  default     = "10 seconds"
}

variable "purpose" {
  description = "The type of data the loader will be pulling which can be one of ENRICHED_EVENTS or JSON (Note: JSON can be used for loading bad rows)"
  type        = string
}

variable "schema_name" {
  description = "The database schema to load data into (e.g atomic | atomic_bad)"
  type        = string
}

variable "initial_position" {
  description = "Where to start processing the input Kinesis Stream from (TRIM_HORIZON or LATEST)"
  default     = "TRIM_HORIZON"
  type        = string
}

variable "db_sg_id" {
  description = "The ID of the RDS security group that sits downstream of the webserver"
  type        = string
}

variable "db_host" {
  description = "The hostname of the database to connect to"
  type        = string
}

variable "db_port" {
  description = "The port the database is running on"
  type        = number
}

variable "db_name" {
  description = "The name of the database to connect to"
  type        = string
}

variable "db_username" {
  description = "The username to use to connect to the database"
  type        = string
}

variable "db_password" {
  description = "The password to use to connect to the database"
  type        = string
  sensitive   = true
}

variable "db_max_connections" {
  description = "The maximum number of connections to the backing database"
  type        = number
  default     = 10
}

# --- Iglu Resolver

variable "default_iglu_resolvers" {
  description = "The default Iglu Resolvers that will be used by Enrichment to resolve and validate events"
  default = [
    {
      name            = "Iglu Central"
      priority        = 10
      uri             = "http://iglucentral.com"
      api_key         = ""
      vendor_prefixes = []
    },
    {
      name            = "Iglu Central - Mirror 01"
      priority        = 20
      uri             = "http://mirror01.iglucentral.com"
      api_key         = ""
      vendor_prefixes = []
    }
  ]
  type = list(object({
    name            = string
    priority        = number
    uri             = string
    api_key         = string
    vendor_prefixes = list(string)
  }))
}

variable "custom_iglu_resolvers" {
  description = "The custom Iglu Resolvers that will be used by Enrichment to resolve and validate events"
  default     = []
  type = list(object({
    name            = string
    priority        = number
    uri             = string
    api_key         = string
    vendor_prefixes = list(string)
  }))
}

# --- Telemetry

variable "telemetry_enabled" {
  description = "Whether or not to send telemetry information back to Snowplow Analytics Ltd"
  type        = bool
  default     = true
}

variable "user_provided_id" {
  description = "An optional unique identifier to identify the telemetry events emitted by this stack"
  type        = string
  default     = ""
}

# --- Image Repositories

variable "private_ecr_registry" {
  description = "The URL of an ECR registry that the sub-account has access to (e.g. '000000000000.dkr.ecr.cn-north-1.amazonaws.com.cn/')"
  type        = string
  default     = ""
}
