resource "azurerm_public_ip" "current" {
  count = var.disable_default_ingress ? 0 : 1

  name                = var.metadata_name
  location            = azurerm_kubernetes_cluster.current.location
  resource_group_name = azurerm_kubernetes_cluster.current.node_resource_group
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = merge(var.metadata_labels, {
    yor_trace = "d2cad6f8-42e2-43bd-831d-60518f481cb8"
  })

  depends_on = [azurerm_kubernetes_cluster.current]
}

resource "azurerm_dns_zone" "current" {
  count = var.disable_default_ingress ? 0 : 1

  name                = var.metadata_fqdn
  resource_group_name = data.azurerm_resource_group.current.name

  tags = merge(var.metadata_labels, {
    yor_trace = "d1af872d-13b3-4fe9-a156-62f799dfec27"
  })
}

resource "azurerm_dns_a_record" "host" {
  count = var.disable_default_ingress ? 0 : 1

  name                = "@"
  zone_name           = azurerm_dns_zone.current[0].name
  resource_group_name = data.azurerm_resource_group.current.name
  ttl                 = 300
  records             = [azurerm_public_ip.current[0].ip_address]

  tags = merge(var.metadata_labels, {
    yor_trace = "1ba45e91-634a-4a85-b790-72459a40e80b"
  })
}

resource "azurerm_dns_a_record" "wildcard" {
  count = var.disable_default_ingress ? 0 : 1

  name                = "*"
  zone_name           = azurerm_dns_zone.current[0].name
  resource_group_name = data.azurerm_resource_group.current.name
  ttl                 = 300
  records             = [azurerm_public_ip.current[0].ip_address]

  tags = merge(var.metadata_labels, {
    yor_trace = "34fbcafe-7f50-4570-acef-a07a965fdfbd"
  })
}
