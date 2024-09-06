resource "helm_release" "cni_metrics_helper" {
  name          = "cni-metrics-helper"
  chart         = "cni-metrics-helper"
  repository    = "https://aws.github.io/eks-charts"
  namespace     = "kube-system"
  version       = "v1.18.3"
  recreate_pods = true

  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    eks_service_account = module.iam_assumable_role_admin.this_iam_role_arn
  })]

  lifecycle {
    ignore_changes = [keyring]
  }
}