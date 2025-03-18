resource "aws_eks_addon" "pod_identity" {
  cluster_name  = aws_eks_cluster.eks.name
  addon_name    = "eks-pod-identity-agent"
  addon_version = "v1.2.0-eksbuild.1"
}

# it installs the EKS Pod Identity Agent on an EKS cluster
# the EKS Pod Identity Agent is used for IAM roles for service accounts (IRSA), allowing pods to securely assume AWS IAM roles
# IRSA allows Kubernetes pods to securely assume AWS IAM roles without using long-term credentials like access keys

# EKS Pod Identity Agent
#     EKS Pod Identity Agent is indeed a daemonset pod, which runs on every node in the cluster.
#     Its purpose is to enable Kubernetes pods to securely assume IAM roles that are associated with Kubernetes service accounts.
#     This allows pods to access AWS resources (e.g., S3, DynamoDB) without needing to store AWS credentials in the pod.
#     The EKS Pod Identity Agent does NOT directly scale the cluster (e.g., scale up or scale down).
#     Scaling the cluster is typically handled by other components like the Cluster Autoscaler (which uses IAM roles to interact with EC2 Auto Scaling Groups to scale the nodes).
#     The Pod Identity Agent works for any pod that needs to assume an IAM role in order to access AWS resources, not just for scaling the cluster.