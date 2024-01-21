variable "version" {
  type    = string
  default = "1.21-rootless"
}

variable "namespace" {
  type    = string
  default = "scm"
}

variable "gitea_host" {
  type    = string
  default = ""
}

variable "data_volume_name" {
  type    = string
  default = "gitea-data"
}

variable "database_volume_name" {
  type    = string
  default = "gitea-database-data"
}

job "gitea" {
  type      = "service"
  namespace = var.namespace

  group "gitea" {
    count = 1

    update {
      max_parallel = 0
    }

    network {
      mode = "bridge"

      port "http" {
        to = 3000
      }
    }

    service {
      name = "gitea"
      port = "3000"
      tags = [
        "traefik.enable=true",
        "traefik.consulcatalog.connect=true",
      ]

      check {
        name     = "api-health"
        expose   = true
        type     = "http"
        path     = "/api/healthz"
        port     = "http"
        interval = "10s"
        timeout  = "5s"

        check_restart {
          grace = "200s"
        }
      }

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "gitea-database"
              local_bind_port  = 5432
            }

            upstreams {
              destination_name = "gitea-cache"
              local_bind_port  = 6379
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

    volume "data" {
      type            = "csi"
      source          = var.data_volume_name
      read_only       = false
      attachment_mode = "file-system"
      access_mode     = "single-node-writer"
    }

    task "gitea" {
      driver = "docker"

      config {
        image   = "gitea/gitea:${var.version}"
        command = "/run/init.sh"

        volumes = [
          "local/init.sh:/run/init.sh"
        ]
      }

      env {
        GITEA__server__HTTP_PORT                  = "${NOMAD_PORT_http}"
        GITEA__server__DOMAIN                     = "${var.gitea_host}"
        GITEA__server__ROOT_URL                   = "http://${var.gitea_host}/"
        GITEA__security__INSTALL_LOCK             = "true"
        GITEA__security__INTERNAL_TOKEN_URI       = "file:/secrets/internal_token"
        GITEA__security__SECRET_KEY_URI           = "file:/secrets/secret_key"
        GITEA__security__DISABLE_QUERY_AUTH_TOKEN = "true"
        GITEA__database__DB_TYPE                  = "postgres"
        GITEA__database__HOST                     = "localhost:5432"
        GITEA__database__NAME                     = "gitea"
        GITEA__database__USER                     = "gitea"
        GITEA__database__PASSWD                   = "gitea"
        GITEA__cache__ADAPTER                     = "redis"
        GITEA__cache__HOST                        = "redis://localhost:6379/0"
        GITEA__queue__TYPE                        = "redis"
        GITEA__queue__CONN_STR                    = "redis://localhost:6379/1"
        GITEA__session__PROVIDER                  = "redis"
        GITEA__session__PROVIDER_CONFIG           = "redis://localhost:6379/2"
        GITEA__log__LEVEL                         = "Warn"
        GITEA__actions__ENABLED                   = "true"
        GITEA__metrics__ENABLED                   = "true"
      }

      template {
        destination = "/secrets/internal_token"

        data = <<-EOT
          {{ with nomadVar "nomad/jobs/gitea/gitea/gitea" }}{{ .internal_token }}{{ end }}
        EOT
      }

      template {
        destination = "/secrets/secret_key"

        data = <<-EOT
          {{ with nomadVar "nomad/jobs/gitea/gitea/gitea" }}{{ .secret_key }}{{ end }}
        EOT
      }

      template {
        destination = "/secrets/root_user"

        data = <<-EOT
          {{ with nomadVar "nomad/jobs/gitea/gitea/gitea" }}
          ROOT_USERNAME='{{ .root_username }}'
          ROOT_PASSWORD='{{ .root_password }}'
          ROOT_EMAIL='{{ .root_email }}'
          {{ end }}
        EOT
      }

      template {
        destination = "local/init.sh"
        perms       = "755"

        data = <<-EOT
          #!/bin/sh
          set -e

          retries=0
          while ! nc -z localhost 5432
          do
            if [ $retries -gt 10 ]; then
              echo "database unreachable"
              exit 1
            fi
            echo "waiting for database..."
            retries=$(($retries + 1))
            sleep 3
          done

          gitea migrate

          if [ 2 -gt "$(gitea admin user list --admin | wc -l)" ]
          then
            source /secrets/root_user
            gitea admin user create --admin \
              --username "$ROOT_USERNAME" \
              --password "$ROOT_PASSWORD" \
              --email "$ROOT_EMAIL"
          fi

          exec /usr/bin/dumb-init -- /usr/local/bin/docker-entrypoint.sh
        EOT
      }

      resources {
        cpu    = 100
        memory = 256
      }

      volume_mount {
        volume      = "data"
        destination = "/var/lib/gitea"
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
      source          = var.database_volume_name
      read_only       = false
      attachment_mode = "file-system"
      access_mode     = "single-node-writer"
    }

    network {
      mode = "bridge"
    }

    service {
      port = "5432"

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
        image = "postgres:16.1-alpine"
      }

      env {
        POSTGRES_USER     = "gitea"
        POSTGRES_PASSWORD = "gitea"
        PGDATA            = "/var/lib/postgresql/data/pgdata"
      }

      volume_mount {
        volume      = "data"
        destination = "/var/lib/postgresql/data"
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }

  group "cache" {
    count = 1

    network {
      mode = "bridge"
    }

    service {
      port = "6379"

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

    task "redis" {
      driver = "docker"

      config {
        image = "redis:7.2-alpine"
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
