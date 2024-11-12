# AWS-kubernetes-eks-cluster

### Description:
* A small script to automate Amazon EKS cluster setup, including AWS CLI and eksctl installation, profile configuration, and kubeconfig setup for kubectl access. Simplifies EKS cluster creation and management for streamlined DevOps workflows.

### Features

* **Automated Installation**: Installs AWS CLI, eksctl, and aws-iam-authenticator if they’re not already installed.
* **AWS Profile Setup**: Configures AWS credentials and profile settings automatically.
* **EKS Cluster Provisioning**: Creates an EKS cluster with the specified number of nodes.
* **kubeconfig Setup**: Configures kubectl to access the new EKS cluster seamlessly

### Prerequisites

* **AWS Account**: Ensure you have an AWS account with the necessary permissions to create EKS clusters.
* **AWS Credentials**: Store your AWS access key and secret in `./secrets/credentials.sh`.
* **Bash Shell**: This script is written for bash; it should be run in a bash-compatible environment.
* At least one EC2 instance or an aws sandboox needed to be start then cloning the repo and changing the creds under `./secrets/credentials.sh` we run this command to provision the kubernetes cluster on the top of the aws instance :
```bash
make eks-cluster
```
After few minutes the cluster will be up 

Check it by running 
```bash
kubectl get nodes 
kubectl get pods -n kube-system 
kubectl get cm 
```
Then once finishing working with the cluster ro clean up, run :
```bash
make delete-cluster 
```