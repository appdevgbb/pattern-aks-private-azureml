output "acr" {
  value = azurerm_container_registry.default
}

output "cluster_name" {
  value = azurerm_kubernetes_cluster.dev.name
}