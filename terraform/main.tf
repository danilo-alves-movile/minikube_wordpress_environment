resource "kubernetes_namespace" "app-default" {
  metadata {
        name = "app-default"
  }
}
# resource "helm_release" "nginx-ingress" {
#     name = "nginx-ingress"
#     repository = "https://kubernetes.github.io/ingress-nginx"
#     chart = "ingress-nginx"  
# }
resource "kubernetes_pod" "mysql" {
    metadata {
        name = "mysql"
        labels = {
        "App" = "mysql"
        }
    }
    spec {
        container {
            image = "mysql:5.7"
            name = "mysql"
            port {
                container_port = 3306
            }
            env {
                name = "MYSQL_ROOT_PASSWORD"
                value = var.WORDPRESS_DB_PASSWORD
            }
            env {
                name = "MYSQL_DATABASE"
                value = var.WORDPRESS_DB_NAME
            }                
            env {
              name = "MYSQL_RANDOM_ROOT_PASSWORD"
              value = ""
            }

        }
    }
}
resource "kubernetes_service" "mysql" {
      metadata {
        name = "mysql-service"
      }
      spec {
        selector = {
          "App" = kubernetes_pod.mysql.metadata[0].labels.App
        }
        port {
          port = 3306
        }
      }
}
resource "kubernetes_deployment" "wordpress-app1" {
    metadata {
      name = "wordpress-app1"
      labels = {
        "App" = "wordpress-app1"
      }
    }
    spec {
      replicas = 1
      selector {
          match_labels = {
              "App" = "wordpress-app1"
          }
      }
      template {
          metadata {
              labels = {
                  "App" = "wordpress-app1"
              }
          }
            spec {
                container {
                    image = "danilohalves/wordpress:v1"
                    name = "wordpress-app1"
                    port {
                      container_port = 80
                    }
                    resources {
                        limits {
                            cpu = "0.5"
                            memory = "128Mi"
                        }
                    }    
                    # liveness_probe {
                    #     http_get {
                    #         path = "/"
                    #         port = 80
                    #     }
                    #     initial_delay_seconds = 3
                    #     period_seconds = 3
                    # }
                    env {
                        name = "WORDPRESS_DB_HOST"
                        value = kubernetes_service.mysql.metadata[0].name
                    }
                    env {
                        name = "WORDPRESS_DB_USER"
                        value = var.WORDPRESS_DB_USER
                    }
                    env {
                        name = "WORDPRESS_DB_PASSWORD"
                        value = var.WORDPRESS_DB_PASSWORD
                    }
                    env {
                        name = "WORDPRESS_DB_NAME"
                        value = var.WORDPRESS_DB_NAME
                    }                
                }
            }            
      }
    }
}
resource "kubernetes_service" "wordpress-app1" {
    metadata {
      name = "wordpress-app1"
    }
    spec {
      selector = {
        "App" = "wordpress-app1" #kubernetes_deployment.wordpress-app1.metadata[0].labels.App
      }
      port {
        port = 8080
        target_port = 80
      }
    }
  
}
resource "kubernetes_ingress" "nginx" {
    metadata {
      name = "nginx-ingress"
    #   annotations = {
    #     "nginx.ingress.kubernetes.io/rewrite-target" = "/$1"
    #   }
    }
    spec {
      rule {
        # host = "app1.wordpress"
        http {
          path {
            path = "/"
            backend {
              service_name = "wordpress-app1"
              service_port = 8080 #kubernetes_service.wordpress-app1.spec.port.port
            }
          }
        }
      }
    }
}

resource "helm_release" "grafana" {
    name = "grafana"
    repository = "https://grafana.github.io/helm-charts"
    chart = "grafana/grafana"
    version = "6.1.9"

    set {
        name = "replicas"
        value = 1
    } 
    set {
        name = "service.portName"
        value = 3000
    }
}
resource "helm_release" "prometheus" {
    name = "prometheus"
    repository = "https://prometheus-community.github.io/helm-charts"
    chart = "prometheus"
    version = "12.0.0"
}
# resource "helm_release" "prometheus-operator" {
#     name = "prometheus-operator"
#     repository = "https://prometheus-community.github.io/helm-charts"
#     chart = "prometheus"
#     version = "9.3.2"
# }

