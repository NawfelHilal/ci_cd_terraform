terraform {
  required_providers {
    scalingo = {
      source  = "Scalingo/scalingo"
      version = "2.3.0"
    }
  }
}

variable "scalingo_token" {
  type        = string
  description = "the scalingo token"
}

provider "scalingo" {
  api_token = var.scalingo_token
  region    = "osc-fr1"
}

resource "scalingo_app" "monorepo" {
  name = "monorepo-terraform"
}

resource "scalingo_container_type" "web" {
  app    = scalingo_app.monorepo.name
  name   = "web"
  size   = "S"
  amount = 1
}

resource "scalingo_container_type" "api-node" {
  app    = scalingo_app.monorepo.name
  name   = "api-node"
  size   = "S"
  amount = 1
}

resource "scalingo_container_type" "api-python" {
  app    = scalingo_app.monorepo.name
  name   = "api-python"
  size   = "S"
  amount = 1
}
