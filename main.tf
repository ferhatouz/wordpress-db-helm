provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
provider "kubernetes" {
  config_path = "~/.kube/config"
}
resource "helm_release" "mysql" {
  name       = "mysql"
  chart      = "./mysql"
  namespace = kubernetes_namespace.wordpress.metadata[0].name
   values = [
    "${file("./mysql/values.yaml")}"
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
resource "helm_release" "wordpress" {
  name       = "wordpress"
  chart      = "./wordpress"
  namespace = kubernetes_namespace.wordpress.metadata[0].name
   values = [
    "${file("./wordpress/values.yaml")}"
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
resource "kubernetes_persistent_volume" "wordpress" {
  metadata {
    name = "wordpress-pv"
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
resource "kubernetes_persistent_volume_claim" "wordpress" {
  metadata {
    name = "wordpress-pvc"
    namespace = kubernetes_namespace.wordpress.metadata[0].name
  }
  spec {
    access_modes = var.accessMode
    resources {
      requests = {
        storage = var.storage
      }
    }
    volume_name = "${kubernetes_persistent_volume.wordpress.metadata.0.name}"
  }
}
resource "kubernetes_persistent_volume" "mysql" {
  metadata {
    name = "mysql-pv"
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
resource "kubernetes_persistent_volume_claim" "mysql" {
  metadata {
    name = "mysql-pvc"
    namespace = kubernetes_namespace.wordpress.metadata[0].name
  }
  spec {
    access_modes = var.accessMode
    resources {
      requests = {
        storage = var.storage
      }
    }
    volume_name = "${kubernetes_persistent_volume.mysql.metadata.0.name}"
  }
}