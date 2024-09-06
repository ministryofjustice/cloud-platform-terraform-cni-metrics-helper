
# IAM Role for ServiceAccounts: This is for EKS

module "iam_assumable_role_admin" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.13.0"
  create_role                   = true
  role_name                     = "cni-metrics-helper.${var.cluster_domain_name}"
  provider_url                  = var.eks_cluster_oidc_issuer_url
  role_policy_arns              = [length(aws_iam_policy.cert_manager) >= 1 ? aws_iam_policy.cert_manager.arn : ""]
  oidc_fully_qualified_subjects = ["system:serviceaccount:cni-metrics-helper:cni-metrics-helper"]
}

resource "aws_iam_policy" "cni-metrics-helper" {

  name_prefix = "cni_metrics_helper"
  description = "EKS cni-metrics-helper policy for cluster ${var.cluster_domain_name}"
  policy      = data.aws_iam_policy_document.cni_metrics_helper_irsa.json
}

data "aws_iam_policy_document" "cni_metrics_helper_irsa" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]
    actions   = ["cloudwatch:PutMetricData"]
  }
}