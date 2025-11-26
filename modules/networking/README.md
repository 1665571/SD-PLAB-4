# Networking Module

Módulo de Terraform para crear infraestructura de red en AWS con alta disponibilidad multi-AZ.

## Características

- VPC con CIDR configurable
- Subnets públicas y privadas en múltiples AZs (por defecto 2)
- Internet Gateway para acceso a Internet
- NAT Gateways para salida de instancias privadas
- Security Groups para ALB e instancias
- Route Tables configuradas automáticamente

## Arquitectura

```
VPC (10.0.0.0/16)
├── Internet Gateway
├── AZ-1 (eu-west-1a)
│   ├── Public Subnet (10.0.1.0/24)
│   │   ├── ALB Node
│   │   └── NAT Gateway
│   └── Private Subnet (10.0.11.0/24)
│       └── EC2 Instances
└── AZ-2 (eu-west-1b)
    ├── Public Subnet (10.0.2.0/24)
    │   ├── ALB Node
    │   └── NAT Gateway
    └── Private Subnet (10.0.12.0/24)
        └── EC2 Instances
```

## Uso

```hcl
module "networking" {
  source = "../../modules/networking"
  
  environment        = "prod"
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["eu-west-1a", "eu-west-1b"]
  
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
  
  # Alta disponibilidad: un NAT Gateway por AZ
  enable_nat_gateway = true
  single_nat_gateway = false
  
  tags = {
    Project     = "Blue-Green-Deployment"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}
```

## Variables

| Variable | Descripción | Tipo | Default |
|----------|-------------|------|---------|
| `environment` | Nombre del entorno | `string` | - |
| `vpc_cidr` | CIDR de la VPC | `string` | `"10.0.0.0/16"` |
| `availability_zones` | Lista de AZs | `list(string)` | `["eu-west-1a", "eu-west-1b"]` |
| `public_subnet_cidrs` | CIDRs de subnets públicas | `list(string)` | `["10.0.1.0/24", "10.0.2.0/24"]` |
| `private_subnet_cidrs` | CIDRs de subnets privadas | `list(string)` | `["10.0.11.0/24", "10.0.12.0/24"]` |
| `enable_nat_gateway` | Habilitar NAT Gateway | `bool` | `true` |
| `single_nat_gateway` | Usar un solo NAT (ahorro) | `bool` | `false` |
| `tags` | Tags comunes | `map(string)` | `{}` |

## Outputs

| Output | Descripción |
|--------|-------------|
| `vpc_id` | ID de la VPC |
| `vpc_cidr` | CIDR de la VPC |
| `public_subnet_ids` | IDs de subnets públicas |
| `private_subnet_ids` | IDs de subnets privadas |
| `availability_zones` | AZs utilizadas |
| `nat_gateway_ids` | IDs de NAT Gateways |
| `alb_security_group_id` | ID del Security Group del ALB |
| `instances_security_group_id` | ID del Security Group de instancias |
| `internet_gateway_id` | ID del Internet Gateway |

## Costes Estimados

- **VPC**: Gratis
- **Subnets**: Gratis
- **Internet Gateway**: Gratis
- **NAT Gateway**: ~$0.045/hora (~$32/mes por NAT)
  - 2 AZs con `single_nat_gateway = false`: ~$64/mes
  - 2 AZs con `single_nat_gateway = true`: ~$32/mes (menos HA)

## Consideraciones

### Alta Disponibilidad

- **Máxima HA**: `single_nat_gateway = false` (un NAT por AZ)
  - Si una AZ falla, la otra sigue funcionando completamente
  - Coste: ~$64/mes

- **Ahorro de costes**: `single_nat_gateway = true` (un solo NAT)
  - Si la AZ del NAT falla, las instancias en la otra AZ no pueden salir a Internet
  - Coste: ~$32/mes
  - Recomendado solo para dev/testing

### Security Groups

- **ALB Security Group**: Permite HTTP/HTTPS desde Internet (0.0.0.0/0)
- **Instances Security Group**: Solo permite tráfico desde el ALB
  - Las instancias NO son accesibles directamente desde Internet
  - Solo el ALB puede comunicarse con ellas

## Ejemplo Completo

Ver `live/prod/shared/main.tf` para un ejemplo de uso completo.
