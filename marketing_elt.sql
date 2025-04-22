-- ==========================================
-- CREACIÓN DE BASE DE DATOS Y ESQUEMAS. Proyecto ELT
-- ==========================================
CREATE DATABASE BD_Marketing;
GO

-- Uso la base de datos recién creada
USE [BD_Marketing]

-- Creación de esquemas para organización del flujo ELT
CREATE SCHEMA raw;
GO
CREATE SCHEMA clean;
GO

-- ==========================================
-- CREACIÓN DE TABLA EN ESQUEMA RAW
-- ==========================================
CREATE TABLE [raw].[Marketing](
	[Campaña] [nvarchar](MAX) NULL,
	[Canal] [nvarchar](MAX) NULL,
	[Fecha_inicio] [nvarchar](MAX) NULL,
	[Fecha_fin] [nvarchar](MAX) NULL,
	[Presupuesto(USD)] [nvarchar](MAX) NULL,
	[IMPRESIONES] [nvarchar](MAX) NULL,
	[clicks] [nvarchar](MAX) NULL,
	[Ventas] [nvarchar](MAX) NULL,
	[Ingreso total] [nvarchar](MAX) NULL,
	[zona] [nvarchar](MAX) NULL,
	[tipo producto] [nvarchar](MAX) NULL
);

-- ==========================================
-- CARGA DE DATOS CON BULK INSERT (EXTRACT + LOAD)
-- ==========================================
BULK INSERT [raw].[Marketing]
FROM 'D:\Users\WALDIRRAMOS\Proyectos\marketing_digital_raw.csv'
WITH (
    FIRSTROW = 2,               -- Omitir la primera fila (encabezado)
    FIELDTERMINATOR = ',',      -- Separador de columnas
    ROWTERMINATOR = '0x0a',       -- Fin de cada fila
    FIELDQUOTE = '"',           -- Maneja comillas dobles en textos
    TABLOCK,                    -- Mejora el rendimiento en archivos grandes          
    MAXERRORS = 1000            -- Permite hasta 1000 errores antes de detener la carga
);

--Comprobamos carga de datos
SELECT *
FROM [raw].[Marketing]

-- ===========================
-- TRANSFORMACIÓN Y LIMPIEZA
-- (EDA BÁSICO)
-- ===========================

-- Analizamos las columnas
-- Objetivo: determinar tipo de dato y longitud óptima para la capa clean

-- Revisión rápida de tipos de datos y muestra de registros
SELECT TOP 15 *
FROM [raw].[Marketing]
-- ===========================
-- Anotamos los posibles tipos de datos, luego debemos validar:
-- ===========================
-- [Campaña] -> NVARCHAR
-- [Canal] -> NVARCHAR
-- [Fecha_inicio] -> DATE
-- [Fecha_fin] -> DATE
-- [Presupuesto(USD)] -> DECIMAL(10,2)
-- [IMPRESIONES] -> DECIMAL(10,2)
-- [clicks] -> INT
-- [Ventas] -> INT
-- [Ingreso total] -> DECIMAL(12,2)
-- [zona] -> NVARCHAR
-- [tipo producto] -> NVARCHAR

-- Verificamos que en columnas donde la muestra son INT no hayan decimales

-- En [clicks]
SELECT [clicks]
FROM [raw].[Marketing]
WHERE [clicks] LIKE '%.%';

-- En [Ventas]
SELECT [Ventas]
FROM [raw].[Marketing]
WHERE [Ventas] LIKE '%.%';

-- Ambos devuelven 0 filas son INT

-- ===========================
-- Ahora veremos la longitud máxima de nuestros valores por columna
-- Para implementar en la capa clean 
-- Obviamos Tipo fecha y numérico
-- ===========================

SELECT 
  MAX(LEN([Campaña])) AS len_Campaña,
  MAX(LEN([Canal])) AS len_Canal,
  MAX(LEN([zona])) AS len_Zona,
  MAX(LEN([tipo producto])) AS len_TipoProducto
FROM [raw].[Marketing];

-- Resultado:
-- [Campaña]        → NVARCHAR(8)
-- [Canal]          → NVARCHAR(9)
-- [zona]           → NVARCHAR(8)
-- [tipo producto]  → NVARCHAR(12)

-- ===========================
-- Creación de la tabla limpia en la capa clean con los datos recolectados
-- ===========================

CREATE TABLE [clean].Marketing (
  campania NVARCHAR(8) NULL,
  canal NVARCHAR(9) NULL,
  fecha_inicio DATE NULL,
  fecha_fin DATE NULL,
  presupuesto_usd DECIMAL(10,2) NULL,
  impresiones INT NULL,
  clicks INT NULL,
  ventas INT NULL,
  ingreso_total DECIMAL(12,2) NULL,
  zona NVARCHAR(8) NULL,
  tipo_producto NVARCHAR(12) NULL
);

-- ===========================
-- Inserto los datos de la capa raw a la capa clean
-- Cambio de nombre a las columnas para evitar errores
-- ===========================

INSERT INTO clean.Marketing (
  campania,
  canal,
  fecha_inicio,
  fecha_fin,
  presupuesto_usd,
  impresiones,
  clicks,
  ventas,
  ingreso_total,
  zona,
  tipo_producto
)
SELECT DISTINCT
  ISNULL([Campaña], 'SIN_CODIGO') AS campania,
  ISNULL([Canal], 'Desconocido') AS canal,
  TRY_CAST([Fecha_inicio] AS DATE) AS fecha_inicio,
  TRY_CAST([Fecha_fin] AS DATE) AS fecha_fin,
  TRY_CAST([Presupuesto(USD)] AS DECIMAL(10,2)) AS presupuesto_usd,
  ISNULL(TRY_CAST([IMPRESIONES] AS INT), 0) AS impresiones,
  ISNULL(TRY_CAST([clicks] AS INT), 0) AS clicks,
  ISNULL(TRY_CAST([Ventas] AS INT), 0) AS ventas,
  TRY_CAST([Ingreso total] AS DECIMAL(12,2)) AS ingreso_total,
  ISNULL([zona], 'Desconocido') AS zona,
  ISNULL([tipo producto], 'Desconocido') AS tipo_producto
FROM [raw].[Marketing];


-- Verificamos carga final
SELECT *
FROM [clean].[Marketing]