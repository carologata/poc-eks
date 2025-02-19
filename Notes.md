EKS
    Amazon EKS recommends you use at least two subnets that are in different Availability Zones during cluster creation. 
    The subnets you pass in during cluster creation are known as cluster subnets. 
    
    Kubernetes worker nodes can run in the cluster subnets, but it is not recommended. During cluster upgrades Amazon EKS provisions additional ENIs in the cluster subnets. When your cluster scales out, worker nodes and pods may consume the available IPs in the cluster subnet. Hence in order to make sure there are enough available IPs you might want to consider using dedicated cluster subnets with /28 netmask.

    Kubernetes worker nodes can run in either a public or a private subnet. Whether a subnet is public or private refers to whether traffic within the subnet is routed through an internet gateway. Public subnets have a route table entry to the internet through the internet gateway, but private subnets don’t.

    The traffic that originates somewhere else and reaches your nodes is called ingress. Traffic that originates from the nodes and leaves the network is called egress. Nodes with public or elastic IP addresses (EIPs) within a subnet configured with an internet gateway allow ingress from outside of the VPC. Private subnets usually have a routing to a NAT gateway, which do not allow ingress traffic to the nodes in the subnets from outside of VPC while still allowing traffic from the nodes to leave the VPC (egress).

    In the IPv6 world, every address is internet routable. The IPv6 addresses associated with the nodes and pods are public. Private subnets are supported by implementing an egress-only internet gateways (EIGW) in a VPC, allowing outbound traffic while blocking all incoming traffic. Best practices for implementing IPv6 subnets can be found in the VPC user guide.

    You can configure VPC and Subnets in three different ways:

    Using only public subnets

    In the same public subnets, both nodes and ingress resources (such as load balancers) are created. Tag the public subnet with kubernetes.io/role/elb

    to construct load balancers that face the internet. In this configuration, the cluster endpoint can be configured to be public, private, or both (public and private).
    Using private and public subnets

    Nodes are created on private subnets, whereas Ingress resources are instantiated in public subnets. You can enable public, private, or both (public and private) access to the cluster endpoint. Depending on the configuration of the cluster endpoint, node traffic will enter via the NAT gateway or the ENI.
    Using only private subnets

    Both nodes and ingress are created in private subnets. Using the kubernetes.io/role/internal-elb
    subnet tag to construct internal load balancers. Accessing your cluster’s endpoint will require a VPN connection. You must activate AWS PrivateLink for EC2 and all Amazon ECR and S3 repositories. Only the private endpoint of the cluster should be enabled. We suggest going through the EKS private cluster requirements before provisioning private clusters.
    
Sources:
    https://docs.aws.amazon.com/eks/latest/best-practices/subnets.html
    https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html


NAT Gateway

    Key Points:

        Purpose: Enables outbound internet traffic for instances in private subnets.
        Security: Keeps instances private by not allowing inbound internet traffic.
        Use Case: Download updates, access external APIs, or connect to AWS services like S3.

    How it Works:

        Place the NAT Gateway in a public subnet.
        Attach an Elastic IP (EIP) to it.
        Update the route table of the private subnet to route internet traffic (0.0.0.0/0) through the NAT Gateway.


AWS IAM Role

    An AWS IAM Role is a set of permissions that allows AWS services or users to perform actions on AWS resources. Unlike IAM users, roles do not have permanent credentials (username and password). Instead, they provide temporary access through IAM policies.

    In AWS IAM, roles have two separate policies that serve different purposes:

    1. Assume Role Policy (Trust Policy)

        Defines who can assume the role.
        Attached directly to the role during creation.
        Written in JSON format and specifies trusted entities (e.g., AWS services, users, or accounts).

    2. IAM Role Policy (Permission Policy)

        Defines what actions the role can perform.
        Attached separately via IAM Policy Attachment or inline policy.
        Grants permissions on AWS resources (e.g., S3, DynamoDB, EC2).