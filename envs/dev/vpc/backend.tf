terraform {
  backend "s3" {
    bucket       = "berdyugin-faraway-test-terraform-state" # S3 bucket name
    key          = "envs/dev/vpc/terraform.tfstate"         # Path (object key) in the bucket
    region       = "us-east-1"                              # AWS region
    use_lockfile = true                                     # Lock file
    encrypt      = true                                     # Enable encryption at rest (SSE)
  }
}
