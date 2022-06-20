# GameX - TP Cloud
Steam clone deployment on AWS built with terraform

Arquitectura basada en microservicios utilizando ECS completamente desarrollada en Terraform.

## Autores

- [Brandy Tobias](https://github.com/tobiasbrandy)
- [Legammare Joaquin](https://github.com/JoacoLega)
- [Manfredi Agustin](https://github.com/imanfredi)
- [Silvatici Gabriel](https://github.com/gsilvatici)

## Instructivo para deployar aplicación terraform

### 1. Terraform

Instalar [terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) siguiendo la documentación oficial.

### 2. Amazon Web Services

1. Opcionalmente crear un nuevo usuario para que utilice terraform. Idealmente con permisos `AdministratorAccess` para simplificar manejo de permisos.
2. Crear y guardar access keys de usuario en `$HOME/.aws/credentials`.
3. Crear una `HostedZone` en `Route53` del dominio elegido para usar por la aplicación. En caso de ser un subdominio, crear en el padre el record NS que apunte a este.

### 3. Deployar Backend

El backend es el sistema que tenemos para almacenar el state de terraform generado. En este caso utilizaremos un S3 encriptado con una llave en KMS. Es por esto que antes de deployar nuestro proyecto tendremos que crear estos recursos.

1. En el archivo `backend/config.tfvars` deberemos configurar los siguientes parametros:
    - `authorized_role`: El nombre del rol con el cual terraform tendra permiso para manipular el bucket s3 y la key KMS. En AWS Academy, `LabRole`.
    - `aws_region`: La region AWS donde queremos almacenar el state.

    Se incluye un archivo de ejemplo para modificar.

2. Ejecutar `init_backend.sh`. Se deberia crear el archivo de configuracion de backend `backend_config.tfvars`.

### 4. Deployar Aplicacion

1. En el archivo `config.tfvars` deberemos configurar los siguientes parametros:
    
    - `app_domain`: Dominio o subdominio de la aplicacion para la cual creamos la `HostedZone` en `Route53`.
    - `authorized_role`: El nombre del rol al cual se le asignara a los servicios que lo requieran. En AWS Academy, `LabRole`.
    - `aws_region`: Region de AWS en donde deployar.
    - `db_user`: Usuario para la base de datos RDS.
    - `db_pass`: Password para la base de datos RDS.

  Se incluye un archivo de ejemplo para modificar.

2. Ejecutar `terraform init -backend-config=backend_config.tfvars` para inicializar terraform.
3. Ejecutar `terraform apply -var-file=config.tfvars -auto-approve` para empezar a deployar.

Tener en cuenta que el proceso puede durar varios minutos, y que una vez finalizado puede tomar unos minutos hasta que el sitio se pueda acceder.

