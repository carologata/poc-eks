data "aws_caller_identity" "current" {}

# The :root ensures that the role can only be assumed by entities within the same AWS account as the caller
resource "aws_iam_role" "eks_admin" {
  name = "${local.env}-${local.eks_name}-eks-admin"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      }
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "eks_admin" {
  name = "AmazonEKSAdminPolicy"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": "eks.amazonaws.com"
                }
            }
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks_admin" {
  role       = aws_iam_role.eks_admin.name
  policy_arn = aws_iam_policy.eks_admin.arn
}

resource "aws_iam_user" "manager" {
    name = "manager"
}

# policy to assume the eks_admin role 
resource "aws_iam_policy" "eks_assume_admin" {
  name = "AmazonEKSAssumeAdminPolicy"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Resource": "${aws_iam_role.eks_admin.arn}" 
        }
    ]
}
POLICY
}

resource "aws_iam_user_policy_attachment" "manager" {
  user       = aws_iam_user.manager.name
  policy_arn = aws_iam_policy.eks_assume_admin.arn
}

# Best practice: use IAM roles due to temporary credentials
# The Terraform aws_eks_access_entry maps the IAM role to the Kubernetes my-admin group
resource "aws_eks_access_entry" "manager" {
    cluster_name = aws_eks_cluster.eks.name
    principal_arn = aws_iam_role.eks_admin.arn
    kubernetes_groups = ["my-admin"]
}

# cluster_name = aws_eks_cluster.eks.name
#   → Specifies which EKS cluster this access entry applies to.
# principal_arn = aws_iam_role.eks_admin.arn
#   → Associates the IAM role eks_admin with the EKS cluster.
# kubernetes_groups = ["my-admin"]
#   → Maps the IAM role to the Kubernetes group "my-admin" inside the EKS cluster.