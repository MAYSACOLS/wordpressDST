provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
}
#plus utilisé, la ci/cd gère le déploiment dans le cluster EKS 
# locals {
#   manifests = fileset("${path.module}/deployment_files", "*.yaml")  # Répertoire de vos manifestes YAML
# }

# resource "kubernetes_manifest" "apply_manifests" {
#   for_each = toset(local.manifests)

#   manifest = yamldecode(file("${path.module}/deployment_files/${each.value}"))
# }

resource "kubernetes_ingress" "wordpress" {
  metadata {
    name      = "wordpress-ingress"
    namespace = kubernetes_namespace.wordpress.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class"                      = "alb"
      "alb.ingress.kubernetes.io/load-balancer-arn"      = aws_lb.wordpress.arn
      "alb.ingress.kubernetes.io/target-group-arn"       = aws_lb_target_group.wordpress.arn
      "alb.ingress.kubernetes.io/listen-ports"           = jsonencode([{
        HTTP = 80
      }])
      "alb.ingress.kubernetes.io/scheme"                 = "internet-facing"
      "alb.ingress.kubernetes.io/security-groups"        = aws_security_group.wordpress.id
      "alb.ingress.kubernetes.io/subnets"                = join(",", module.vpc.public_subnets)
    }
  }
  spec {
    rule {
      host = "projetweb.maysadevops.dns-dynamic.net"
      http {
        path {
          path     = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.wordpress_service.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

