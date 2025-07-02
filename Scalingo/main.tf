terraform {
  required_providers {
    scalingo = {
      source  = "Scalingo/scalingo"
      version = "2.3.0"
    }
  }
}

provider "scalingo" {
  api_token = "tk-us-n0oq4X7wGG9opjaW3cuGBP6D0o3OLnfmktoaHzJUbkvyBMg9"
  region    = "osc-fr1"
}

resource "scalingo_app" "python-api" {
  name = "python-api"
  environment = {
    PROJECT_DIR   = "server",
    BUILDPACK_URL = "https://github.com/Scalingo/python-buildpack",
  }
}

resource "scalingo_addon" "db" {
  provider_id = "mysql"
  plan        = "mysql-starter-512"
  app         = scalingo_app.python-api.id
}

resource "scalingo_container_type" "web" {
  app    = scalingo_app.python-api.name
  name   = "web"
  amount = 1
  size   = "S"
}

