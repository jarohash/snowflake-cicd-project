# Tutorial para trabajar en equipo con Snowflake + GitHub

## Objetivo

Vamos a trabajar con un flujo colaborativo donde **GitHub será la fuente oficial del código SQL** y **Snowflake recibirá automáticamente los cambios** cuando estos sean aprobados.

El flujo general es:

```text
Cada integrante trabaja en su rama
        ↓
Sube cambios a GitHub
        ↓
Crea Pull Request
        ↓
El equipo revisa
        ↓
Se hace merge a main
        ↓
GitHub Actions despliega automáticamente a Snowflake
```

Repositorio del proyecto:

```text
https://github.com/jarohash/snowflake-cicd-project
```

---

# 1. Instalar herramientas necesarias

Cada integrante debe tener instalado:

```text
1. Git
2. Visual Studio Code
3. GitHub Desktop, opcional pero recomendado
```

También deben tener acceso al repositorio en GitHub.

---

# 2. Clonar el repositorio

Abrir terminal o Git Bash y ejecutar:

```bash
git clone https://github.com/jarohash/snowflake-cicd-project.git
cd snowflake-cicd-project
```

Abrir la carpeta en Visual Studio Code:

```bash
code .
```

---

# 3. Estructura del proyecto

El proyecto tiene esta estructura:

```text
snowflake-cicd-project/
│
├── .github/
│   └── workflows/
│       └── deploy-snowflake.yml
│
├── admin/
│   └── 00_bootstrap_snowflake_admin.sql
│
├── docs/
│   └── team-workflow.md
│
├── sql/
│   ├── 00_create_schemas.sql
│   ├── 01_create_tables_example.sql
│   ├── 02_create_views_example.sql
│   └── 99_smoke_test.sql
│
├── README.md
└── .gitignore
```

La carpeta más importante para nosotros es:

```text
sql/
```

Ahí van todos los scripts SQL del proyecto.

---

# 4. Regla principal del equipo

No debemos hacer cambios finales directamente en Snowflake.

La fuente oficial será GitHub.

Eso significa que si queremos crear o modificar:

```text
tablas
vistas
schemas
procedimientos
tasks
funciones
validaciones
```

debemos hacerlo mediante archivos `.sql` dentro del repositorio.

---

# 5. Flujo de trabajo diario

Antes de empezar cualquier cambio, actualizar la rama principal:

```bash
git checkout main
git pull origin main
```

Después crear una rama nueva para el cambio:

```bash
git checkout -b feature/nombre-del-cambio
```

Ejemplo:

```bash
git checkout -b feature/create-customers-table
```

---

# 6. Crear o modificar archivos SQL

Todos los cambios deben ir dentro de la carpeta:

```text
sql/
```

Ejemplo: si queremos crear una tabla de clientes, creamos un archivo nuevo:

```text
sql/10_create_raw_customers.sql
```

Contenido de ejemplo:

```sql
USE DATABASE DB_DEV;
USE SCHEMA RAW;

CREATE TABLE IF NOT EXISTS CUSTOMERS (
    CUSTOMER_ID STRING,
    CUSTOMER_NAME STRING,
    EMAIL STRING,
    CREATED_AT TIMESTAMP_NTZ
);
```

---

# 7. Convención de nombres

Para mantener orden, usamos números en los archivos:

```text
00-09 setup general
10-29 tablas RAW
30-49 tablas STAGING
50-79 vistas MART
90-99 pruebas
```

Ejemplo:

```text
sql/10_create_raw_customers.sql
sql/11_create_raw_orders.sql
sql/30_create_staging_orders_clean.sql
sql/50_create_mart_sales_summary.sql
sql/99_smoke_test.sql
```

---

# 8. Subir cambios a GitHub

Después de modificar o crear archivos:

```bash
git status
git add .
git commit -m "add customers table"
git push origin feature/create-customers-table
```

Cambiar el mensaje del commit según el cambio realizado.

Ejemplos de buenos mensajes:

```text
add raw customers table
create orders staging view
update sales mart view
add smoke test for orders
```

---

# 9. Crear Pull Request

Después de hacer push, entrar a GitHub:

```text
https://github.com/jarohash/snowflake-cicd-project
```

GitHub mostrará la opción para crear un Pull Request.

Crear el Pull Request desde la rama de trabajo hacia:

```text
main
```

Ejemplo:

```text
feature/create-customers-table → main
```

---

# 10. Revisión del Pull Request

Antes de aprobar un Pull Request, revisar:

```text
¿El SQL corre correctamente?
¿El archivo está en la carpeta sql/?
¿El nombre del archivo sigue el orden correcto?
¿El cambio usa el schema correcto?
¿No borra datos accidentalmente?
¿No contiene contraseñas, tokens o datos sensibles?
¿El código es entendible para el equipo?
```

---

# 11. Merge y despliegue automático

Cuando el Pull Request sea aprobado, se hace merge a:

```text
main
```

Automáticamente GitHub Actions ejecutará los scripts SQL y desplegará los cambios en Snowflake.

El flujo queda así:

```text
Merge a main
    ↓
GitHub Actions
    ↓
Snowflake
    ↓
DB_DEV
```

---

# 12. Verificar en Snowflake

Después del deploy, se puede revisar en Snowflake con:

```sql
USE DATABASE DB_DEV;

SHOW SCHEMAS;
SHOW TABLES IN SCHEMA RAW;
SHOW VIEWS IN SCHEMA MART;
```

También se puede consultar directamente el objeto creado.

Ejemplo:

```sql
SELECT *
FROM DB_DEV.RAW.CUSTOMERS;
```

---

# 13. Reglas importantes de SQL

Usar preferentemente:

```sql
CREATE TABLE IF NOT EXISTS ...
CREATE SCHEMA IF NOT EXISTS ...
CREATE OR REPLACE VIEW ...
```

Tener cuidado con:

```sql
DROP TABLE
DROP DATABASE
CREATE OR REPLACE TABLE
TRUNCATE TABLE
DELETE FROM ...
```

Estos comandos pueden borrar información o romper objetos usados por otros integrantes.

---

# 14. Qué no se debe subir al repositorio

Nunca subir:

```text
contraseñas
tokens
private keys
archivos .env
connections.toml
config.toml con credenciales
datos sensibles
exports privados
```

Sí se puede subir:

```text
scripts SQL
vistas
DDL de tablas
procedimientos
tasks
documentación
pruebas
README
```

---

# 15. Resumen rápido del flujo

Cada integrante debe seguir este ciclo:

```bash
git checkout main
git pull origin main
git checkout -b feature/nombre-del-cambio
```

Hacer cambios en `sql/`.

Luego:

```bash
git add .
git commit -m "descripción del cambio"
git push origin feature/nombre-del-cambio
```

Después:

```text
Crear Pull Request
Esperar revisión
Merge a main
Deploy automático a Snowflake
```

---

# 16. Ejemplo completo

Crear rama:

```bash
git checkout main
git pull origin main
git checkout -b feature/create-products-table
```

Crear archivo:

```text
sql/12_create_raw_products.sql
```

Agregar SQL:

```sql
USE DATABASE DB_DEV;
USE SCHEMA RAW;

CREATE TABLE IF NOT EXISTS PRODUCTS (
    PRODUCT_ID STRING,
    PRODUCT_NAME STRING,
    CATEGORY STRING,
    PRICE NUMBER(10,2),
    CREATED_AT TIMESTAMP_NTZ
);
```

Subir cambios:

```bash
git add .
git commit -m "add raw products table"
git push origin feature/create-products-table
```

Crear Pull Request en GitHub:

```text
feature/create-products-table → main
```

Cuando se aprueba y se hace merge, GitHub Actions despliega el cambio automáticamente a Snowflake.

---

# 17. Roles sugeridos dentro del equipo

Para organizarse mejor:

```text
Persona 1: tablas RAW
Persona 2: limpieza y STAGING
Persona 3: vistas MART / analytics
Persona 4: pruebas, documentación y revisión
```

RAW significa datos crudos.

STAGING significa datos limpios o transformados.

MART significa datos listos para análisis, dashboards o reportes.

---

# 18. Regla final

Todo cambio importante debe vivir en GitHub.

Snowflake es el lugar donde se ejecuta y se valida, pero GitHub es la fuente oficial del proyecto.
