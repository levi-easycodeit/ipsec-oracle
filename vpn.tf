# Criação da VCN
resource "oci_core_vcn" "vcn" {
  cidr_block      = "10.0.0.0/16"
  compartment_id  = var.compartment_id
  display_name    = "example_vcn"
}

# Criação de Subnet
resource "oci_core_subnet" "subnet" {
  cidr_block             = "10.0.1.0/24"
  compartment_id         = var.compartment_id
  vcn_id                 = oci_core_vcn.vcn.id
  display_name           = "example_subnet"
  availability_domain    = var.availability_domain
  security_list_ids      = [oci_core_security_list.security_list.id]
}

# Criação de Security List
resource "oci_core_security_list" "security_list" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id

  # Regras que façam sentido para o cliente
  egress_security_rules {
    protocol     = "all"
    destination  = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol     = "6"
    source       = "0.0.0.0/0"
    tcp_options {
      min        = 22
      max        = 22
    }
  }
}

# Criação do Dynamic Routing Gateway (DRG)
resource "oci_core_drg" "drg" {
  compartment_id = var.compartment_id
  display_name   = "example_drg"
}

# Conectando DRG ao VCN
resource "oci_core_drg_attachment" "drg_attachment" {
  drg_id = oci_core_drg.drg.id
  vcn_id = oci_core_vcn.vcn.id
}

# Criação do Customer-Premises Equipment (CPE)
resource "oci_core_cpe" "cpe" {
  compartment_id = var.compartment_id
  ip_address     = var.cpe_ip_address
  display_name   = "example_cpe"
}

# Criação do IPsec Connection
resource "oci_core_ipsec" "ipsec" {
  compartment_id = var.compartment_id
  cpe_id         = oci_core_cpe.cpe.id
  drg_id         = oci_core_drg.drg.id
  display_name   = "example_ipsec"
  static_routes  = var.static_routes
}

# Atualizando Route Table
resource "oci_core_default_route_table" "default_route_table" {
  manage_default_resource_id = oci_core_vcn.vcn.default_route_table_id
  route_rules {
    network_entity_id = oci_core_drg.drg.id
    destination       = "0.0.0.0/0"
  }
}

# Variáveis
variable "tenancy_ocid" {
  description = "O OCID da sua locação"
  default = ""
}

variable "user_ocid" {
  description = "O OCID do usuário"
  default = "" 
}

variable "fingerprint" {
  description = "A impressão digital da chave de API do usuário"
  default = ""
}

variable "private_key_path" {
  description = "O caminho para a chave privada"
  default = ""
}

variable "region" {
  description = "A região para se conectar"
  default = ""
}

variable "compartment_id" {
  description = "O OCID do compartimento"
  default = ""
}

variable "availability_domain" {
  description = "O domínio de disponibilidade para a sub-rede"
  default = ""
}

variable "cpe_ip_address" {
  description = "O endereço IP do equipamento de cliente"
  default = ""
}

variable "static_routes" {
  description = "As rotas estáticas para a conexão IPsec"
  type        = list(string)
  default     = ["0.0.0.0/0"] #Exemplo
}
