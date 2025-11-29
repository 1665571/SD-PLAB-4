# Módulo VPC para Terraform

Este módulo permite crear una VPC en AWS de forma flexible y desacoplada, gestionando únicamente la VPC y las subredes públicas y privadas. No crea tablas de rutas ni asociaciones, lo que facilita su reutilización en diferentes arquitecturas y casos de uso.

## Recursos que crea
- VPC
- Subredes públicas y privadas (usando mapas para mayor control)

## Variables principales
- `vpc_name`: Nombre para la VPC y recursos asociados.
- `cidr_block`: CIDR principal de la VPC.
- `public_subnet_cidrs`: Mapa de nombres a CIDRs para subredes públicas.
- `private_subnet_cidrs`: Mapa de nombres a CIDRs para subredes privadas.
- `availability_zones`: Mapa de nombres de subred a zona de disponibilidad.

## Outputs
- `vpc_id`: ID de la VPC creada.
- `public_subnet_ids`: Mapa de nombres a IDs de subredes públicas.
- `private_subnet_ids`: Mapa de nombres a IDs de subredes privadas.

## Ejemplo de uso
```hcl
module "vpc" {
  source               = "./modules/vpc"
  vpc_name             = "mi-vpc"
  cidr_block           = "10.0.0.0/16"
  public_subnet_cidrs  = {
    "subnet1" = "10.0.1.0/24"
    "subnet2" = "10.0.2.0/24"
  }
  private_subnet_cidrs = {
    "subnet3" = "10.0.3.0/24"
    "subnet4" = "10.0.4.0/24"
  }
  availability_zones   = {
    "subnet1" = "eu-west-1a"
    "subnet2" = "eu-west-1b"
    "subnet3" = "eu-west-1a"
    "subnet4" = "eu-west-1b"
  }
}
```

## Consideraciones importantes
- **Tablas de rutas y asociaciones**: Este módulo no crea tablas de rutas ni asociaciones. Deben definirse en el módulo raíz, usando los outputs de este módulo. Esto permite máxima flexibilidad y evita acoplar el módulo a una topología fija.
- **NAT Gateway e Internet Gateway**: Este módulo no crea ni asocia NAT Gateway ni Internet Gateway. Debes crearlos en el módulo raíz y asociar sus IDs en las rutas correspondientes.
- **Mapas en variables**: Usa mapas para definir subredes y zonas, lo que evita problemas de orden y facilita la gestión de recursos.
- **Tags**: Los recursos se etiquetan automáticamente con el nombre de la VPC y el tipo de subred para facilitar la identificación.

## Recomendaciones
- Define las tablas de rutas y asociaciones en el root module para máxima flexibilidad.
- Usa los outputs del módulo para conectar otros recursos (ALB, NAT Gateway, etc.).
- Mantén la consistencia en los nombres de las subredes y zonas de disponibilidad.

---
