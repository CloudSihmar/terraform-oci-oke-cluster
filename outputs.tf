output "FoggyKitchenOKECluster" {
  value = {
    id                 = oci_containerengine_cluster.kubeOKECluster.id
    kubernetes_version = oci_containerengine_cluster.kubeOKECluster.kubernetes_version
    name               = oci_containerengine_cluster.kubeOKECluster.name
  }
}

output "FoggyKitchenOKENodePool" {
  value = {
    id                 = oci_containerengine_node_pool.kubeOKENodePool.id
    kubernetes_version = oci_containerengine_node_pool.kubeOKENodePool.kubernetes_version
    name               = oci_containerengine_node_pool.kubeOKENodePool.name
    subnet_ids         = oci_containerengine_node_pool.kubeOKENodePool.subnet_ids
  }
}

output "FoggyKitchen_Cluster_Kubernetes_Versions" {
  value = [data.oci_containerengine_cluster_option.kubeOKEClusterOption.kubernetes_versions]
}

output "FoggyKitchen_Cluster_NodePool_Kubernetes_Version" {
  value = [data.oci_containerengine_node_pool_option.kubeOKEClusterNodePoolOption.kubernetes_versions]
}
