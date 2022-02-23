resource "aws_vpc" "current" {
  cidr_block = var.vpc_cidr

  tags = merge(local.eks_metadata_tags, {
    yor_trace = "e7249a85-a665-4228-b925-8a37ca80b423"
  })
}

resource "aws_subnet" "current" {
  count = length(var.availability_zones)

  availability_zone       = var.availability_zones[count.index]
  cidr_block              = cidrsubnet(aws_vpc.current.cidr_block, var.vpc_control_subnet_newbits, count.index)
  vpc_id                  = aws_vpc.current.id
  map_public_ip_on_launch = true

  tags = merge(local.eks_metadata_tags, {
    yor_trace = "8f018265-f62d-4d3b-a865-5cb8b810e525"
  })
}

resource "aws_subnet" "node_pool" {
  count = var.vpc_legacy_node_subnets ? 0 : length(var.availability_zones)

  availability_zone       = var.availability_zones[count.index]
  cidr_block              = cidrsubnet(aws_vpc.current.cidr_block, var.vpc_node_subnet_newbits, var.vpc_node_subnet_number_offset + count.index)
  vpc_id                  = aws_vpc.current.id
  map_public_ip_on_launch = true

  tags = merge(local.eks_metadata_tags, {
    yor_trace = "d7876b05-c32a-48d9-a53e-3922e3afdac9"
  })
}

resource "aws_internet_gateway" "current" {
  vpc_id = aws_vpc.current.id

  tags = merge(local.eks_metadata_tags, {
    yor_trace = "2b2e813d-a71c-41fc-b003-b5b81ee73026"
  })
}

resource "aws_route_table" "current" {
  vpc_id = aws_vpc.current.id
  tags = {
    yor_trace = "46a9e1c8-f150-4e60-91d2-372d70f0f9d6"
  }
}

resource "aws_route" "current" {
  route_table_id = aws_route_table.current.id

  gateway_id             = aws_internet_gateway.current.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "current" {
  count = length(var.availability_zones)

  subnet_id      = aws_subnet.current[count.index].id
  route_table_id = aws_route_table.current.id
}

resource "aws_route_table_association" "node_pool" {
  count = var.vpc_legacy_node_subnets ? 0 : length(var.availability_zones)

  subnet_id      = aws_subnet.node_pool[count.index].id
  route_table_id = aws_route_table.current.id
}
