provider "aws" {
  region  = "ap-northeast-1"
}

terraform {
    required_version = "1.5.7"

    required_providers {
      aws = ">=5.31.0"
    }
}
