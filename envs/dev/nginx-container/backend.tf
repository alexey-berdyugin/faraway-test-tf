terraform {
  backend "s3" {
    bucket       = "berdyugin-faraway-test-terraform-state"
    key          = "envs/dev/eks/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}
