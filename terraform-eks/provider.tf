provider "aws" {
  region = var.aws_region
}

# local exec helper (optional)
provider "null" {}
