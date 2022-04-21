#!/bin/bash

# Added color constants
RED='\033[0;31m'
NC='\033[0m'

# Add announcement that this script has just started with timestamp
echo -e "${RED}Script started at $(date +%T)${NC}"

while getopts ":e:n:" o; do
    case "${o}" in
        e) env_name=$OPTARG;;
        n) chart_name=$OPTARG;;
        *) echo "No reasonable options found"
    esac
done

# Create storage-class if not exists
get_sc=$(kubectl get sc "happy-bank-local-storage" --no-headers 2>/dev/null)
if [ -n "${get_sc}" ]; then
    echo -e "${RED}Storage class exists:${NC}"
    kubectl get sc
else
    echo "Creating storage class"
    kubectl apply -f kubernetes/storage-class.yml
fi

# Create namespace
get_ns=$(kubectl get ns "$env_name" --no-headers 2>/dev/null)
if [ -n "${get_ns}" ]; then
    echo -e "${RED}Environment selected for helm chart deployment:${NC}"
    echo "$get_ns"
else
    echo "Namespace $env_name not found"
    echo "Creating namespace $env_name"
    kubectl create ns "$env_name"
fi

# Generate secret token and pass it to values.yaml
echo -e "${RED}Generating secret token${NC}"
token="$(date +%T | sha1sum | awk '{print $1}')"
sed -i "s/<CORE_TOKEN>/$token/g" ./helm/values.yaml

# Deploy helm chart to selected namespace
echo -e "${RED}Deploying Helm Chart${NC}"
get_helm_charts=$(helm list --namespace "$env_name" | grep "$chart_name")
if [ -n "${get_helm_charts}" ]; then
    echo "Helm chart with given name already exists:"
    echo "$get_helm_charts"
    echo -e "${RED}Script ended at $(date +%T)${NC}"
    exit
else
    helm install "$chart_name" --namespace "$env_name" ./helm
fi

# List helm charts in selected namespace
echo -e "${RED}Deployed helm charts in selected namespace${NC}"
helm list --namespace "$env_name"

# Add announcement that this script has ended with timestamp
echo -e "${RED}Script ended at $(date +%T)${NC}"
