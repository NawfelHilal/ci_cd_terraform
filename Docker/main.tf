terraform {
    required_providers {
        docker = {
            source = "kreuzwerker/docker"
            version = "3.0.2"
        }
    }
}


provider "docker" {
}

resource "docker_network" "internal_network" {
    name = "internal_network"
}

resource "docker_image" "mysql" {
    name = "mysql:9.2"
}

resource "docker_container" "mysql" {
    name = "mysql"
    image = "${docker_image.mysql.image_id}"
    networks_advanced {
        name = docker_network.internal_network.name
    }
    env = ["MYSQL_ROOT_PASSWORD=pwd"]
    volumes {
        host_path = "/Users/loisefenoll/Documents/m2-web-docker-connect/sqlfiles"
        container_path = "/doker-entrypoint-initdb.d"
    }
    ports {
        internal = 3306
        external = 3307
    }
}

resource "docker_image" "python-api" {
    name = "python-api"
    keep_locally = true
    build {
        context = "../server"
    }
}

resource "docker_container" "python-api" {
    name = "python-api"
    networks_advanced {
        name = docker_network.internal_network.name
    }
    image = docker_image.python-api.image_id
    env = [
        "MYSQL_ROOT_PASSWORD=pwd",
        "MYSQL_DATABASE=ynov",
        "MYSQL_USER=root",
        "PORT=8000",
        "MYSQL_HOST=${docker_container.mysql.network_data.0.ip_address}"
    ]
    ports {
        internal = 8000
        external = 8000
    }
    restart = "always"
}
