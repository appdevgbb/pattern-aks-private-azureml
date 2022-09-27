# Pattern - Using Azure ML on AKS
This is a demo repo to deploy Azure ML on Azure Kubernetes Service cluster.

<p align="center"><img src="https://github.com/appdevgbb/pattern-aks-private-azureml/blob/main/assets/logo.png" width="250" height="250"></p>

### Topology: 

 - [x] Private Cluster
 - [x] Kubenet
 - [x] Calico
 - [x] User Defined Routes
 - [x] Hub-Spoke Topology
 - [x] Jumpbox
 - [x] Azure Firewall
 
### Steps to run this demo

To install the full solution:

1. Run:
```bash
cd default
./run.sh -x install
```

To remove the entire deployment:

1. Run:

```bash
./run.sh -x delete
```

Usage:

```bash
$ ./run.sh 
usage: run.sh [options]
Available Commands:
    [-x  action]        action to be executed.

    Possible verbs are:
        install         creates all of the resources in Azure and in Kubernetes
        destroy         deletes all of the components in Azure plus any KUBECONFIG and Terraform files
        show            shows information about the demo environment (e.g.: connection strings)
```
