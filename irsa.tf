
# IAM Role for ServiceAccounts: This is for EKS

module "iam_assumable_role_admin" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "5.44.1"
  create_role                   = true
  role_name                     = "cni-metrics.${var.cluster_domain_name}"
  provider_url                  = var.eks_cluster_oidc_issuer_url
  role_policy_arns              = [length(aws_iam_policy.cni_metrics_helper) >= 1 ? aws_iam_policy.cni_metrics_helper.arn : ""]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:cni-metrics-helper"]
}

resource "aws_iam_policy" "cni_metrics_helper" {

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