terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}
provider "kubernetes" {
  config_path = "../k3s.yaml"
}

resource "kubernetes_deployment" "webpass_deployment" {
  metadata {
    name = "webpass-deployment"
    labels = {
      app = "webpass"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "webpass"
      }
    }

    template {
      metadata {
        labels = {
          app = "webpass"
        }
      }

      spec {
        container {
          name  = "webpass-panel"
          image = "docker.io/sajademperor/webpass_frontend_site:24"

          port {
            container_port = 80
          }

          resources {
            requests = {
              memory = "1Gi"
              cpu    = "1000m"
            }

            limits = {
              memory = "2Gi"
              cpu    = "2000m"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "my-service" {
  metadata {
    name = "my-service"
  }
  
  spec {
    selector = {
      app = "webpass"
    }

    type = "NodePort"

    port{
       port=80
       target_port=80
       node_port=30000
     }

     external_ips=[
        "192.168.122.10",
     ] 
  }
}