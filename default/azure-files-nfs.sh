# https://learn.microsoft.com/en-us/azure/aks/azure-files-csi

load_env() {
  export TF_OUTPUTS=$(terraform output -json | jq -r)

  export AKS_CLUSTER_NAME=$(echo "$TF_OUTPUTS" | jq -r .aks_cluster_name.value)
  export RGNAME=$(echo $TF_OUTPUTS | jq -r .resource_group_name.value)
  export SUBSCRIPTION_ID=$(echo "$TF_OUTPUTS" | jq -r .subscription_id.value)
  export STORAGE_ACCOUNT_NAME=$(echo "$TF_OUTPUTS" | jq -r .nfs_storage_account_name.value)
}

create_private_azure_file_sc() {
cat << EOF > manifests/private-azure-file-sc.yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: private-azurefile-csi
provisioner: file.csi.azure.com
allowVolumeExpansion: true
parameters:
  resourceGroup: $RGNAME
  storageAccount: $STORAGE_ACCOUNT_NAME
  server: $STORAGE_ACCOUNT_NAME.privatelink.file.core.windows.net 
reclaimPolicy: Delete
volumeBindingMode: Immediate
mountOptions:
  - dir_mode=0777
  - file_mode=0777
  - uid=0
  - gid=0
  - mfsymlinks
  - cache=strict  # https://linux.die.net/man/8/mount.cifs
  - nosharesock  # reduce probability of reconnect race
  - actimeo=30  # reduce latency for metadata-heavy workload
EOF
}

create_private_pvc() {
cat << EOF > manifests/private-pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: private-azurefile-pvc
spec:
  accessModes:
    - ReadWriteMany
  storageClassName: private-azurefile-csi
  resources:
    requests:
      storage: 100Gi
EOF
}

create_nfs_file_share() {
cat << EOF >  manifests/nfs-sc.yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: azurefile-csi-nfs
provisioner: file.csi.azure.com
allowVolumeExpansion: true
parameters:
  protocol: nfs
mountOptions:
  - nconnect=8
EOF
}

apply_to_cluster() {
    cd manifests && az aks command invoke -n $AKS_CLUSTER_NAME -g $RGNAME -c "kubectl -n azureml apply -k ."  -f . && cd -
}

nfs_demo_entrypoint() {
  load_env
  create_private_azure_file_sc
  create_private_pvc
  create_nfs_file_share
  apply_to_cluster
}