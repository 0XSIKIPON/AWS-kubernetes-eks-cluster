# Define variables for paths
CREDENTIALS_FILE=./secrets/credentials.sh
CREATE_SCRIPT=./scripts/create-eks-cluster.sh
DELETE_SCRIPT=./scripts/delete-eks-cluster.sh

# Load credentials and create the EKS cluster
eks-cluster:
	@echo "Sourcing credentials and creating EKS cluster..."
	@bash -c "source $(CREDENTIALS_FILE) && bash $(CREATE_SCRIPT)"

# Load credentials and delete the EKS cluster
delete-cluster:
	@echo "Sourcing credentials and deleting EKS cluster..."
	@bash -c "source $(CREDENTIALS_FILE) && bash $(DELETE_SCRIPT)"
