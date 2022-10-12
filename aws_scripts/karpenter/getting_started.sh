# need awscli, kubectl, eksctl, helm
# https://karpenter.sh/v0.6.4/getting-started/


export KARPENTER_VERSION=v0.6.4
export CLUSTER_NAME="${USER}-karpenter-demo"
export AWS_DEFAULT_REGION="us-west-2"
export AWS_ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"

# Create a cluster with eksctl. 
# This example configuration file specifies a basic cluster with one initial node 
# and sets up an IAM OIDC provider for the cluster to enable IAM roles for pods:
# This guide uses AWS EKS managed node groups to host Karpenter.
# Karpenter itself can run anywhere, including on self-managed node groups, managed node groups, or AWS Fargate.
# Karpenter will provision EC2 instances in your account.


eksctl create cluster -f - << EOF
---
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig
metadata:
  name: ${CLUSTER_NAME}
  region: ${AWS_DEFAULT_REGION}
  version: "1.21"
  tags:
    karpenter.sh/discovery: ${CLUSTER_NAME}
managedNodeGroups:
  - instanceType: m5.large
    amiFamily: AmazonLinux2
    name: ${CLUSTER_NAME}-ng
    desiredCapacity: 1
    minSize: 1
    maxSize: 10
iam:
  withOIDC: true
EOF

export CLUSTER_ENDPOINT="$(aws eks describe-cluster --name ${CLUSTER_NAME} --query "cluster.endpoint" --output text)"



# Create the KarpenterNode IAM Role
# Instances launched by Karpenter must run with an InstanceProfile that grants permissions necessary to run containers and configure networking. 
# Karpenter discovers the InstanceProfile using the name KarpenterNodeRole-${ClusterName}.
# First, create the IAM resources using AWS CloudFormation.

TEMPOUT=$(mktemp)

curl -fsSL https://karpenter.sh/"v0.6.4"/getting-started/cloudformation.yaml  > $TEMPOUT \
&& aws cloudformation deploy \
  --stack-name "Karpenter-user1-karpenter-demo" \
  --template-file "${TEMPOUT}" \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides "ClusterName=user1-karpenter-demo"


#Second, grant access to instances using the profile to connect to the cluster. 
# This command adds the Karpenter node role to your aws-auth configmap, 
# allowing nodes with this role to connect to the cluster.

eksctl create iamidentitymapping \
  --username system:node:{{EC2PrivateDNSName}} \
  --cluster "${CLUSTER_NAME}" \
  --arn "arn:aws:iam::${AWS_ACCOUNT_ID}:role/KarpenterNodeRole-${CLUSTER_NAME}" \
  --group system:bootstrappers \
  --group system:nodes

# Now, Karpenter can launch new EC2 instances and those instances can connect to your cluster.
# Create the KarpenterController IAM Role 
# Karpenter requires permissions like launching instances. 
# This will create an AWS IAM Role, Kubernetes service account, 
# and associate them using IRSA.

eksctl create iamserviceaccount \
  --cluster "${CLUSTER_NAME}" --name karpenter --namespace karpenter \
  --role-name "${CLUSTER_NAME}-karpenter" \
  --attach-policy-arn "arn:aws:iam::${AWS_ACCOUNT_ID}:policy/KarpenterControllerPolicy-${CLUSTER_NAME}" \
  --role-only \
  --approve

export KARPENTER_IAM_ROLE_ARN="arn:aws:iam::${AWS_ACCOUNT_ID}:role/${CLUSTER_NAME}-karpenter"

# Create the EC2 Spot Service Linked Role 
# This step is only necessary if this is the first time you’re using EC2 Spot in this account. 
# More details are available here. https://docs.aws.amazon.com/batch/latest/userguide/spot_fleet_IAM_role.html

aws iam create-service-linked-role --aws-service-name spot.amazonaws.com
# If the role has already been successfully created, you will see:
# An error occurred (InvalidInput) when calling the CreateServiceLinkedRole operation: Service role name AWSServiceRoleForEC2Spot has been taken in this account, please try a different suffix.


# add chart 
helm repo add karpenter https://charts.karpenter.sh/
helm repo update

#Install the chart passing in the cluster details and the Karpenter role ARN.
# wait for the defaulting webhook to install before creating a Provisioner

helm upgrade --install --namespace karpenter --create-namespace \
  karpenter karpenter/karpenter \
  --version ${KARPENTER_VERSION} \
  --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=${KARPENTER_IAM_ROLE_ARN} \
  --set clusterName=${CLUSTER_NAME} \
  --set clusterEndpoint=${CLUSTER_ENDPOINT} \
  --set aws.defaultInstanceProfile=KarpenterNodeInstanceProfile-${CLUSTER_NAME} \
  --wait 
  
# # The following commands will deploy a Prometheus and Grafana stack 
# # that is suitable for this guide but does not include persistent storage or other configurations 
# # that would be necessary for monitoring a production deployment of Karpenter. 
# # This deployment includes two Karpenter dashboards that are automatically onboaraded to Grafana. 
# # They provide a variety of visualization examples on Karpenter metrices.
# helm repo add grafana-charts https://grafana.github.io/helm-charts
# helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
# helm repo update
# kubectl create namespace monitoring
# curl -fsSL https://karpenter.sh/v0.6.4/getting-started/prometheus-values.yaml | tee prometheus-values.yaml
# helm install --namespace monitoring prometheus prometheus-community/prometheus --values prometheus-values.yaml
# curl -fsSL https://karpenter.sh/v0.6.4/getting-started/grafana-values.yaml | tee grafana-values.yaml
# helm install --namespace monitoring grafana grafana-charts/grafana --values grafana-values.yaml
# # The Grafana instance may be accessed using port forwarding.
# kubectl port-forward --namespace monitoring svc/grafana 3000:80
# # The new stack has only one user, admin, and the password is stored in a secret. 
# # The following command will retrieve the password.
# kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode
# # Uej7tzlccpJNRBm2I45HwkBTobLakU43wfgRNAjB
# ing grafana -o jsonpath="{.data.admin-password}" | base64 --decode
# # Uej7tzlccpJNRBm2I45HwkBTobLakU43wfgRNAjB%



## Provisioner
# A single Karpenter provisioner is capable of handling many different pod shapes. 
# Karpenter makes scheduling and provisioning decisions based on pod attributes such as labels and affinity. 
# In other words, Karpenter eliminates the need to manage many different node groups.

# Create a default provisioner using the command below. 
# This provisioner uses securityGroupSelector and subnetSelector to discover resources used to launch nodes.
# We applied the tag karpenter.sh/discovery in the eksctl command above. 
# Depending how these resources are shared between clusters, you may need to use different tagging schemes.

# The ttlSecondsAfterEmpty value configures Karpenter to terminate empty nodes. 
# This behavior can be disabled by leaving the value undefined.
# Review the provisioner CRD for more information. 
# For example, ttlSecondsUntilExpired configures Karpenter to terminate nodes when a maximum age is reached.
# https://karpenter.sh/v0.6.4/provisioner/
# Note: This provisioner will create capacity as long as the sum of all created capacity is less than the specified limit.

cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: inflate
spec:
  replicas: 0
  selector:
    matchLabels:
      app: inflate
  template:
    metadata:
      labels:
        app: inflate
    spec:
      terminationGracePeriodSeconds: 0
      containers:
        - name: inflate
          image: public.ecr.aws/eks-distro/kubernetes/pause:3.2
          resources:
            requests:
              cpu: 1
EOF
kubectl scale deployment inflate --replicas 5
kubectl logs -f -n karpenter -l app.kubernetes.io/name=karpenter -c controller

# delete the deployment. 
# After 30 seconds (ttlSecondsAfterEmpty),
# Karpenter should terminate the now empty nodes.
kubectl delete deployment inflate
kubectl logs -f -n karpenter -l app.kubernetes.io/name=karpenter -c controller

# Cleanup - To avoid additional charges, remove the demo infrastructure from your AWS account.
helm uninstall karpenter --namespace karpenter
aws iam delete-role --role-name "${CLUSTER_NAME}-karpenter"
aws cloudformation delete-stack --stack-name "Karpenter-${CLUSTER_NAME}"
aws ec2 describe-launch-templates \
    | jq -r ".LaunchTemplates[].LaunchTemplateName" \
    | grep -i "Karpenter-${CLUSTER_NAME}" \
    | xargs -I{} aws ec2 delete-launch-template --launch-template-name {}
eksctl delete cluster --name "${CLUSTER_NAME}"