variable "version" {
  type    = string
  default = "26.0"
}

variable "postgres_version" {
  type    = string
  default = "17.2-alpine"
}

variable "volume_name" {
  type    = string
  default = "keycloak-database-data"
}

variable "external_domain" {
  type = string
}

variable "apps_subdomain" {
  type = string
}

variable "realm_import" {
  type = string
}

job "keycloak" {
  type      = "service"
  namespace = "default"

  group "app" {
    count = 1

    network {
      mode = "bridge"

      port "http" {
        to = 8080
      }

      port "management" {
        to = 9000
      }

      port "envoy_metrics" {
        to = 9102
      }
    }

    service {
      name = "keycloak"
      port = "http"
      tags = ["traefik.enable=true"]

      check {
        name     = "Healthiness Check"
        type     = "http"
        port     = "management"
        path     = "/health/live"
        interval = "10s"
        timeout  = "3s"

        check_restart {
          grace = "5s"
        }
      }

      check {
        name      = "Readiness Check"
        type      = "http"
        port      = "management"
        path      = "/health/ready"
        interval  = "10s"
        timeout   = "3s"
        on_update = "ignore_warnings"

        check_restart {
          grace           = "5s"
          ignore_warnings = true
        }
      }
    }

    service {
      meta {
        envoy_metrics_port = "${NOMAD_HOST_PORT_envoy_metrics}"
      }

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "keycloak-database"
              local_bind_port  = 5432
            }
          }
        }

        sidecar_task {
          resources {
            cpu    = 50
            memory = 32
          }
        }
      }
    }

    task "keycloak" {
      driver = "docker"

      config {
        image = "quay.io/keycloak/keycloak:${var.version}"
        ports = ["http"]
        args  = ["start", "--import-realm"]

        mount {
          type     = "bind"
          source   = "local/realm.json"
          target   = "/opt/keycloak/data/import/realm.json"
          readonly = true
        }
      }

      env {
        KC_HEALTH_ENABLED        = "true"
        KC_HTTP_ENABLED          = "true"
        KC_LOG_LEVEL             = "WARN,io.quarkus:INFO,org.infinispan.CONTAINER:INFO"
        KC_HOSTNAME              = "keycloak.${var.apps_subdomain}.${var.external_domain}"
        KC_DB                    = "postgres"
        KC_DB_URL_HOST           = "${NOMAD_UPSTREAM_IP_keycloak_database}"
        KC_DB_URL_PORT           = "${NOMAD_UPSTREAM_PORT_keycloak_database}"
        KC_DB_URL_DATABASE       = "keycloak"
        KC_DB_USERNAME           = "keycloak"
        KC_DB_PASSWORD           = "keycloak"
        KC_METRICS_ENABLED       = "true"
        JAVA_OPTS_APPEND         = "-Djgroups.dns.query=keycloak.service.consul"
        KEYCLOAK_ADMIN           = "admin"
        KEYCLOAK_ADMIN_PASSWORD  = "admin"
      }

      resources {
        cpu    = 500
        memory = 512
      }

      template {
        data        = var.realm_import
        destination = "local/realm.json"
      }
    }
  }

  group "database" {
    count = 1

    update {
      max_parallel = 0
    }

    volume "data" {
      type            = "csi"
      source          = var.volume_name
      read_only       = false
      attachment_mode = "file-system"
      access_mode     = "single-node-writer"
    }

    network {
      mode = "bridge"

      port "envoy_metrics" {
        to = 9102
      }
    }

    service {
      port = "5432"

      meta {
        envoy_metrics_port = "${NOMAD_HOST_PORT_envoy_metrics}"
      }

      connect {
        sidecar_service {}

        sidecar_task {
          resources {
            cpu    = 50
            memory = 32
          }
        }
      }
    }

    task "postgres" {
      driver = "docker"

      config {
        image = "postgres:${var.postgres_version}"
      }

      env {
        POSTGRES_USER     = "keycloak"
        POSTGRES_PASSWORD = "keycloak"
        PGDATA            = "/var/lib/postgresql/data/pgdata"
      }

      volume_mount {
        volume      = "data"
        destination = "/var/lib/postgresql/data/pgdata"
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
