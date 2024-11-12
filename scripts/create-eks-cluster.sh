source ./secrets/credentials.sh

CLUSTER_NAME="sikipon-eks"
NODE_COUNT=2
CONTEXT="kube-admin@sikipon-eks-cluster"


check_aws_cli() {
    if ! command -v aws &> /dev/null; then
        echo "AWS CLI could not be found, installing AWS CLI..."
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        unzip awscliv2.zip
        sudo ./aws/install
    else
        echo "AWS CLI is already installed."
    fi
}


check_eksctl() {
    if ! command -v eksctl &> /dev/null; then
        echo "eksctl could not be found, installing eksctl..."
        curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
        sudo mv /tmp/eksctl /usr/local/bin
    else
        echo "eksctl is already installed."
    fi
}


check_aws_iam_authenticator() {
    if ! command -v aws-iam-authenticator &> /dev/null; then
        echo "aws-iam-authenticator could not be found, installing aws-iam-authenticator..."
        curl --silent --location "https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.5.7/aws-iam-authenticator-$(uname -s)-amd64" -o /tmp/aws-iam-authenticator
        sudo mv /tmp/aws-iam-authenticator /usr/local/bin
        sudo chmod +x /usr/local/bin/aws-iam-authenticator
    else
        echo "aws-iam-authenticator is already installed."
    fi
}

# Configure AWS CLI with the provided credentials 
configure_aws_cli() {
    # Check if the profile already exists in credentials and config files
    if ! grep -q "^\[$PROFILE\]" ~/.aws/credentials; then
        echo -e "[$PROFILE]\naws_access_key_id = $AWS_ACCESS_KEY_ID\naws_secret_access_key = $AWS_SECRET_ACCESS_KEY" >> ~/.aws/credentials
    else
        echo "Profile '$PROFILE' already exists in ~/.aws/credentials, skipping."
    fi

    if ! grep -q "^\[$PROFILE\]" ~/.aws/config; then
        echo -e "[$PROFILE]\nregion = us-east-1\noutput = json" >> ~/.aws/config
    else
        echo "Profile '$PROFILE' already exists in ~/.aws/config, skipping."
    fi

    export AWS_PROFILE=$PROFILE
}



create_cluster() {
    echo "Creating EKS cluster '$CLUSTER_NAME' in region '$AWS_DEFAULT_REGION' with $NODE_COUNT nodes..."
    eksctl create cluster --name $CLUSTER_NAME --version 1.30 --region $AWS_DEFAULT_REGION --nodes $NODE_COUNT
}

# Update kubeconfig for EKS cluster access
update_kubeconfig() {
    echo "Updating kubeconfig for the EKS cluster..."
    aws eks --region $AWS_DEFAULT_REGION update-kubeconfig --name $CLUSTER_NAME
}

rename_context() {
    kubectl config rename-context "$(kubectl config current-context)" "$CONTEXT"
}
check_aws_cli
check_eksctl
check_aws_iam_authenticator
configure_aws_cli

# Create the EKS cluster
create_cluster

# Update kubeconfig
update_kubeconfig
rename_context
echo "EKS cluster setup completed successfully."
