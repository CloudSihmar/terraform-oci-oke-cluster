resource "oci_core_vcn" "FoggyKitchenVCN" {
  cidr_block     = var.VCN-CIDR
  compartment_id = oci_identity_compartment.kubeCompartment.id
  display_name   = "kubeVCN"
}

resource "oci_core_internet_gateway" "kubeInternetGateway" {
  compartment_id = oci_identity_compartment.kubeCompartment.id
  display_name   = "kubeInternetGateway"
  vcn_id         = oci_core_vcn.kubeVCN.id
}

resource "oci_core_route_table" "kubeRouteTableViaIGW" {
  compartment_id = oci_identity_compartment.kubeCompartment.id
  vcn_id         = oci_core_vcn.kubeVCN.id
  display_name   = "kubeRouteTableViaIGW"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id =  oci_core_internet_gateway.kubeInternetGateway.id
  }
}

resource "oci_core_security_list" "kubeOKESecurityList" {
    compartment_id = oci_identity_compartment.kubeCompartment.id
    display_name = "kubeOKESecurityList"
    vcn_id = oci_core_vcn.kubeVCN.id
    
    egress_security_rules {
        protocol = "All"
        destination = "0.0.0.0/0"
    }

    /* This entry is necesary for DNS resolving (open UDP traffic). */
    ingress_security_rules {
        protocol = "17"
        source = var.VCN-CIDR
    }
}

resource "oci_core_subnet" "kubeClusterSubnet" {
  cidr_block          = var.kubeClusterSubnet-CIDR
  compartment_id      = oci_identity_compartment.kubeCompartment.id
  vcn_id              = oci_core_vcn.kubeVCN.id
  display_name        = "kubeClusterSubnet"

  security_list_ids = [oci_core_vcn.kubeVCN.default_security_list_id, oci_core_security_list.kubeOKESecurityList.id]
  route_table_id    = oci_core_route_table.kubeRouteTableViaIGW.id
}

resource "oci_core_subnet" "kubeNodePoolSubnet" {
  cidr_block          = var.kubeNodePoolSubnet-CIDR
  compartment_id      = oci_identity_compartment.kubeCompartment.id
  vcn_id              = oci_core_vcn.kubeVCN.id
  display_name        = "kubeNodePoolSubnet"

  security_list_ids = [oci_core_vcn.kubeVCN.default_security_list_id, oci_core_security_list.kubeOKESecurityList.id]
  route_table_id    = oci_core_route_table.kubeRouteTableViaIGW.id
}

