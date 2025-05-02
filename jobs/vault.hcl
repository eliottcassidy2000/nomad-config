job "vault" {
  datacenters = ["dc1"]
  type        = "service"

  group "vault" {
    count = 3

    network {
      port "http" {
        to = 8200
      }
      port "cluster" {
        to = 8201
      }
    }

    # # Use CSI local plugin for dynamic, node-local persistent storage
    # volume "vault_data" {
    #   type         = "csi"
    #   plugin_id    = "csi-local"
    #   capacity_min = "10Gi"
    #   access_mode  = "single-node-writer"
    #   # external_id can be left empty; Nomad will generate a unique one per allocation
    # }

    service {
      name = "vault"
      port = "http"
      provider = "nomad"
      check {
        type     = "tcp"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "vault" {
      driver = "docker"

      config {
        image = "hashicorp/vault:latest"
        # lets do this manually for now
        command = "sleep"
        args = ["999999"]
        # args  = ["server", "-config=/vault/config/vault.hcl"]
        ports = ["http", "cluster"]
        mount {
          type = "tmpfs"
          target = "/vault/data"
          readonly = false
          tmpfs_options {
            size = 1000000000 # size in bytes
          }
        }
        # volumes = [
        #   "local/config:/vault/config",
        #   "vault_data:/vault/data"
        # ]
      }

      # Vault configuration with Integrated Storage (Raft) + AWS KMS auto-unseal
      template {
        destination = "local/config/vault.hcl"
        change_mode = "restart"
        data = <<EOF
ui = true
disable_mlock = true

# Integrated Storage (Raft)
storage "raft" {
  path    = "/vault/data"
  node_id = "{{ env "NOMAD_ALLOC_ID" }}"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
}

# Raft clustering listener
listener "tcp" {
  address         = "0.0.0.0:8201"
  cluster_address = "0.0.0.0:8201"
  tls_disable     = 1
}

## Auto-unseal with AWS KMS
#seal "awskms" {
#  region     = "us-east-1"
#  kms_key_id = "your-kms-key-id"
#}

api_addr     = "http://{{ env "attr.unique.network.ip-address" }}:8200"
cluster_addr = "http://{{ env "attr.unique.network.ip-address" }}:8201"
EOF
      }

      env {
      }

      resources {
        cpu    = 500
        memory = 512
      }
    }
  }
}
