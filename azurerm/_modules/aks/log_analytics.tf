resource "azurerm_log_analytics_workspace" "current" {
  name                = var.metadata_name
  location            = data.azurerm_resource_group.current.location
  resource_group_name = data.azurerm_resource_group.current.name
  sku                 = "PerGB2018"

  tags = merge(var.metadata_labels, {
    yor_trace = "09e21ee3-5138-4411-98b6-4ad31cebeb4a"
  })
}

resource "azurerm_log_analytics_solution" "current" {
  solution_name         = "ContainerInsights"
  location              = data.azurerm_resource_group.current.location
  resource_group_name   = data.azurerm_resource_group.current.name
  workspace_resource_id = azurerm_log_analytics_workspace.current.id
  workspace_name        = azurerm_log_analytics_workspace.current.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
  tags = {
    yor_trace = "7eac8375-f3f8-4f3b-87bc-c70d2359d93b"
  }
}

