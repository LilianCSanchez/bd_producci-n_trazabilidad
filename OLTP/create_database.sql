IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = 'bd_produccion_trazabilidad')
BEGIN
    CREATE DATABASE bd_produccion_trazabilidad;
END
GO

USE bd_produccion_trazabilidad;
GO

/* ===== Limpiar tablas existentes (orden inverso de dependencias) ===== */
DROP VIEW  IF EXISTS dbo.vw_trazabilidad_lote;
DROP VIEW  IF EXISTS dbo.vw_calidad_aprobacion;
DROP VIEW  IF EXISTS dbo.vw_merma_por_tipo;
DROP VIEW  IF EXISTS dbo.vw_rendimiento_orden;
GO
DROP TABLE IF EXISTS dbo.despachos;
DROP TABLE IF EXISTS dbo.control_calidad;
DROP TABLE IF EXISTS dbo.cadena_frio;
DROP TABLE IF EXISTS dbo.mermas;
DROP TABLE IF EXISTS dbo.orden_produccion_materia;
DROP TABLE IF EXISTS dbo.lotes_producto_final;
DROP TABLE IF EXISTS dbo.ordenes_produccion;
DROP TABLE IF EXISTS dbo.aplicaciones_agroquimicas;
DROP TABLE IF EXISTS dbo.materias_primas;
DROP TABLE IF EXISTS dbo.fundos;
DROP TABLE IF EXISTS dbo.tipos_merma;
DROP TABLE IF EXISTS dbo.usuarios;
DROP TABLE IF EXISTS dbo.productos_finales;
DROP TABLE IF EXISTS dbo.clientes;
DROP TABLE IF EXISTS dbo.proveedores;
GO

/* ===== TABLA 1: PROVEEDORES (es también el productor del fundo) ===== */
CREATE TABLE dbo.proveedores (
    id              INT IDENTITY(1,1) NOT NULL,
    tipo_proveedor  VARCHAR(50)     NOT NULL,
    RUC             VARCHAR(20)     NOT NULL UNIQUE,
    razon_social    VARCHAR(150)    NOT NULL,
    estado          TINYINT         NOT NULL DEFAULT 1,
    fecha_ingreso   DATETIME        NOT NULL DEFAULT GETDATE(),
    CONSTRAINT pk_proveedores PRIMARY KEY (id)
);
CREATE INDEX idx_proveedores_ruc          ON dbo.proveedores (RUC);
CREATE INDEX idx_proveedores_razon_social ON dbo.proveedores (razon_social);
CREATE INDEX idx_proveedores_estado       ON dbo.proveedores (estado);
GO

/* ===== TABLA 2: CLIENTES ===== */
CREATE TABLE dbo.clientes (
    id              INT IDENTITY(1,1) NOT NULL,
    tipo_documento  VARCHAR(20)     NOT NULL,
    documento       VARCHAR(20)     NOT NULL UNIQUE,
    razon_social    VARCHAR(150)    NOT NULL,
    direccion       VARCHAR(200)    NULL,
    telefono        VARCHAR(30)     NULL,
    email           VARCHAR(100)    NULL,
    estado          TINYINT         NOT NULL DEFAULT 1,
    fecha_creacion  DATETIME        NOT NULL DEFAULT GETDATE(),
    pais            VARCHAR(60)     NOT NULL DEFAULT N'Perú',
    CONSTRAINT pk_clientes PRIMARY KEY (id)
);
CREATE INDEX idx_clientes_documento    ON dbo.clientes (documento);
CREATE INDEX idx_clientes_razon_social ON dbo.clientes (razon_social);
CREATE INDEX idx_clientes_estado       ON dbo.clientes (estado);
CREATE INDEX idx_clientes_pais         ON dbo.clientes (pais);
GO

/* ===== TABLA 3: PRODUCTOS_FINALES ===== */
CREATE TABLE dbo.productos_finales (
    id              INT IDENTITY(1,1) NOT NULL,
    codigo          VARCHAR(50)     NOT NULL UNIQUE,
    nombre          VARCHAR(120)    NOT NULL,
    descripcion     VARCHAR(MAX)    NULL,
    unidad_medida   VARCHAR(30)     NOT NULL,
    estado          TINYINT         NOT NULL DEFAULT 1,
    fecha_creacion  DATETIME        NOT NULL DEFAULT GETDATE(),
    CONSTRAINT pk_productos_finales PRIMARY KEY (id)
);
CREATE INDEX idx_pf_codigo ON dbo.productos_finales (codigo);
CREATE INDEX idx_pf_nombre ON dbo.productos_finales (nombre);
CREATE INDEX idx_pf_estado ON dbo.productos_finales (estado);
GO

/* ===== TABLA 4: USUARIOS (operarios / inspectores / supervisores) ===== */
CREATE TABLE dbo.usuarios (
    id              INT IDENTITY(1,1) NOT NULL,
    username        VARCHAR(80)   NOT NULL UNIQUE,
    nombre_completo VARCHAR(150)  NOT NULL,
    rol             VARCHAR(50)   NOT NULL,   -- Operario, Inspector, Supervisor, Admin
    estado          TINYINT       NOT NULL DEFAULT 1,
    fecha_creacion  DATETIME      NOT NULL DEFAULT GETDATE(),
    CONSTRAINT pk_usuarios PRIMARY KEY (id)
);
CREATE INDEX idx_usuarios_username ON dbo.usuarios (username);
GO

/* ===== TABLA 5: TIPOS_MERMA (catálogo) ===== */
CREATE TABLE dbo.tipos_merma (
    id          INT IDENTITY(1,1) NOT NULL,
    nombre      VARCHAR(60)  NOT NULL UNIQUE,
    recuperable BIT          NOT NULL DEFAULT 0,
    CONSTRAINT pk_tipos_merma PRIMARY KEY (id)
);
INSERT INTO dbo.tipos_merma (nombre, recuperable) VALUES
    ('Recorte (cabeza/base)', 1),
    ('Descarte por calibre',  1),
    ('Descarte por calidad',  0),
    ('Deshidratación',        0),
    ('Daño mecánico',         0),
    ('Otros',                 0);
GO

/* ===== TABLA 6: FUNDOS / CAMPOS (origen agrícola) ===== */
CREATE TABLE dbo.fundos (
    id              INT IDENTITY(1,1) NOT NULL,
    codigo_campo    VARCHAR(50)   NOT NULL UNIQUE,
    nombre          VARCHAR(150)  NOT NULL,
    id_proveedor    INT           NOT NULL,        -- productor / agricultor
    codigo_globalgap VARCHAR(40)  NULL,            -- GGN
    variedad        VARCHAR(80)   NULL,            -- UC-157, Atlas, etc.
    area_hectareas  DECIMAL(10,2) NULL,
    ubicacion       VARCHAR(200)  NULL,
    latitud         DECIMAL(9,6)  NULL,
    longitud        DECIMAL(9,6)  NULL,
    estado          TINYINT       NOT NULL DEFAULT 1,
    CONSTRAINT pk_fundos PRIMARY KEY (id),
    CONSTRAINT fk_fundos_proveedor FOREIGN KEY (id_proveedor)
        REFERENCES dbo.proveedores (id)
        ON UPDATE NO ACTION ON DELETE NO ACTION
);
CREATE INDEX idx_fundos_codigo    ON dbo.fundos (codigo_campo);
CREATE INDEX idx_fundos_proveedor ON dbo.fundos (id_proveedor);
GO

/* ===== TABLA 7: MATERIAS_PRIMAS (recepción de cosecha) =====
   El proveedor se obtiene vía fundo; id_fundo es OBLIGATORIO. */
CREATE TABLE dbo.materias_primas (
    id                    INT IDENTITY(1,1) NOT NULL,
    id_materia            INT             NOT NULL,
    nombre                VARCHAR(120)    NOT NULL,
    id_fundo              INT             NOT NULL,
    fecha_cosecha         DATETIME        NULL,
    fecha_recepcion       DATETIME        NOT NULL DEFAULT GETDATE(),
    modulo                VARCHAR(60)     NULL,
    turno                 VARCHAR(30)     NULL,
    cantidad_ingresada    DECIMAL(12,4)   NOT NULL DEFAULT 0,
    cantidad_aprobada     DECIMAL(12,4)   NOT NULL DEFAULT 0,
    cantidad_rechazada    DECIMAL(12,4)   NOT NULL DEFAULT 0,
    temperatura_recepcion DECIMAL(5,2)    NULL,
    aplicacion            VARCHAR(100)    NULL,
    unidad_medida         VARCHAR(30)     NOT NULL,
    CONSTRAINT pk_materias_primas PRIMARY KEY (id),
    CONSTRAINT fk_mp_fundo FOREIGN KEY (id_fundo)
        REFERENCES dbo.fundos (id)
        ON UPDATE NO ACTION ON DELETE NO ACTION
);
CREATE INDEX idx_mp_id_fundo   ON dbo.materias_primas (id_fundo);
CREATE INDEX idx_mp_id_materia ON dbo.materias_primas (id_materia);
CREATE INDEX idx_mp_nombre     ON dbo.materias_primas (nombre);
GO

/* ===== TABLA 8: APLICACIONES_AGROQUÍMICAS por fundo (carencia / LMR) ===== */
CREATE TABLE dbo.aplicaciones_agroquimicas (
    id                  INT IDENTITY(1,1) NOT NULL,
    id_fundo            INT           NOT NULL,
    producto            VARCHAR(150)  NOT NULL,
    ingrediente_activo  VARCHAR(150)  NULL,
    dosis               VARCHAR(60)   NULL,
    fecha_aplicacion    DATETIME      NOT NULL,
    carencia_dias       INT           NULL,
    fecha_apta_cosecha  AS DATEADD(DAY, ISNULL(carencia_dias,0), fecha_aplicacion),
    id_usuario          INT           NULL,
    observaciones       VARCHAR(MAX)  NULL,
    CONSTRAINT pk_aplic_agro PRIMARY KEY (id),
    CONSTRAINT fk_aa_fundo   FOREIGN KEY (id_fundo)   REFERENCES dbo.fundos (id),
    CONSTRAINT fk_aa_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuarios (id)
);
CREATE INDEX idx_aa_id_fundo ON dbo.aplicaciones_agroquimicas (id_fundo);
GO

/* ===== TABLA 9: ORDENES_PRODUCCION (proceso) =====
   El consumo de materia prima va en la tabla puente (M:N).
   Los lotes producidos referencian la orden (1 orden -> N lotes). */
CREATE TABLE dbo.ordenes_produccion (
    id                 INT IDENTITY(1,1) NOT NULL,
    fecha_inicio       DATETIME        NOT NULL,
    fecha_fin          DATETIME        NULL,
    estado             VARCHAR(30)     NOT NULL DEFAULT 'Pendiente',
    cantidad_producida DECIMAL(12,4)   NULL DEFAULT 0,
    unidad_medida      VARCHAR(30)     NOT NULL,
    id_producto_final  INT             NOT NULL,
    observaciones      VARCHAR(MAX)    NULL,
    id_usuario         INT             NOT NULL,
    CONSTRAINT pk_ordenes_produccion PRIMARY KEY (id),
    CONSTRAINT fk_op_producto_final FOREIGN KEY (id_producto_final)
        REFERENCES dbo.productos_finales (id)
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT fk_op_usuario FOREIGN KEY (id_usuario)
        REFERENCES dbo.usuarios (id),
    CONSTRAINT chk_op_fechas CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio)
);
CREATE INDEX idx_op_id_producto_final ON dbo.ordenes_produccion (id_producto_final);
CREATE INDEX idx_op_estado            ON dbo.ordenes_produccion (estado);
CREATE INDEX idx_op_fecha_inicio      ON dbo.ordenes_produccion (fecha_inicio);
GO

/* ===== TABLA 10: LOTES_PRODUCTO_FINAL (producido por la orden) ===== */
CREATE TABLE dbo.lotes_producto_final (
    id                  INT IDENTITY(1,1) NOT NULL,
    id_producto_final   INT             NOT NULL,
    id_orden_produccion INT             NULL,
    numero_lote         VARCHAR(60)     NOT NULL UNIQUE,
    fecha_produccion    DATETIME        NOT NULL,
    cantidad            DECIMAL(12,4)   NOT NULL DEFAULT 0,
    unidad_medida       VARCHAR(30)     NOT NULL,
    calibre             VARCHAR(40)     NULL,        -- S, M, L, XL, Jumbo
    categoria           VARCHAR(40)     NULL,        -- Extra, Primera, Segunda
    presentacion        VARCHAR(60)     NULL,        -- Atado, Granel, Clamshell
    estado              TINYINT         NOT NULL DEFAULT 1,
    observaciones       VARCHAR(MAX)    NULL,
    aplicacion          VARCHAR(100)    NULL,
    CONSTRAINT pk_lotes_producto_final PRIMARY KEY (id),
    CONSTRAINT fk_lpf_producto_final FOREIGN KEY (id_producto_final)
        REFERENCES dbo.productos_finales (id)
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT fk_lpf_orden FOREIGN KEY (id_orden_produccion)
        REFERENCES dbo.ordenes_produccion (id)
        ON UPDATE NO ACTION ON DELETE NO ACTION
);
CREATE INDEX idx_lpf_id_producto_final ON dbo.lotes_producto_final (id_producto_final);
CREATE INDEX idx_lpf_id_orden          ON dbo.lotes_producto_final (id_orden_produccion);
CREATE INDEX idx_lpf_numero_lote       ON dbo.lotes_producto_final (numero_lote);
CREATE INDEX idx_lpf_fecha_produccion  ON dbo.lotes_producto_final (fecha_produccion);
CREATE INDEX idx_lpf_estado            ON dbo.lotes_producto_final (estado);
GO

/* ===== TABLA 11: ORDEN_PRODUCCION_MATERIA (puente M:N) ===== */
CREATE TABLE dbo.orden_produccion_materia (
    id                  INT IDENTITY(1,1) NOT NULL,
    id_orden_produccion INT           NOT NULL,
    id_materia          INT           NOT NULL,
    cantidad_consumida  DECIMAL(12,4) NOT NULL DEFAULT 0,
    unidad_medida       VARCHAR(30)   NOT NULL,
    CONSTRAINT pk_opm PRIMARY KEY (id),
    CONSTRAINT fk_opm_orden   FOREIGN KEY (id_orden_produccion)
        REFERENCES dbo.ordenes_produccion (id),
    CONSTRAINT fk_opm_materia FOREIGN KEY (id_materia)
        REFERENCES dbo.materias_primas (id),
    CONSTRAINT uq_opm UNIQUE (id_orden_produccion, id_materia)
);
CREATE INDEX idx_opm_orden   ON dbo.orden_produccion_materia (id_orden_produccion);
CREATE INDEX idx_opm_materia ON dbo.orden_produccion_materia (id_materia);
GO

/* ===== TABLA 12: MERMAS ===== */
CREATE TABLE dbo.mermas (
    id                  INT IDENTITY(1,1) NOT NULL,
    id_orden_produccion INT           NOT NULL,
    id_tipo_merma       INT           NOT NULL,
    etapa               VARCHAR(40)   NOT NULL,   -- Recepción, Calibrado, Selección, Empaque
    cantidad            DECIMAL(12,4) NOT NULL,
    unidad_medida       VARCHAR(30)   NOT NULL,
    destino             VARCHAR(60)   NULL,        -- Compost, Subproducto, Descarte
    fecha_registro      DATETIME      NOT NULL DEFAULT GETDATE(),
    id_usuario          INT           NULL,
    observaciones       VARCHAR(MAX)  NULL,
    CONSTRAINT pk_mermas PRIMARY KEY (id),
    CONSTRAINT fk_m_orden   FOREIGN KEY (id_orden_produccion) REFERENCES dbo.ordenes_produccion (id),
    CONSTRAINT fk_m_tipo    FOREIGN KEY (id_tipo_merma)       REFERENCES dbo.tipos_merma (id),
    CONSTRAINT fk_m_usuario FOREIGN KEY (id_usuario)          REFERENCES dbo.usuarios (id),
    CONSTRAINT chk_m_cantidad CHECK (cantidad >= 0)
);
CREATE INDEX idx_m_orden ON dbo.mermas (id_orden_produccion);
CREATE INDEX idx_m_tipo  ON dbo.mermas (id_tipo_merma);
GO

/* ===== TABLA 13: CADENA_FRIO ===== */
CREATE TABLE dbo.cadena_frio (
    id                      INT IDENTITY(1,1) NOT NULL,
    id_lote_producto_final  INT           NOT NULL,
    ubicacion               VARCHAR(80)   NOT NULL,   -- Cámara 1, Hidrocooler, etc.
    fecha_hora              DATETIME      NOT NULL DEFAULT GETDATE(),
    temperatura             DECIMAL(5,2)  NOT NULL,
    humedad_pct             DECIMAL(5,2)  NULL,
    id_usuario              INT           NULL,
    CONSTRAINT pk_cadena_frio PRIMARY KEY (id),
    CONSTRAINT fk_cf_lote    FOREIGN KEY (id_lote_producto_final) REFERENCES dbo.lotes_producto_final (id),
    CONSTRAINT fk_cf_usuario FOREIGN KEY (id_usuario)             REFERENCES dbo.usuarios (id)
);
CREATE INDEX idx_cf_lote  ON dbo.cadena_frio (id_lote_producto_final);
CREATE INDEX idx_cf_fecha ON dbo.cadena_frio (fecha_hora);
GO

/* ===== TABLA 14: CONTROL_CALIDAD (multi-etapa) =====
   Una sola tabla cubre los 3 puntos de control. El anclaje obligatorio
   depende de la etapa (validado por CHECK):
     - Recepción          -> id_materia (lote de cosecha recibido)
     - En proceso         -> id_orden_produccion
     - Producto terminado -> id_lote_producto_final (liberación / certificación) */
CREATE TABLE dbo.control_calidad (
    id                     INT IDENTITY(1,1) NOT NULL,
    etapa                  VARCHAR(30)   NOT NULL,   -- Recepción / En proceso / Producto terminado
    id_materia             INT           NULL,
    id_orden_produccion    INT           NULL,
    id_lote_producto_final INT           NULL,
    fecha_inspeccion       DATETIME      NOT NULL DEFAULT GETDATE(),
    resultado              VARCHAR(30)   NOT NULL,   -- Aprobado / Rechazado / Conforme / No conforme
    parametro              VARCHAR(80)   NULL,       -- Calibre, Defectos, Temperatura, Brix, etc.
    valor_medido           VARCHAR(60)   NULL,
    observaciones          VARCHAR(MAX)  NULL,
    id_usuario             INT           NOT NULL,   -- inspector
    CONSTRAINT pk_control_calidad PRIMARY KEY (id),
    CONSTRAINT fk_cc_materia FOREIGN KEY (id_materia)
        REFERENCES dbo.materias_primas (id),
    CONSTRAINT fk_cc_orden_produccion FOREIGN KEY (id_orden_produccion)
        REFERENCES dbo.ordenes_produccion (id),
    CONSTRAINT fk_cc_lote_producto_final FOREIGN KEY (id_lote_producto_final)
        REFERENCES dbo.lotes_producto_final (id),
    CONSTRAINT fk_cc_usuario FOREIGN KEY (id_usuario)
        REFERENCES dbo.usuarios (id),
    CONSTRAINT chk_cc_anclaje CHECK (
        (etapa = 'Recepción'          AND id_materia             IS NOT NULL) OR
        (etapa = 'En proceso'         AND id_orden_produccion    IS NOT NULL) OR
        (etapa = 'Producto terminado' AND id_lote_producto_final IS NOT NULL)
    )
);
CREATE INDEX idx_cc_etapa                  ON dbo.control_calidad (etapa);
CREATE INDEX idx_cc_id_materia             ON dbo.control_calidad (id_materia);
CREATE INDEX idx_cc_id_orden_produccion    ON dbo.control_calidad (id_orden_produccion);
CREATE INDEX idx_cc_id_lote_producto_final ON dbo.control_calidad (id_lote_producto_final);
CREATE INDEX idx_cc_resultado              ON dbo.control_calidad (resultado);
CREATE INDEX idx_cc_fecha_inspeccion       ON dbo.control_calidad (fecha_inspeccion);
GO

/* ===== TABLA 15: DESPACHOS ===== */
CREATE TABLE dbo.despachos (
    id                      INT IDENTITY(1,1) NOT NULL,
    id_cliente              INT           NOT NULL,
    id_lote_producto_final  INT           NOT NULL,
    numero_despacho         VARCHAR(60)   NOT NULL UNIQUE,
    fecha_despacho          DATETIME      NOT NULL DEFAULT GETDATE(),
    cantidad                DECIMAL(12,4) NOT NULL,
    unidad_medida           VARCHAR(30)   NOT NULL,
    direccion_entrega       VARCHAR(200)  NULL,
    estado                  VARCHAR(30)   NOT NULL DEFAULT 'Pendiente',
    tipo_envio              VARCHAR(60)   NULL,
    transportista           VARCHAR(150)  NULL,
    placa_vehiculo          VARCHAR(20)   NULL,
    precinto                VARCHAR(40)   NULL,
    guia_remision           VARCHAR(60)   NULL,
    awb_contenedor          VARCHAR(60)   NULL,      -- AWB aéreo / nro. contenedor
    temperatura_carga       DECIMAL(5,2)  NULL,
    pais                    VARCHAR(60)   NOT NULL DEFAULT N'Perú',
    observaciones           VARCHAR(MAX)  NULL,
    CONSTRAINT pk_despachos PRIMARY KEY (id),
    CONSTRAINT fk_d_cliente FOREIGN KEY (id_cliente)
        REFERENCES dbo.clientes (id)
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT fk_d_lote_producto_final FOREIGN KEY (id_lote_producto_final)
        REFERENCES dbo.lotes_producto_final (id)
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT chk_d_cantidad CHECK (cantidad > 0)
);
CREATE INDEX idx_d_id_cliente             ON dbo.despachos (id_cliente);
CREATE INDEX idx_d_id_lote_producto_final ON dbo.despachos (id_lote_producto_final);
CREATE INDEX idx_d_numero_despacho        ON dbo.despachos (numero_despacho);
CREATE INDEX idx_d_fecha_despacho         ON dbo.despachos (fecha_despacho);
CREATE INDEX idx_d_estado                 ON dbo.despachos (estado);
GO

/* ================================================================
   INDICADORES (VISTAS / KPIs)
   ================================================================ */

-- Rendimiento y merma por orden
CREATE VIEW dbo.vw_rendimiento_orden AS
SELECT
    op.id                           AS id_orden,
    op.fecha_inicio,
    op.estado,
    ISNULL(c.total_consumido,0)     AS mp_consumida,
    ISNULL(op.cantidad_producida,0) AS producto_final,
    ISNULL(m.total_merma,0)         AS merma_total,
    CASE WHEN ISNULL(c.total_consumido,0) > 0
         THEN CAST(ISNULL(op.cantidad_producida,0) * 100.0 / c.total_consumido AS DECIMAL(6,2))
         ELSE 0 END                 AS rendimiento_pct,
    CASE WHEN ISNULL(c.total_consumido,0) > 0
         THEN CAST(ISNULL(m.total_merma,0) * 100.0 / c.total_consumido AS DECIMAL(6,2))
         ELSE 0 END                 AS merma_pct
FROM dbo.ordenes_produccion op
LEFT JOIN (SELECT id_orden_produccion, SUM(cantidad_consumida) AS total_consumido
           FROM dbo.orden_produccion_materia GROUP BY id_orden_produccion) c
       ON c.id_orden_produccion = op.id
LEFT JOIN (SELECT id_orden_produccion, SUM(cantidad) AS total_merma
           FROM dbo.mermas GROUP BY id_orden_produccion) m
       ON m.id_orden_produccion = op.id;
GO

-- Merma por tipo (Pareto)
CREATE VIEW dbo.vw_merma_por_tipo AS
SELECT t.nombre AS tipo_merma, t.recuperable,
       SUM(m.cantidad) AS cantidad_total,
       COUNT(*)        AS registros
FROM dbo.mermas m
JOIN dbo.tipos_merma t ON t.id = m.id_tipo_merma
GROUP BY t.nombre, t.recuperable;
GO

-- % de aprobación de control de calidad (por etapa)
CREATE VIEW dbo.vw_calidad_aprobacion AS
SELECT
    etapa,
    COUNT(*) AS inspecciones,
    SUM(CASE WHEN resultado IN ('Aprobado','Conforme') THEN 1 ELSE 0 END) AS aprobadas,
    CAST(SUM(CASE WHEN resultado IN ('Aprobado','Conforme') THEN 1 ELSE 0 END) * 100.0
         / NULLIF(COUNT(*),0) AS DECIMAL(6,2)) AS pct_aprobacion
FROM dbo.control_calidad
GROUP BY etapa;
GO

-- Trazabilidad consolidada por lote (atrás: fundo/proveedor; adelante: cliente)
CREATE VIEW dbo.vw_trazabilidad_lote AS
SELECT DISTINCT
    l.numero_lote,
    l.calibre, l.categoria, l.presentacion,
    pf.nombre        AS producto,
    op.id            AS id_orden,
    mp.nombre        AS materia_prima,
    f.codigo_campo,
    f.variedad,
    pr.razon_social  AS proveedor,
    cl.razon_social  AS cliente,
    d.numero_despacho
FROM dbo.lotes_producto_final l
JOIN  dbo.productos_finales        pf ON pf.id = l.id_producto_final
LEFT JOIN dbo.ordenes_produccion   op ON op.id = l.id_orden_produccion
LEFT JOIN dbo.orden_produccion_materia opm ON opm.id_orden_produccion = op.id
LEFT JOIN dbo.materias_primas      mp ON mp.id = opm.id_materia
LEFT JOIN dbo.fundos               f  ON f.id  = mp.id_fundo
LEFT JOIN dbo.proveedores          pr ON pr.id = f.id_proveedor
LEFT JOIN dbo.despachos            d  ON d.id_lote_producto_final = l.id
LEFT JOIN dbo.clientes             cl ON cl.id = d.id_cliente;

GO
