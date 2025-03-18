# AWS Profiles Configuration

<h1> Developer Profile </h1>

- First create access keys for developer profile and follow next steps

```bash
aws configure --profile developer

# it retrieves information about the IAM user or role
aws sts get-caller-identity --profile developer

# connect on aws using develper profile
aws eks update-kubeconfig --region sa-east-1 --name staging-demo --profile developer

# check the local kubernetes uses developer profile
kubectl config view --minify 

kubectl get pods
kubectl auth can-i get pods
kubectl auth can-i "*" "*" 
```

<h1> Manager Profile </h1>

- First create access keys for manager profile and follow next steps

```bash
aws configure --profile manager
aws sts get-caller-identity --profile manager

# connect on aws using manager profile
aws eks update-kubeconfig --region sa-east-1 --name staging-demo --profile manager

# check the local kubernetes uses manager profile
kubectl config view --minify 

kubectl get pods
kubectl auth can-i get pods
kubectl auth can-i "*" "*" 
```

<h1> EKS Admin Role </h1>

- It uses manager profile to create a temporary EKS Admin Role

- Manually configures following next steps

```bash
vi ~/.aws/config
    [default]
    [profile develper]
    [profile manager]

    [profile eks-admin]
    role_arn = arn:aws:iam::xxxxxxxxx:role/staging-demo-eks-admin
    source_profile = manager
``` 
<h1> Different Profiles </h1>

```bash
# If you want to set a default profile to be used for all commands (without having to specify --profile each time)
export AWS_PROFILE=profile_name

# List Available Profiles
cat ~/.aws/credentials
```

The eks-admin (aws iam role) bounds to my-admin (kubernetes cluster)
The developer (aws iam user) bounds to my-viewer (kubernetes cluster)

Sources: https://www.youtube.com/watch?v=6COvT1Zu9o0