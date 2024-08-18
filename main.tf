terraform {
  backend "s3" {
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    encrypt                     = false
    endpoints  = {
      dynamodb = "https://docapi.serverless.yandexcloud.net/ru-central1/<dynamodbEndPoint>"
      s3       = "https://storage.yandexcloud.net"
    }
    region         = "ru-central1"
    bucket         = "sakkut-terraform-state"
    key            = "sakkut.tfstate"
    dynamodb_table = "terraform-state-lock"
  }
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = ">= 0.8"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  folder_id = var.folder
  cloud_id  = var.cloud
  zone      = var.prefered_zones[0]
}
