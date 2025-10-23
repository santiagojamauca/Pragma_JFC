# Prueba Técnica – CloudOps AWS | Cristian Santiago Ordoñez

## Descripción General

Este proyecto implementa una arquitectura **Serverless y modular** en **AWS** usando **Terraform** como herramienta de Infraestructura como Código (IaC). La solución está diseñada para demostrar buenas prácticas en automatización, observabilidad, seguridad y escalabilidad bajo un modelo **pay-as-you-go**, cumpliendo todos los requisitos solicitados en la prueba técnica.

![Arquitectura AWS](assets/architecture.png)

---

## Cumplimiento de Requisitos Mínimos

### **1. Diseño de Arquitectura **

Se diseñó una infraestructura completamente basada en **servicios administrados de AWS**, optimizada para alta disponibilidad y bajo costo.
El flujo de tráfico sigue esta ruta:

* **Amazon CloudFront** distribuye contenido globalmente desde un **bucket S3** que almacena el frontend estático.
* **API Gateway (HTTP API v2)** recibe peticiones y las redirige a **AWS Lambda**, que contiene la lógica backend.
* **Amazon Aurora Serverless v2 (PostgreSQL)** almacena los datos de usuarios y productos de forma confiable y escalable.
* **AWS Secrets Manager** gestiona credenciales de forma segura.
* **AWS Certificate Manager (ACM)** provee certificados SSL/TLS para HTTPS.
* **Amazon Route 53** maneja la resolución DNS y validaciones de dominio.
* **Amazon VPC** con subredes públicas y privadas garantiza aislamiento y seguridad.

El resultado es una arquitectura **sin servidores**, altamente disponible, y fácilmente escalable.

---

### **2. Infraestructura como Código (IaC)**

Toda la infraestructura fue implementada con **Terraform**, organizada en módulos reutilizables:

* `network`: VPC, subredes, endpoints y seguridad.
* `lambda_api`: Función Lambda, API Gateway, roles e integraciones.
* `rds_aurora`: Base de datos Aurora Serverless con secretos administrados.
* `s3_cloudfront`: Distribución CDN y bucket S3 para frontend.
* `route53`: Hosted Zone y registros DNS.
* `acm`: Certificados SSL/TLS con validación automática.
* `observability`: Alarmas y monitoreo CloudWatch.

El archivo principal `main.tf` orquesta todos los módulos, mientras que `terraform.tfvars` centraliza las variables del entorno (como región, dominio, runtime, y correo de alertas).
Esto permite **replicar la misma arquitectura** en entornos `dev`, `staging` o `prod` simplemente cambiando las variables.

---

### **3. Estimación de Costos**

Se realizó una estimación usando la **Calculadora de Precios de AWS**:
[Ver estimación en AWS Pricing Calculator](https://calculator.aws/#/estimate?id=example)

Los principales costos provienen de:

* CloudFront (por solicitudes y transferencia de datos)
* Lambda (por invocación y tiempo de ejecución)
* Aurora Serverless (por capacidad utilizada)
* API Gateway (por llamadas HTTP)
* CloudWatch y Secrets Manager (mínimos)

Se paga **solo por uso real**. No hay instancias fijas ni costos por inactividad.

---

### **4. Disponibilidad y Rendimiento**

* **Escalabilidad automática** de Lambda y Aurora Serverless.
* **Distribución multi-AZ** en VPC para alta disponibilidad.
* **CloudFront CDN** para cacheo y baja latencia global.
* **Aurora** maneja conexiones concurrentes sin gestión manual.
* **Endpoints VPC** reducen dependencia de NAT Gateway y mejoran seguridad.

El diseño soporta **picos de tráfico altos** sin intervención operativa, asegurando continuidad de servicio y bajo tiempo de respuesta.

---

### **5. Observabilidad**

Se implementó un sistema de observabilidad integral con **Amazon CloudWatch**:

* **Alarmas Lambda** → Detectan errores y tiempos de ejecución anormales.
* **Alarmas API Gateway** → Notifican sobre respuestas 4xx y 5xx.
* **SNS** → Envío de alertas por correo al `alarm_email` configurado.
* **Logs centralizados** → Lambda, API Gateway y Aurora publican en CloudWatch Logs.
* **Métricas nativas** → Disponibles para dashboards de rendimiento y análisis histórico.

Esto permite **detectar fallos en tiempo real** y tomar decisiones basadas en métricas.

---

### **6. Gestión y Operación**

* Toda la infraestructura es **automatizada** con Terraform (`plan`, `apply`, `destroy`).
* No se requiere gestión manual de instancias o servidores.
* Cada módulo puede desplegarse y escalarse de forma independiente.
* La solución es **idempotente** y reproducible.

Esto garantiza operaciones simplificadas, despliegues consistentes y mínima intervención manual.

---

### **7. Seguridad**

* **Certificados TLS/SSL (ACM)** para todo el tráfico.
* **Roles IAM** específicos para cada servicio (principio de menor privilegio).
* **VPC privada** para Lambda y Aurora (sin exposición pública directa).
* **Secrets Manager** gestiona credenciales de base de datos sin almacenarlas en código.
* **Security Groups** controlan el tráfico interno.
* **Terraform remoto** asegura control de estado y versionamiento.

(Opcional) Se puede integrar con **GitHub Actions o Jenkins** para CI/CD automático de infraestructura y código.

---

## ⚙️ Estructura del Proyecto

```
.
├── main.tf                # Orquestador de módulos principales
├── terraform.tfvars        # Variables del entorno (dominio, región, etc.)
├── variables.tf            # Declaración global de variables
├── modules/
│   ├── network/
│   ├── lambda_api/
│   ├── rds_aurora/
│   ├── s3_cloudfront/
│   ├── route53/
│   ├── acm/
│   └── observability/
└── assets/
    └── architecture.png    # Diagrama de arquitectura
```

---

## Despliegue de la Solución

### **Inicializar Terraform**

```bash
terraform init
```

### **Validar la configuración**

```bash
terraform validate
```

### **Previsualizar cambios (plan)**

```bash
terraform plan -var-file=terraform.tfvars
```

### **Aplicar la infraestructura**

```bash
terraform apply -var-file=terraform.tfvars
```

### **Destruir los recursos (limpieza)**

```bash
terraform destroy -var-file=terraform.tfvars
```

---

**Autor:** 
Cristian Santiago Ordoñez
DevOps / CloudOps Engineer
