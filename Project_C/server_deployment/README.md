# second_infra

<!-- BEGINNING OF PRE-COMMIT-OPENTOFU DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.8.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.2.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.2.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 4.0.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_remote_servers"></a> [remote\_servers](#module\_remote\_servers) | ../modules | n/a |
| <a name="module_server_group_1"></a> [server\_group\_1](#module\_server\_group\_1) | ../modules | n/a |
| <a name="module_server_group_2"></a> [server\_group\_2](#module\_server\_group\_2) | ../modules | n/a |
| <a name="module_server_group_3"></a> [server\_group\_3](#module\_server\_group\_3) | ../modules | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.main_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_virtual_network.vn](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_1_public_ip"></a> [client\_1\_public\_ip](#output\_client\_1\_public\_ip) | n/a |
| <a name="output_client_2_public_ip"></a> [client\_2\_public\_ip](#output\_client\_2\_public\_ip) | n/a |
| <a name="output_client_3_public_ip"></a> [client\_3\_public\_ip](#output\_client\_3\_public\_ip) | n/a |
| <a name="output_remote_servers_public_ips"></a> [remote\_servers\_public\_ips](#output\_remote\_servers\_public\_ips) | n/a |
<!-- END OF PRE-COMMIT-OPENTOFU DOCS HOOK -->