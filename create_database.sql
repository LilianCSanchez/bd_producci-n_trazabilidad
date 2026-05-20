 IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = 'bd_produccion_trazabilidad')
  BEGIN
      CREATE DATABASE bd_produccion_trazabilidad;
  END
  GO

  USE bd_produccion_trazabilidad;
  GO

  -- Limpiar tablas existentes (orden inverso de dependencias)
  DROP TABLE IF EXISTS dbo.despachos;
  DROP TABLE IF EXISTS dbo.control_calidad;
  DROP TABLE IF EXISTS dbo.ordenes_produccion;
  DROP TABLE IF EXISTS dbo.lotes_producto_final;
  DROP TABLE IF EXISTS dbo.productos_finales;
  DROP TABLE IF EXISTS dbo.materias_primas;
  DROP TABLE IF EXISTS dbo.clientes;
  DROP TABLE IF EXISTS dbo.proveedores;
  GO

  -- ===== TABLA 1: PROVEEDORES =====
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

  -- ===== TABLA 2: MATERIAS_PRIMAS =====
  CREATE TABLE dbo.materias_primas (
      id                  INT IDENTITY(1,1) NOT NULL,
      id_materia          INT             NOT NULL,
      nombre              VARCHAR(120)    NOT NULL,
      id_proveedor        INT             NOT NULL,
      fecha_cosecha       DATETIME        NULL,
      modulo              VARCHAR(60)     NULL,
      turno               VARCHAR(30)     NULL,
      cantidad_ingresada  DECIMAL(12,4)   NOT NULL DEFAULT 0,
      aplicacion          VARCHAR(100)    NULL,
      unidad_medida       VARCHAR(30)     NOT NULL,
      CONSTRAINT pk_materias_primas PRIMARY KEY (id),
      CONSTRAINT fk_mp_proveedor    FOREIGN KEY (id_proveedor)
          REFERENCES dbo.proveedores (id)
          ON UPDATE NO ACTION
          ON DELETE NO ACTION
  );

  CREATE INDEX idx_mp_id_proveedor ON dbo.materias_primas (id_proveedor);
  CREATE INDEX idx_mp_id_materia   ON dbo.materias_primas (id_materia);
  CREATE INDEX idx_mp_nombre       ON dbo.materias_primas (nombre);
  GO

  -- ===== TABLA 3: PRODUCTOS_FINALES =====
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

  -- ===== TABLA 4: LOTES_PRODUCTO_FINAL =====
  CREATE TABLE dbo.lotes_producto_final (
      id                  INT IDENTITY(1,1) NOT NULL,
      id_producto_final   INT             NOT NULL,
      numero_lote         VARCHAR(60)     NOT NULL UNIQUE,
      fecha_produccion    DATETIME        NOT NULL,
      cantidad            DECIMAL(12,4)   NOT NULL DEFAULT 0,
      unidad_medida       VARCHAR(30)     NOT NULL,
      estado              TINYINT         NOT NULL DEFAULT 1,
      observaciones       VARCHAR(MAX)    NULL,
      aplicacion          VARCHAR(100)    NULL,
      CONSTRAINT pk_lotes_producto_final PRIMARY KEY (id),
      CONSTRAINT fk_lpf_producto_final   FOREIGN KEY (id_producto_final)
          REFERENCES dbo.productos_finales (id)
          ON UPDATE NO ACTION
          ON DELETE NO ACTION
  );

  CREATE INDEX idx_lpf_id_producto_final ON dbo.lotes_producto_final (id_producto_final);
  CREATE INDEX idx_lpf_numero_lote       ON dbo.lotes_producto_final (numero_lote);
  CREATE INDEX idx_lpf_fecha_produccion  ON dbo.lotes_producto_final (fecha_produccion);
  CREATE INDEX idx_lpf_estado            ON dbo.lotes_producto_final (estado);
  GO

  -- ===== TABLA 5: ORDENES_PRODUCCION =====
  CREATE TABLE dbo.ordenes_produccion (
      id                      INT IDENTITY(1,1) NOT NULL,
      id_materia              INT             NOT NULL,
      fecha_inicio            DATETIME        NOT NULL,
      fecha_fin               DATETIME        NULL,
      estado                  VARCHAR(30)     NOT NULL DEFAULT 'Pendiente',
      cantidad_producida      DECIMAL(12,4)   NULL DEFAULT 0,
      unidad_medida           VARCHAR(30)     NOT NULL,
      id_producto_final       INT             NOT NULL,
      observaciones           VARCHAR(MAX)    NULL,
      id_lote_producto_final  INT             NULL,
      username                VARCHAR(80)     NOT NULL,
      CONSTRAINT pk_ordenes_produccion     PRIMARY KEY (id),
      CONSTRAINT fk_op_materia             FOREIGN KEY (id_materia)
          REFERENCES dbo.materias_primas (id)
          ON UPDATE NO ACTION
          ON DELETE NO ACTION,
      CONSTRAINT fk_op_producto_final      FOREIGN KEY (id_producto_final)
          REFERENCES dbo.productos_finales (id)
          ON UPDATE NO ACTION
          ON DELETE NO ACTION,
      CONSTRAINT fk_op_lote_producto_final FOREIGN KEY (id_lote_producto_final)
          REFERENCES dbo.lotes_producto_final (id)
          ON UPDATE NO ACTION
          ON DELETE NO ACTION,
      CONSTRAINT chk_op_fechas CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio)
  );

  CREATE INDEX idx_op_id_materia             ON dbo.ordenes_produccion (id_materia);
  CREATE INDEX idx_op_id_producto_final      ON dbo.ordenes_produccion (id_producto_final);
  CREATE INDEX idx_op_id_lote_producto_final ON dbo.ordenes_produccion (id_lote_producto_final);
  CREATE INDEX idx_op_estado                 ON dbo.ordenes_produccion (estado);
  CREATE INDEX idx_op_fecha_inicio           ON dbo.ordenes_produccion (fecha_inicio);
  GO

  -- ===== TABLA 6: CONTROL_CALIDAD =====
  CREATE TABLE dbo.control_calidad (
      id                      INT IDENTITY(1,1) NOT NULL,
      id_orden_produccion     INT             NOT NULL,
      id_lote_producto_final  INT             NULL,
      fecha_inspeccion        DATETIME        NOT NULL DEFAULT GETDATE(),
      resultado               VARCHAR(30)     NOT NULL,
      observaciones           VARCHAR(MAX)    NULL,
      inspector               VARCHAR(100)    NOT NULL,
      CONSTRAINT pk_control_calidad        PRIMARY KEY (id),
      CONSTRAINT fk_cc_orden_produccion    FOREIGN KEY (id_orden_produccion)
          REFERENCES dbo.ordenes_produccion (id)
          ON UPDATE NO ACTION
          ON DELETE NO ACTION,
      CONSTRAINT fk_cc_lote_producto_final FOREIGN KEY (id_lote_producto_final)
          REFERENCES dbo.lotes_producto_final (id)
          ON UPDATE NO ACTION
          ON DELETE NO ACTION
  );

  CREATE INDEX idx_cc_id_orden_produccion    ON dbo.control_calidad (id_orden_produccion);
  CREATE INDEX idx_cc_id_lote_producto_final ON dbo.control_calidad (id_lote_producto_final);
  CREATE INDEX idx_cc_resultado              ON dbo.control_calidad (resultado);
  CREATE INDEX idx_cc_fecha_inspeccion       ON dbo.control_calidad (fecha_inspeccion);
  GO

  -- ===== TABLA 7: CLIENTES =====
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

  -- ===== TABLA 8: DESPACHOS =====
  CREATE TABLE dbo.despachos (
      id                      INT IDENTITY(1,1) NOT NULL,
      id_cliente              INT             NOT NULL,
      id_lote_producto_final  INT             NOT NULL,
      numero_despacho         VARCHAR(60)     NOT NULL UNIQUE,
      fecha_despacho          DATETIME        NOT NULL DEFAULT GETDATE(),
      cantidad                DECIMAL(12,4)   NOT NULL,
      unidad_medida           VARCHAR(30)     NOT NULL,
      direccion_entrega       VARCHAR(200)    NULL,
      estado                  VARCHAR(30)     NOT NULL DEFAULT 'Pendiente',
      tipo_envio              VARCHAR(60)     NULL,
      pais                    VARCHAR(60)     NOT NULL DEFAULT N'Perú',
      observaciones           VARCHAR(MAX)    NULL,
      CONSTRAINT pk_despachos             PRIMARY KEY (id),
      CONSTRAINT fk_d_cliente             FOREIGN KEY (id_cliente)
          REFERENCES dbo.clientes (id)
          ON UPDATE NO ACTION
          ON DELETE NO ACTION,
      CONSTRAINT fk_d_lote_producto_final FOREIGN KEY (id_lote_producto_final)
          REFERENCES dbo.lotes_producto_final (id)
          ON UPDATE NO ACTION
          ON DELETE NO ACTION,
      CONSTRAINT chk_d_cantidad CHECK (cantidad > 0)
  );

  CREATE INDEX idx_d_id_cliente             ON dbo.despachos (id_cliente);
  CREATE INDEX idx_d_id_lote_producto_final ON dbo.despachos (id_lote_producto_final);
  CREATE INDEX idx_d_numero_despacho        ON dbo.despachos (numero_despacho);
  CREATE INDEX idx_d_fecha_despacho         ON dbo.despachos (fecha_despacho);
  CREATE INDEX idx_d_estado                 ON dbo.despachos (estado);
  GO
