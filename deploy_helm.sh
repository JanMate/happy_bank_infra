#!/bin/bash

# Added color constants
RED='\033[0;31m'
NC='\033[0m'

# Add announcement that this script has just started with timestamp
echo -e "${RED}Script started at $(date +%T)${NC}"

# Create dev environment if not exist
echo -e "${RED}Creating dev environment${NC}"
kubectl create namespace dev

# Create staging environment if not exist
echo -e "${RED}Creating staging environment${NC}"
kubectl create namespace stag

# Create production environment if not exist
echo -e "${RED}Creating production environment${NC}"
kubectl create namespace prod

# Read the argument with selected namespace
ns="${1:-"dev"}"
if [ "$ns" = "dev" ] || [ "$ns" = "stag" ] || [ "$ns" = "prod" ]; then
    echo -e "${RED}Environment selected for helm chart deployment:${NC}"
    echo "$ns"
else
    echo -e "${RED}Environment with given name doesn't exist${NC}"
    echo -e "${RED}Script ended at $(date +%T)${NC}"
    exit
fi

# Generate secret token and pass it to values.yaml
echo -e "${RED}Generating secret token${NC}"
token="$(date +%T | sha1sum | awk '{print $1}')"
echo "$token"
sed -i "s/<CORE_TOKEN>/$token/g" ./helm/values.yaml

# Deploy helm chart to selected namespace
echo -e "${RED}Deploying helm chart${NC}"
chart_name="${2:-"happy-bank"}"
helm install "$chart_name" --namespace "$ns" ./helm

# List helm charts in selected namespace
echo -e "${RED}Deployed helm charts in selected namespace${NC}"
helm list --namespace "$ns"


