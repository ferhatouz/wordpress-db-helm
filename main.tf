provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
provider "kubernetes" {
  config_path = "~/.kube/config"
}
resource "helm_release" "chart" {
  name       = var.realesename
  chart      = var.chart
  namespace = kubernetes_namespace.wordpress.metadata[0].name
   values = [
    "${file(var.file)}"
  ]

  set {
    name  = "image"
    value = var.image
  }

  set {
    name  = "tag"
    value = var.tag
  }
  set {
    name  = "replicas"
    value = var.replicas
  }

  set {
    name  = "port"
    value = var.port
  }

}
resource "kubernetes_namespace" "wordpress" {
  metadata {
    name = var.namespace
    labels = {
        app = "wordpress"
        }

  }
}
resource "kubernetes_persistent_volume" "pv" {
  metadata {
    name = var.pvname
  }
  spec {
    capacity = {
      storage = var.storage
    }
    access_modes = var.accessMode
    persistent_volume_source {
      vsphere_volume {
        volume_path = var.volume_path
      }
    }
  }
}
resource "kubernetes_persistent_volume_claim" "pvc" {
  metadata {
    name = var.pvcname
    namespace = kubernetes_namespace.wordpress.metadata[0].name
  }
  spec {
    access_modes = var.accessMode
    resources {
      requests = {
        storage = var.storage
      }
    }
    volume_name = "${kubernetes_persistent_volume.pv.metadata.0.name}"
  }
}