# Proyecto ELT con SQL Server – Marketing Digital

Este proyecto demuestra un proceso completo de **ELT (Extract, Load, Transform)** utilizando **SQL Server** para tratar datos de campañas de marketing digital.

## 🧩 Estructura del proyecto

- **Base de datos:** `BD_Marketing`
- **Esquemas:** 
  - `raw`: contiene los datos en bruto cargados desde un archivo CSV
  - `clean`: contiene los datos limpios y estructurados listos para análisis

## 📌 Pasos realizados

1. **Creación de la base de datos** y los esquemas `raw` y `clean`
2. **Carga del archivo CSV** con `BULK INSERT` en el esquema `raw`
3. **Exploración y análisis inicial** para definir los tipos y longitudes de datos
4. **Transformación**:
   - Conversión de tipos de datos (`TRY_CAST`)
   - Establecimiento de valores por defecto (`ISNULL`)
   - Eliminación de duplicados (`SELECT DISTINCT`)
5. **Carga en la tabla final limpia** dentro del esquema `clean`

---

### 🧾 Vista final de la tabla limpia

Esta imagen muestra la estructura y contenido final de la tabla `clean.Marketing`, con los tipos de datos bien definidos:

![Vista de la tabla limpia](estructura_clean.png)

## 📂 Archivos

- `marketing_elt.sql`: Script completo que ejecuta el proceso ELT paso a paso.

## 🧠 ¿Qué herramientas se usaron?

- SQL Server Management Studio
- `BULK INSERT` para la carga masiva
- Funciones de conversión y control de calidad de datos

## 🙋‍♂️ Autor

Waldir Ramos – Data Analyst & Student of Economics  
🔗 [Mi perfil de LinkedIn](https://www.linkedin.com/in/waldirframossoto/) 