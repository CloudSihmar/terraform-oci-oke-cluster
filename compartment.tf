resource "oci_identity_compartment" "kubeCompartment" {
  name = "kube"
  description = "Kube Compartment"
}
