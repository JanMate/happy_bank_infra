#!/bin/bash

# Added color constants
RED='\033[0;31m'
NC='\033[0m'

check_if_exists_func()
{
  get_resource=$(kubectl get "$1" | grep "$2")
  if [ -n "${get_resource}" ]; then
    echo "$get_resource"
  else
    echo "$2 not found"
    kubectl get "$1"
    exit
  fi
}

# Add announcement that this script has just started with timestamp
echo -e "${RED}Script started at $(date +%T)${NC}"

# Generate secret token and pass it to secret.yml
echo -e "${RED}Generating secret token${NC}"
token="$(date +%T | sha1sum | awk '{print $1}')"
echo "$token"
sed -i "s/<CORE_TOKEN>/$token/g" ./kubernetes/core-secret.yml

# Deploy and verify storage resources
echo -e "${RED}Deploying storage resources${NC}"
kubectl apply -f ./kubernetes/storage.yml
check_if_exists_func 'pv' 'core-pv'
check_if_exists_func 'pvc' 'core-pvc'
check_if_exists_func 'StorageClass' 'local-storage'


# Deploy and verify core-app secret
echo -e "${RED}Deploying core secret${NC}"
kubectl apply -f ./kubernetes/core-secret.yml
check_if_exists_func 'secret' 'core-secret'
echo "--------------------------------------"

# Deploy and verify redis configmap
echo -e "${RED}Deploying redis configmap${NC}"
kubectl apply -f ./kubernetes/redis-config.yml
check_if_exists_func 'ConfigMap' 'redis-configmap'
echo "--------------------------------------"

# Deploy and verify core-app service
echo -e "${RED}Deploying core app service${NC}"
kubectl apply -f ./kubernetes/core-svc.yml
check_if_exists_func 'svc' 'core-app-svc'
echo "--------------------------------------"

# Deploy and verify ingress
echo -e "${RED}Deploying ingress${NC}"
kubectl apply -f ./kubernetes/ingress.yml
check_if_exists_func 'ingress' 'core-ingress'
echo "--------------------------------------"

# Deploy and verify core-deployment
echo -e "${RED}Deploying core app deployment${NC}"
kubectl apply -f ./kubernetes/core-deployment.yml
check_if_exists_func 'deploy' 'core-deployment'
kubectl wait --for=condition=available --timeout=180s deploy/core-deployment
echo "--------------------------------------"

# Verify pods
echo -e "${RED}Verifying running pods${NC}"
check_if_exists_func 'pods' 'core-deployment'
echo "--------------------------------------"

# Deploy and verify core-app verification job
echo -e "${RED}Deploying core app verification job${NC}"
kubectl apply -f ./kubernetes/core-job.yml
check_if_exists_func 'job' 'core-job'
kubectl wait --for=condition=complete --timeout=60s job/core-job
echo "--------------------------------------"

echo -e "${RED}Script ended at $(date +%T)${NC}"