#! /bin/bash

export TF_OUTPUTS=$(terraform output -json | jq -r)

export AKS_CLUSTER_NAME=$(echo $TF_OUTPUTS | jq -r .aks_cluster_name.value)
export RGNAME=$(echo $TF_OUTPUTS | jq -r .resource_group_name.value)
export AML_WORKSPACE_NAME=$(echo $TF_OUTPUTS | jq -r .aml_workspace_name.value)
export AML_K8S_NAMESPACE="azure-ml"
export SUBSCRIPTION_ID=$(echo $TF_OUTPUTS | jq -r .subscription_id.value)

## Install AML Extension for K8s Cluster (AKS)
## https://learn.microsoft.com/en-us/azure/machine-learning/how-to-deploy-kubernetes-extension?tabs=deploy-extension-with-cli#azureml-extension-deployment---cli-examples-and-azure-portal

az provider register --namespace Microsoft.KubernetesConfiguration
az extension add --name k8s-extension
az extension add --name ml

# For demo setup:

az k8s-extension create \
    --name aml-compute \
    --extension-type Microsoft.AzureML.Kubernetes \
    --config \
        enableTraining=True \
        enableInference=True \
        inferenceRouterServiceType=LoadBalancer \
        allowInsecureConnections=True \
        inferenceLoadBalancerHA=False \
    --cluster-type managedClusters \
    --cluster-name $AKS_CLUSTER_NAME \
    --resource-group $RGNAME \
    --scope cluster \
    --debug

## For prod training and inference: 
#
# az k8s-extension create \
#     --name <extension-name> \
#     --extension-type Microsoft.AzureML.Kubernetes \
#     --config \
#         enableTraining=True \
#         enableInference=True \
#         inferenceRouterServiceType=LoadBalancer \
#         sslCname=<ssl cname> \
#     --config-protected \
#         sslCertPemFile=<file-path-to-cert-PEM> \
#         sslKeyPemFile=<file-path-to-cert-KEY> \
#     --cluster-type managedClusters \
#     --cluster-name $AKS_CLUSTER_NAME \
#     --resource-group $RGNAME \
#     --scope cluster

## Attach AKS to an AML workspace
## https://learn.microsoft.com/en-us/azure/machine-learning/how-to-attach-kubernetes-to-workspace?tabs=cli

az ml compute attach \
    --resource-group $RGNAME \
    --workspace-name $AML_WORKSPACE_NAME \
    --type Kubernetes \
    --name k8s-compute \
    --resource-id "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RGNAME/providers/Microsoft.ContainerService/managedclusters/$AKS_CLUSTER_NAME" \
    --identity-type SystemAssigned \
    --namespace $AML_K8S_NAMESPACE \
    --debug

# az k8s-extension show \
#     --name azureml \
#     --cluster-name <clusterName> \
#     --resource-group <resourceGroupName> \
#     --cluster-type managedClusters