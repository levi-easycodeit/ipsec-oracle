# Site to Site IPSEC na Oracle Cloud


### Inicialização do Projeto




1. **Tenha o Terraform:**
   -  Versão utilizada para o laboratório foi 1.6.1




2. **Tenha  o OCI CLI:**
   -  Versão utilizada para o laboratório foi 3.44.3








   
### Executando o script


1.Iniciar as variáveis necessárias nos arquivos availability_domain.tf ,provider.tf e vpn.tf
No arquivo vpn.tf se atentar aos valores das variáveis cpe_ip_address e static_routes, que devem ser preenchidas com os valores válidos do cliente 


2. Executar os comandos terraform


 ```sh
terraform init
terraform plan
terraform apply
```