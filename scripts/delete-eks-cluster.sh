source ./secrets/credentials.sh


CLUSTER_NAME="sikipon-eks"


delete_cluster() {
    echo "Deleting EKS cluster '$CLUSTER_NAME' from AWS sandbox..."
    eksctl delete cluster --name $CLUSTER_NAME --region $AWS_DEFAULT_REGION
}

# Delete the EKS cluster
delete_cluster
