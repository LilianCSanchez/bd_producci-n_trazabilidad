USE bd_produccion_trazabilidad;
GO
SET NOCOUNT ON;
GO

/* ------------------------------------------------------------------
   LIMPIEZA (orden inverso de dependencias). Re-ejecutable.
   tipos_merma NO se limpia (catalogo cargado por el DDL).
   No se usa DBCC RESEED: los IDs se fijan con IDENTITY_INSERT.
   ------------------------------------------------------------------ */
DELETE FROM dbo.despachos;
DELETE FROM dbo.control_calidad;
DELETE FROM dbo.cadena_frio;
DELETE FROM dbo.mermas;
DELETE FROM dbo.orden_produccion_materia;
DELETE FROM dbo.lotes_producto_final;
DELETE FROM dbo.ordenes_produccion;
DELETE FROM dbo.aplicaciones_agroquimicas;
DELETE FROM dbo.materias_primas;
DELETE FROM dbo.fundos;
DELETE FROM dbo.usuarios;
DELETE FROM dbo.productos_finales;
DELETE FROM dbo.clientes;
DELETE FROM dbo.proveedores;
GO

/* ===== INDEPENDIENTE 1: PROVEEDORES (6) ===== */
SET IDENTITY_INSERT dbo.proveedores ON;
INSERT INTO dbo.proveedores (id, tipo_proveedor, RUC, razon_social, estado, fecha_ingreso) VALUES
  (1, N'Productor', N'20481234561', N'Agricola Santa Elena S.A.C.', 1, '2024-01-10 08:00:00'),
  (2, N'Productor', N'20489876542', N'Fundo Los Olivos E.I.R.L.', 1, '2024-01-22 08:00:00'),
  (3, N'Productor', N'20512345673', N'Agroexportadora del Norte S.A.C.', 1, '2024-02-03 08:00:00'),
  (4, N'Productor', N'20556789014', N'Inversiones Agricolas Chao S.A.', 1, '2024-02-15 08:00:00'),
  (5, N'Insumos', N'20603344551', N'Quimica Agro Peru S.A.C.', 1, '2024-02-27 08:00:00'),
  (6, N'Servicios', N'20611223346', N'Frio y Logistica del Pacifico S.A.C.', 1, '2024-03-10 08:00:00');
SET IDENTITY_INSERT dbo.proveedores OFF;
GO

/* ===== INDEPENDIENTE 2: CLIENTES (8) ===== */
SET IDENTITY_INSERT dbo.clientes ON;
INSERT INTO dbo.clientes (id, tipo_documento, documento, razon_social, direccion, telefono, email, estado, fecha_creacion, pais) VALUES
  (1, N'RUC', N'20100200301', N'Fresh Market USA Inc.', N'1200 Harbor Blvd, Los Angeles', N'+1 310 555 0101', N'compras@freshmarketusa.com', 1, '2024-02-01 09:30:00', N'Estados Unidos'),
  (2, N'RUC', N'20100200302', N'Euro Green Imports B.V.', N'Westland 45, Rotterdam', N'+31 10 555 2020', N'orders@eurogreen.nl', 1, '2024-02-10 09:30:00', N'Paises Bajos'),
  (3, N'RUC', N'20100200303', N'Asia Fresh Trading Co.', N'8 Marina Way, Singapore', N'+65 6555 3030', N'sales@asiafresh.sg', 1, '2024-02-19 09:30:00', N'Singapur'),
  (4, N'RUC', N'20100200304', N'Mercado Mayorista Lima S.A.C.', N'Av. La Cultura 1500, Santa Anita, Lima', N'+51 1 555 4040', N'ventas@mmlima.pe', 1, '2024-02-28 09:30:00', N'Peru'),
  (5, N'RUC', N'20100200305', N'UK Produce Distributors Ltd.', N'21 Covent Garden, London', N'+44 20 5555 5050', N'buy@ukproduce.co.uk', 1, '2024-03-08 09:30:00', N'Reino Unido'),
  (6, N'RUC', N'20100200306', N'Iberia Frutas y Hortalizas S.L.', N'Mercabarna Nave 7, Barcelona', N'+34 93 555 6060', N'compras@iberiafrutas.es', 1, '2024-03-17 09:30:00', N'Espana'),
  (7, N'RUC', N'20100200307', N'Canada Fine Foods Corp.', N'450 Front St W, Toronto', N'+1 416 555 7070', N'procurement@canadafine.ca', 1, '2024-03-26 09:30:00', N'Canada'),
  (8, N'RUC', N'20100200308', N'Supermercados del Sur S.A.', N'Av. Ejercito 800, Arequipa', N'+51 54 555 8080', N'logistica@superdelsur.pe', 1, '2024-04-04 09:30:00', N'Peru');
SET IDENTITY_INSERT dbo.clientes OFF;
GO

/* ===== INDEPENDIENTE 3: PRODUCTOS_FINALES (6) ===== */
SET IDENTITY_INSERT dbo.productos_finales ON;
INSERT INTO dbo.productos_finales (id, codigo, nombre, descripcion, unidad_medida, estado, fecha_creacion) VALUES
  (1, N'ESP-VERDE-FR', N'Esparrago verde fresco', N'Esparrago verde categoria Extra, atado de 250 g', N'kg', 1, '2024-01-15 10:00:00'),
  (2, N'ESP-BLANCO-FR', N'Esparrago blanco fresco', N'Esparrago blanco fresco para exportacion', N'kg', 1, '2024-01-20 10:00:00'),
  (3, N'ARAND-FR', N'Arandano fresco', N'Arandano fresco en clamshell de 125 g', N'kg', 1, '2024-01-25 10:00:00'),
  (4, N'PALTA-HASS', N'Palta Hass fresca', N'Palta Hass calibre exportacion', N'kg', 1, '2024-01-30 10:00:00'),
  (5, N'UVA-RB', N'Uva Red Globe', N'Uva de mesa Red Globe en caja de 8.2 kg', N'kg', 1, '2024-02-04 10:00:00'),
  (6, N'ESP-VERDE-IQF', N'Esparrago verde IQF', N'Esparrago verde congelado IQF', N'kg', 1, '2024-02-09 10:00:00');
SET IDENTITY_INSERT dbo.productos_finales OFF;
GO

/* ===== INDEPENDIENTE 4: USUARIOS (8) ===== */
SET IDENTITY_INSERT dbo.usuarios ON;
INSERT INTO dbo.usuarios (id, username, nombre_completo, rol, estado, fecha_creacion) VALUES
  (1, N'joperez', N'Jorge Perez Diaz', N'Operario', 1, '2024-01-05 07:45:00'),
  (2, N'lcastro', N'Lucia Castro Rojas', N'Operario', 1, '2024-01-08 07:45:00'),
  (3, N'mflores', N'Manuel Flores Vega', N'Operario', 1, '2024-01-11 07:45:00'),
  (4, N'rsalinas', N'Rosa Salinas Quispe', N'Inspector', 1, '2024-01-14 07:45:00'),
  (5, N'avargas', N'Andres Vargas Leon', N'Inspector', 1, '2024-01-17 07:45:00'),
  (6, N'ptorres', N'Patricia Torres Mego', N'Supervisor', 1, '2024-01-20 07:45:00'),
  (7, N'cgamarra', N'Carlos Gamarra Ruiz', N'Supervisor', 1, '2024-01-23 07:45:00'),
  (8, N'admin', N'Administrador del Sistema', N'Admin', 1, '2024-01-26 07:45:00');
SET IDENTITY_INSERT dbo.usuarios OFF;
GO

/* ===== INDEPENDIENTE 5: TIPOS_MERMA (CATALOGO, ya cargado por el DDL: ids 1..6).
   Solo se rellena si estuviera vacia (idempotente).                       ===== */
IF NOT EXISTS (SELECT 1 FROM dbo.tipos_merma)
BEGIN
    SET IDENTITY_INSERT dbo.tipos_merma ON;
    INSERT INTO dbo.tipos_merma (id, nombre, recuperable) VALUES
        (1,'Recorte (cabeza/base)',1),(2,'Descarte por calibre',1),
        (3,'Descarte por calidad',0),(4,'Deshidratacion',0),
        (5,'Dano mecanico',0),(6,'Otros',0);
    SET IDENTITY_INSERT dbo.tipos_merma OFF;
END
GO

/* ===== INDEPENDIENTE 6: FUNDOS (8, FK->proveedores) ===== */
SET IDENTITY_INSERT dbo.fundos ON;
INSERT INTO dbo.fundos (id, codigo_campo, nombre, id_proveedor, codigo_globalgap, variedad, area_hectareas, ubicacion, latitud, longitud, estado) VALUES
  (1, N'CMP-001', N'Fundo Santa Elena - Sector A', 1, N'4063061899999', N'UC-157', 45.5, N'Viru, La Libertad', -8.4151, -78.7523, 1),
  (2, N'CMP-002', N'Fundo Santa Elena - Sector B', 1, N'4063061899998', N'Atlas', 38.2, N'Viru, La Libertad', -8.4201, -78.7411, 1),
  (3, N'CMP-003', N'Fundo Los Olivos - Lote 1', 2, N'4063061811111', N'Biloxi', 22.0, N'Chao, La Libertad', -8.5512, -78.689, 1),
  (4, N'CMP-004', N'Fundo Los Olivos - Lote 2', 2, N'4063061822222', N'Ventura', 18.75, N'Chao, La Libertad', -8.5568, -78.6944, 1),
  (5, N'CMP-005', N'Fundo del Norte - Palto', 3, N'4063061833333', N'Hass', 60.0, N'Olmos, Lambayeque', -5.987, -79.756, 1),
  (6, N'CMP-006', N'Fundo del Norte - Esparrago', 3, N'4063061844444', N'UC-157', 52.3, N'Motupe, Lambayeque', -6.154, -79.712, 1),
  (7, N'CMP-007', N'Fundo Chao - Parronal', 4, N'4063061855555', N'Red Globe', 35.0, N'Chao, La Libertad', -8.499, -78.702, 1),
  (8, N'CMP-008', N'Fundo Chao - Esparrago', 4, N'4063061866666', N'Atlas', 41.1, N'Viru, La Libertad', -8.433, -78.73, 1);
SET IDENTITY_INSERT dbo.fundos OFF;
GO

/* ===== TRANSACCIONAL 1: MATERIAS_PRIMAS (22, FK->fundos) ===== */
SET IDENTITY_INSERT dbo.materias_primas ON;
INSERT INTO dbo.materias_primas (id, id_materia, nombre, id_fundo, fecha_cosecha, fecha_recepcion, modulo, turno, cantidad_ingresada, cantidad_aprobada, cantidad_rechazada, temperatura_recepcion, aplicacion, unidad_medida) VALUES
  (1, 100, N'Esparrago verde', 1, '2025-08-01 05:30:00', '2025-08-02 07:15:00', N'Modulo 1', N'Manana', 1500.0, 1470.0, 30.0, 4.0, N'Fresco', N'kg'),
  (2, 101, N'Esparrago blanco', 2, '2025-08-02 05:30:00', '2025-08-03 07:15:00', N'Modulo 2', N'Tarde', 1637.5, 1596.56, 40.94, 4.5, N'Fresco', N'kg'),
  (3, 102, N'Arandano', 3, '2025-08-03 05:30:00', '2025-08-04 07:15:00', N'Modulo 3', N'Noche', 1775.0, 1721.75, 53.25, 5.0, N'Fresco', N'kg'),
  (4, 102, N'Arandano', 4, '2025-08-04 05:30:00', '2025-08-05 07:15:00', N'Modulo 1', N'Manana', 1912.5, 1845.56, 66.94, 5.5, N'Fresco', N'kg'),
  (5, 103, N'Palta Hass', 5, '2025-08-05 05:30:00', '2025-08-06 07:15:00', N'Modulo 2', N'Tarde', 2050.0, 1968.0, 82.0, 6.0, N'Fresco', N'kg'),
  (6, 100, N'Esparrago verde', 6, '2025-08-06 05:30:00', '2025-08-07 07:15:00', N'Modulo 3', N'Noche', 2187.5, 2143.75, 43.75, 6.5, N'Fresco', N'kg'),
  (7, 104, N'Uva Red Globe', 7, '2025-08-07 05:30:00', '2025-08-08 07:15:00', N'Modulo 1', N'Manana', 2325.0, 2266.88, 58.12, 4.0, N'Fresco', N'kg'),
  (8, 100, N'Esparrago verde', 8, '2025-08-08 05:30:00', '2025-08-09 07:15:00', N'Modulo 2', N'Tarde', 2462.5, 2388.62, 73.88, 4.5, N'Fresco', N'kg'),
  (9, 100, N'Esparrago verde', 1, '2025-08-09 05:30:00', '2025-08-10 07:15:00', N'Modulo 3', N'Noche', 2600.0, 2509.0, 91.0, 5.0, N'Fresco', N'kg'),
  (10, 101, N'Esparrago blanco', 2, '2025-08-10 05:30:00', '2025-08-11 07:15:00', N'Modulo 1', N'Manana', 2737.5, 2628.0, 109.5, 5.5, N'Fresco', N'kg'),
  (11, 102, N'Arandano', 3, '2025-08-11 05:30:00', '2025-08-12 07:15:00', N'Modulo 2', N'Tarde', 2875.0, 2817.5, 57.5, 6.0, N'Fresco', N'kg'),
  (12, 102, N'Arandano', 4, '2025-08-12 05:30:00', '2025-08-13 07:15:00', N'Modulo 3', N'Noche', 3012.5, 2937.19, 75.31, 6.5, N'Fresco', N'kg'),
  (13, 103, N'Palta Hass', 5, '2025-08-13 05:30:00', '2025-08-14 07:15:00', N'Modulo 1', N'Manana', 3150.0, 3055.5, 94.5, 4.0, N'Fresco', N'kg'),
  (14, 100, N'Esparrago verde', 6, '2025-08-14 05:30:00', '2025-08-15 07:15:00', N'Modulo 2', N'Tarde', 3287.5, 3172.44, 115.06, 4.5, N'Fresco', N'kg'),
  (15, 104, N'Uva Red Globe', 7, '2025-08-15 05:30:00', '2025-08-16 07:15:00', N'Modulo 3', N'Noche', 3425.0, 3288.0, 137.0, 5.0, N'Fresco', N'kg'),
  (16, 100, N'Esparrago verde', 8, '2025-08-16 05:30:00', '2025-08-17 07:15:00', N'Modulo 1', N'Manana', 3562.5, 3491.25, 71.25, 5.5, N'Fresco', N'kg'),
  (17, 100, N'Esparrago verde', 1, '2025-08-17 05:30:00', '2025-08-18 07:15:00', N'Modulo 2', N'Tarde', 3700.0, 3607.5, 92.5, 6.0, N'Fresco', N'kg'),
  (18, 101, N'Esparrago blanco', 2, '2025-08-18 05:30:00', '2025-08-19 07:15:00', N'Modulo 3', N'Noche', 3837.5, 3722.38, 115.12, 6.5, N'Fresco', N'kg'),
  (19, 102, N'Arandano', 3, '2025-08-19 05:30:00', '2025-08-20 07:15:00', N'Modulo 1', N'Manana', 3975.0, 3835.88, 139.12, 4.0, N'Fresco', N'kg'),
  (20, 102, N'Arandano', 4, '2025-08-20 05:30:00', '2025-08-21 07:15:00', N'Modulo 2', N'Tarde', 4112.5, 3948.0, 164.5, 4.5, N'Fresco', N'kg'),
  (21, 103, N'Palta Hass', 5, '2025-08-21 05:30:00', '2025-08-22 07:15:00', N'Modulo 3', N'Noche', 4250.0, 4165.0, 85.0, 5.0, N'Fresco', N'kg'),
  (22, 100, N'Esparrago verde', 6, '2025-08-22 05:30:00', '2025-08-23 07:15:00', N'Modulo 1', N'Manana', 4387.5, 4277.81, 109.69, 5.5, N'Fresco', N'kg');
SET IDENTITY_INSERT dbo.materias_primas OFF;
GO

/* ===== TRANSACCIONAL 2: APLICACIONES_AGROQUIMICAS (20, FK->fundos,usuarios) ===== */
SET IDENTITY_INSERT dbo.aplicaciones_agroquimicas ON;
INSERT INTO dbo.aplicaciones_agroquimicas (id, id_fundo, producto, ingrediente_activo, dosis, fecha_aplicacion, carencia_dias, id_usuario, observaciones) VALUES
  (1, 1, N'Score 250 EC', N'Difenoconazol', N'0.5 L/ha', '2025-07-05 06:00:00', 14, 4, N'Monitoreo fitosanitario rutinario'),
  (2, 2, N'Movento 150 OD', N'Spirotetramat', N'0.75 L/ha', '2025-07-07 06:00:00', 7, 5, N'Aplicacion preventiva programada'),
  (3, 3, N'Karate Zeon', N'Lambda-cialotrina', N'0.2 L/ha', '2025-07-09 06:00:00', 7, 4, N'Aplicacion preventiva programada'),
  (4, 4, N'Cabrio Top', N'Piraclostrobin + Metiram', N'2.5 kg/ha', '2025-07-11 06:00:00', 21, 5, N'Monitoreo fitosanitario rutinario'),
  (5, 5, N'Bayfolan', N'Bioestimulante foliar', N'1.0 L/ha', '2025-07-13 06:00:00', 0, 4, N'Aplicacion preventiva programada'),
  (6, 6, N'Confidor 350 SC', N'Imidacloprid', N'0.3 L/ha', '2025-07-15 06:00:00', 14, 5, N'Aplicacion preventiva programada'),
  (7, 7, N'Score 250 EC', N'Difenoconazol', N'0.5 L/ha', '2025-07-17 06:00:00', 14, 4, N'Monitoreo fitosanitario rutinario'),
  (8, 8, N'Movento 150 OD', N'Spirotetramat', N'0.75 L/ha', '2025-07-19 06:00:00', 7, 5, N'Aplicacion preventiva programada'),
  (9, 1, N'Karate Zeon', N'Lambda-cialotrina', N'0.2 L/ha', '2025-07-21 06:00:00', 7, 4, N'Aplicacion preventiva programada'),
  (10, 2, N'Cabrio Top', N'Piraclostrobin + Metiram', N'2.5 kg/ha', '2025-07-23 06:00:00', 21, 5, N'Monitoreo fitosanitario rutinario'),
  (11, 3, N'Bayfolan', N'Bioestimulante foliar', N'1.0 L/ha', '2025-07-25 06:00:00', 0, 4, N'Aplicacion preventiva programada'),
  (12, 4, N'Confidor 350 SC', N'Imidacloprid', N'0.3 L/ha', '2025-07-27 06:00:00', 14, 5, N'Aplicacion preventiva programada'),
  (13, 5, N'Score 250 EC', N'Difenoconazol', N'0.5 L/ha', '2025-07-29 06:00:00', 14, 4, N'Monitoreo fitosanitario rutinario'),
  (14, 6, N'Movento 150 OD', N'Spirotetramat', N'0.75 L/ha', '2025-07-31 06:00:00', 7, 5, N'Aplicacion preventiva programada'),
  (15, 7, N'Karate Zeon', N'Lambda-cialotrina', N'0.2 L/ha', '2025-08-02 06:00:00', 7, 4, N'Aplicacion preventiva programada'),
  (16, 8, N'Cabrio Top', N'Piraclostrobin + Metiram', N'2.5 kg/ha', '2025-08-04 06:00:00', 21, 5, N'Monitoreo fitosanitario rutinario'),
  (17, 1, N'Bayfolan', N'Bioestimulante foliar', N'1.0 L/ha', '2025-08-06 06:00:00', 0, 4, N'Aplicacion preventiva programada'),
  (18, 2, N'Confidor 350 SC', N'Imidacloprid', N'0.3 L/ha', '2025-08-08 06:00:00', 14, 5, N'Aplicacion preventiva programada'),
  (19, 3, N'Score 250 EC', N'Difenoconazol', N'0.5 L/ha', '2025-08-10 06:00:00', 14, 4, N'Monitoreo fitosanitario rutinario'),
  (20, 4, N'Movento 150 OD', N'Spirotetramat', N'0.75 L/ha', '2025-08-12 06:00:00', 7, 5, N'Aplicacion preventiva programada');
SET IDENTITY_INSERT dbo.aplicaciones_agroquimicas OFF;
GO

/* ===== TRANSACCIONAL 3: ORDENES_PRODUCCION (20, FK->productos_finales,usuarios) ===== */
SET IDENTITY_INSERT dbo.ordenes_produccion ON;
INSERT INTO dbo.ordenes_produccion (id, fecha_inicio, fecha_fin, estado, cantidad_producida, unidad_medida, id_producto_final, observaciones, id_usuario) VALUES
  (1, '2025-08-03 06:30:00', '2025-08-04 18:00:00', N'Finalizado', 1000.0, N'kg', 1, N'Turno completo sin novedades', 6),
  (2, '2025-08-04 06:30:00', '2025-08-05 18:00:00', N'Finalizado', 1095.25, N'kg', 2, N'Cambio de calibre a media jornada', 7),
  (3, '2025-08-05 06:30:00', '2025-08-06 18:00:00', N'Finalizado', 1190.5, N'kg', 3, N'Turno completo sin novedades', 6),
  (4, '2025-08-06 06:30:00', '2025-08-07 18:00:00', N'Finalizado', 1285.75, N'kg', 4, N'Cambio de calibre a media jornada', 7),
  (5, '2025-08-07 06:30:00', '2025-08-08 18:00:00', N'Finalizado', 1381.0, N'kg', 5, N'Turno completo sin novedades', 6),
  (6, '2025-08-08 06:30:00', '2025-08-09 18:00:00', N'Finalizado', 1476.25, N'kg', 6, N'Cambio de calibre a media jornada', 7),
  (7, '2025-08-09 06:30:00', '2025-08-10 18:00:00', N'Finalizado', 1571.5, N'kg', 1, N'Turno completo sin novedades', 6),
  (8, '2025-08-10 06:30:00', '2025-08-11 18:00:00', N'Finalizado', 1666.75, N'kg', 2, N'Cambio de calibre a media jornada', 7),
  (9, '2025-08-11 06:30:00', '2025-08-12 18:00:00', N'Finalizado', 1762.0, N'kg', 3, N'Turno completo sin novedades', 6),
  (10, '2025-08-12 06:30:00', '2025-08-13 18:00:00', N'Finalizado', 1857.25, N'kg', 4, N'Cambio de calibre a media jornada', 7),
  (11, '2025-08-13 06:30:00', '2025-08-14 18:00:00', N'Finalizado', 1952.5, N'kg', 5, N'Turno completo sin novedades', 6),
  (12, '2025-08-14 06:30:00', '2025-08-15 18:00:00', N'Finalizado', 2047.75, N'kg', 6, N'Cambio de calibre a media jornada', 7),
  (13, '2025-08-15 06:30:00', '2025-08-16 18:00:00', N'Finalizado', 2143.0, N'kg', 1, N'Turno completo sin novedades', 6),
  (14, '2025-08-16 06:30:00', '2025-08-17 18:00:00', N'Finalizado', 2238.25, N'kg', 2, N'Cambio de calibre a media jornada', 7),
  (15, '2025-08-17 06:30:00', '2025-08-18 18:00:00', N'Finalizado', 2333.5, N'kg', 3, N'Turno completo sin novedades', 6),
  (16, '2025-08-18 06:30:00', '2025-08-19 18:00:00', N'Finalizado', 2428.75, N'kg', 4, N'Cambio de calibre a media jornada', 7),
  (17, '2025-08-19 06:30:00', '2025-08-20 18:00:00', N'Finalizado', 2524.0, N'kg', 5, N'Turno completo sin novedades', 6),
  (18, '2025-08-20 06:30:00', '2025-08-21 18:00:00', N'Finalizado', 2619.25, N'kg', 6, N'Cambio de calibre a media jornada', 7),
  (19, '2025-08-21 06:30:00', NULL, N'En proceso', 0, N'kg', 1, N'Turno completo sin novedades', 6),
  (20, '2025-08-22 06:30:00', NULL, N'En proceso', 0, N'kg', 2, N'Cambio de calibre a media jornada', 7);
SET IDENTITY_INSERT dbo.ordenes_produccion OFF;
GO

/* ===== TRANSACCIONAL 4: LOTES_PRODUCTO_FINAL (22, FK->productos_finales,ordenes) ===== */
SET IDENTITY_INSERT dbo.lotes_producto_final ON;
INSERT INTO dbo.lotes_producto_final (id, id_producto_final, id_orden_produccion, numero_lote, fecha_produccion, cantidad, unidad_medida, calibre, categoria, presentacion, estado, observaciones, aplicacion) VALUES
  (1, 1, 1, N'L2025-01-0001', '2025-08-05 16:00:00', 800.0, N'kg', N'S', N'Extra', N'Atado 250 g', 1, N'Liberado por calidad', N'Fresco'),
  (2, 2, 2, N'L2025-02-0002', '2025-08-06 16:00:00', 873.5, N'kg', N'M', N'Primera', N'Granel', 1, N'En cuarentena hasta resultado microbiologico', N'Fresco'),
  (3, 3, 3, N'L2025-03-0003', '2025-08-07 16:00:00', 947.0, N'kg', N'L', N'Segunda', N'Clamshell 125 g', 1, N'Liberado por calidad', N'Fresco'),
  (4, 4, 4, N'L2025-04-0004', '2025-08-08 16:00:00', 1020.5, N'kg', N'XL', N'Extra', N'Caja 8.2 kg', 1, N'En cuarentena hasta resultado microbiologico', N'Fresco'),
  (5, 5, 5, N'L2025-05-0005', '2025-08-09 16:00:00', 1094.0, N'kg', N'Jumbo', N'Primera', N'Bolsa 1 kg', 1, N'Liberado por calidad', N'Fresco'),
  (6, 6, 6, N'L2025-06-0006', '2025-08-10 16:00:00', 1167.5, N'kg', N'S', N'Segunda', N'Atado 250 g', 1, N'En cuarentena hasta resultado microbiologico', N'Fresco'),
  (7, 1, 7, N'L2025-01-0007', '2025-08-11 16:00:00', 1241.0, N'kg', N'M', N'Extra', N'Granel', 1, N'Liberado por calidad', N'Fresco'),
  (8, 2, 8, N'L2025-02-0008', '2025-08-12 16:00:00', 1314.5, N'kg', N'L', N'Primera', N'Clamshell 125 g', 1, N'En cuarentena hasta resultado microbiologico', N'Fresco'),
  (9, 3, 9, N'L2025-03-0009', '2025-08-13 16:00:00', 1388.0, N'kg', N'XL', N'Segunda', N'Caja 8.2 kg', 1, N'Liberado por calidad', N'Fresco'),
  (10, 4, 10, N'L2025-04-0010', '2025-08-14 16:00:00', 1461.5, N'kg', N'Jumbo', N'Extra', N'Bolsa 1 kg', 1, N'En cuarentena hasta resultado microbiologico', N'Fresco'),
  (11, 5, 11, N'L2025-05-0011', '2025-08-15 16:00:00', 1535.0, N'kg', N'S', N'Primera', N'Atado 250 g', 1, N'Liberado por calidad', N'Fresco'),
  (12, 6, 12, N'L2025-06-0012', '2025-08-16 16:00:00', 1608.5, N'kg', N'M', N'Segunda', N'Granel', 1, N'En cuarentena hasta resultado microbiologico', N'Fresco'),
  (13, 1, 13, N'L2025-01-0013', '2025-08-17 16:00:00', 1682.0, N'kg', N'L', N'Extra', N'Clamshell 125 g', 1, N'Liberado por calidad', N'Fresco'),
  (14, 2, 14, N'L2025-02-0014', '2025-08-18 16:00:00', 1755.5, N'kg', N'XL', N'Primera', N'Caja 8.2 kg', 1, N'En cuarentena hasta resultado microbiologico', N'Fresco'),
  (15, 3, 15, N'L2025-03-0015', '2025-08-19 16:00:00', 1829.0, N'kg', N'Jumbo', N'Segunda', N'Bolsa 1 kg', 1, N'Liberado por calidad', N'Fresco'),
  (16, 4, 16, N'L2025-04-0016', '2025-08-20 16:00:00', 1902.5, N'kg', N'S', N'Extra', N'Atado 250 g', 1, N'En cuarentena hasta resultado microbiologico', N'Fresco'),
  (17, 5, 17, N'L2025-05-0017', '2025-08-21 16:00:00', 1976.0, N'kg', N'M', N'Primera', N'Granel', 1, N'Liberado por calidad', N'Fresco'),
  (18, 6, 18, N'L2025-06-0018', '2025-08-22 16:00:00', 2049.5, N'kg', N'L', N'Segunda', N'Clamshell 125 g', 1, N'En cuarentena hasta resultado microbiologico', N'Fresco'),
  (19, 1, 1, N'L2025-01-0019', '2025-08-05 16:00:00', 2123.0, N'kg', N'XL', N'Extra', N'Caja 8.2 kg', 1, N'Liberado por calidad', N'Fresco'),
  (20, 2, 2, N'L2025-02-0020', '2025-08-06 16:00:00', 2196.5, N'kg', N'Jumbo', N'Primera', N'Bolsa 1 kg', 1, N'En cuarentena hasta resultado microbiologico', N'Fresco'),
  (21, 3, 3, N'L2025-03-0021', '2025-08-07 16:00:00', 2270.0, N'kg', N'S', N'Segunda', N'Atado 250 g', 1, N'Liberado por calidad', N'Fresco'),
  (22, 4, 4, N'L2025-04-0022', '2025-08-08 16:00:00', 2343.5, N'kg', N'M', N'Extra', N'Granel', 1, N'En cuarentena hasta resultado microbiologico', N'Fresco');
SET IDENTITY_INSERT dbo.lotes_producto_final OFF;
GO

/* ===== TRANSACCIONAL 5: ORDEN_PRODUCCION_MATERIA (24, puente M:N) ===== */
SET IDENTITY_INSERT dbo.orden_produccion_materia ON;
INSERT INTO dbo.orden_produccion_materia (id, id_orden_produccion, id_materia, cantidad_consumida, unidad_medida) VALUES
  (1, 1, 1, 500.0, N'kg'),
  (2, 2, 2, 561.0, N'kg'),
  (3, 3, 3, 622.0, N'kg'),
  (4, 3, 4, 683.0, N'kg'),
  (5, 4, 5, 744.0, N'kg'),
  (6, 5, 7, 805.0, N'kg'),
  (7, 6, 6, 866.0, N'kg'),
  (8, 6, 8, 927.0, N'kg'),
  (9, 7, 9, 988.0, N'kg'),
  (10, 8, 10, 1049.0, N'kg'),
  (11, 9, 11, 1110.0, N'kg'),
  (12, 9, 12, 1171.0, N'kg'),
  (13, 10, 13, 1232.0, N'kg'),
  (14, 11, 15, 1293.0, N'kg'),
  (15, 12, 14, 1354.0, N'kg'),
  (16, 12, 16, 1415.0, N'kg'),
  (17, 13, 17, 1476.0, N'kg'),
  (18, 14, 18, 1537.0, N'kg'),
  (19, 15, 19, 1598.0, N'kg'),
  (20, 15, 20, 1659.0, N'kg'),
  (21, 16, 21, 1720.0, N'kg'),
  (22, 17, 7, 1781.0, N'kg'),
  (23, 18, 22, 1842.0, N'kg'),
  (24, 18, 1, 1903.0, N'kg');
SET IDENTITY_INSERT dbo.orden_produccion_materia OFF;
GO

/* ===== TRANSACCIONAL 6: MERMAS (24, FK->ordenes,tipos_merma,usuarios) ===== */
SET IDENTITY_INSERT dbo.mermas ON;
INSERT INTO dbo.mermas (id, id_orden_produccion, id_tipo_merma, etapa, cantidad, unidad_medida, destino, fecha_registro, id_usuario, observaciones) VALUES
  (1, 1, 1, N'Recepcion', 20.0, N'kg', N'Compost', '2025-08-05 14:20:00', 1, N'Registrado en planta'),
  (2, 2, 2, N'Calibrado', 33.7, N'kg', N'Subproducto', '2025-08-06 14:20:00', 2, N'Validado por supervisor de turno'),
  (3, 3, 3, N'Seleccion', 47.4, N'kg', N'Descarte', '2025-08-07 14:20:00', 3, N'Registrado en planta'),
  (4, 4, 4, N'Empaque', 61.1, N'kg', N'Compost', '2025-08-08 14:20:00', 1, N'Validado por supervisor de turno'),
  (5, 5, 5, N'Recepcion', 74.8, N'kg', N'Subproducto', '2025-08-09 14:20:00', 2, N'Registrado en planta'),
  (6, 6, 6, N'Calibrado', 88.5, N'kg', N'Descarte', '2025-08-10 14:20:00', 3, N'Validado por supervisor de turno'),
  (7, 7, 1, N'Seleccion', 102.2, N'kg', N'Compost', '2025-08-11 14:20:00', 1, N'Registrado en planta'),
  (8, 8, 2, N'Empaque', 115.9, N'kg', N'Subproducto', '2025-08-12 14:20:00', 2, N'Validado por supervisor de turno'),
  (9, 9, 3, N'Recepcion', 129.6, N'kg', N'Descarte', '2025-08-13 14:20:00', 3, N'Registrado en planta'),
  (10, 10, 4, N'Calibrado', 143.3, N'kg', N'Compost', '2025-08-14 14:20:00', 1, N'Validado por supervisor de turno'),
  (11, 11, 5, N'Seleccion', 157.0, N'kg', N'Subproducto', '2025-08-15 14:20:00', 2, N'Registrado en planta'),
  (12, 12, 6, N'Empaque', 170.7, N'kg', N'Descarte', '2025-08-16 14:20:00', 3, N'Validado por supervisor de turno'),
  (13, 13, 1, N'Recepcion', 184.4, N'kg', N'Compost', '2025-08-17 14:20:00', 1, N'Registrado en planta'),
  (14, 14, 2, N'Calibrado', 198.1, N'kg', N'Subproducto', '2025-08-18 14:20:00', 2, N'Validado por supervisor de turno'),
  (15, 15, 3, N'Seleccion', 211.8, N'kg', N'Descarte', '2025-08-19 14:20:00', 3, N'Registrado en planta'),
  (16, 16, 4, N'Empaque', 225.5, N'kg', N'Compost', '2025-08-20 14:20:00', 1, N'Validado por supervisor de turno'),
  (17, 17, 5, N'Recepcion', 239.2, N'kg', N'Subproducto', '2025-08-21 14:20:00', 2, N'Registrado en planta'),
  (18, 18, 6, N'Calibrado', 252.9, N'kg', N'Descarte', '2025-08-22 14:20:00', 3, N'Validado por supervisor de turno'),
  (19, 1, 1, N'Seleccion', 266.6, N'kg', N'Compost', '2025-08-05 14:20:00', 1, N'Registrado en planta'),
  (20, 2, 2, N'Empaque', 280.3, N'kg', N'Subproducto', '2025-08-06 14:20:00', 2, N'Validado por supervisor de turno'),
  (21, 3, 3, N'Recepcion', 294.0, N'kg', N'Descarte', '2025-08-07 14:20:00', 3, N'Registrado en planta'),
  (22, 4, 4, N'Calibrado', 307.7, N'kg', N'Compost', '2025-08-08 14:20:00', 1, N'Validado por supervisor de turno'),
  (23, 5, 5, N'Seleccion', 321.4, N'kg', N'Subproducto', '2025-08-09 14:20:00', 2, N'Registrado en planta'),
  (24, 6, 6, N'Empaque', 335.1, N'kg', N'Descarte', '2025-08-10 14:20:00', 3, N'Validado por supervisor de turno');
SET IDENTITY_INSERT dbo.mermas OFF;
GO

/* ===== TRANSACCIONAL 7: CADENA_FRIO (24, FK->lotes,usuarios) ===== */
SET IDENTITY_INSERT dbo.cadena_frio ON;
INSERT INTO dbo.cadena_frio (id, id_lote_producto_final, ubicacion, fecha_hora, temperatura, humedad_pct, id_usuario) VALUES
  (1, 1, N'Hidrocooler', '2025-08-06 08:00:00', 0.5, 88.0, 1),
  (2, 2, N'Camara 1', '2025-08-06 14:00:00', 1.1, 89.2, 2),
  (3, 3, N'Camara 2', '2025-08-06 20:00:00', 1.7, 90.4, 3),
  (4, 4, N'Anden de carga', '2025-08-07 02:00:00', 2.3, 91.6, 1),
  (5, 5, N'Tunel IQF', '2025-08-07 08:00:00', 2.9, 92.8, 2),
  (6, 6, N'Hidrocooler', '2025-08-07 14:00:00', 3.5, 94.0, 3),
  (7, 7, N'Camara 1', '2025-08-07 20:00:00', 4.1, 88.0, 1),
  (8, 8, N'Camara 2', '2025-08-08 02:00:00', 0.5, 89.2, 2),
  (9, 9, N'Anden de carga', '2025-08-08 08:00:00', 1.1, 90.4, 3),
  (10, 10, N'Tunel IQF', '2025-08-08 14:00:00', 1.7, 91.6, 1),
  (11, 11, N'Hidrocooler', '2025-08-08 20:00:00', 2.3, 92.8, 2),
  (12, 12, N'Camara 1', '2025-08-09 02:00:00', 2.9, 94.0, 3),
  (13, 13, N'Camara 2', '2025-08-09 08:00:00', 3.5, 88.0, 1),
  (14, 14, N'Anden de carga', '2025-08-09 14:00:00', 4.1, 89.2, 2),
  (15, 15, N'Tunel IQF', '2025-08-09 20:00:00', 0.5, 90.4, 3),
  (16, 16, N'Hidrocooler', '2025-08-10 02:00:00', 1.1, 91.6, 1),
  (17, 17, N'Camara 1', '2025-08-10 08:00:00', 1.7, 92.8, 2),
  (18, 18, N'Camara 2', '2025-08-10 14:00:00', 2.3, 94.0, 3),
  (19, 19, N'Anden de carga', '2025-08-10 20:00:00', 2.9, 88.0, 1),
  (20, 20, N'Tunel IQF', '2025-08-11 02:00:00', 3.5, 89.2, 2),
  (21, 21, N'Hidrocooler', '2025-08-11 08:00:00', 4.1, 90.4, 3),
  (22, 22, N'Camara 1', '2025-08-11 14:00:00', 0.5, 91.6, 1),
  (23, 1, N'Camara 2', '2025-08-11 20:00:00', 1.1, 92.8, 2),
  (24, 2, N'Anden de carga', '2025-08-12 02:00:00', 1.7, 94.0, 3);
SET IDENTITY_INSERT dbo.cadena_frio OFF;
GO

/* ===== TRANSACCIONAL 8: CONTROL_CALIDAD (24, respeta chk_cc_anclaje).
   OJO: etapa 'Recepcion' lleva tilde para coincidir con el CHECK.   ===== */
SET IDENTITY_INSERT dbo.control_calidad ON;
INSERT INTO dbo.control_calidad (id, etapa, id_materia, id_orden_produccion, id_lote_producto_final, fecha_inspeccion, resultado, parametro, valor_medido, observaciones, id_usuario) VALUES
  (1, N'Recepción', 1, NULL, NULL, '2025-08-02 07:30:00', N'Aprobado', N'Temperatura', N'4.2 C', N'Inspeccion de recepcion de materia prima', 4),
  (2, N'Recepción', 2, NULL, NULL, '2025-08-03 07:30:00', N'Aprobado', N'Defectos', N'1.5%', N'Inspeccion de recepcion de materia prima', 5),
  (3, N'Recepción', 3, NULL, NULL, '2025-08-04 07:30:00', N'Aprobado', N'Calibre', N'Conforme', N'Inspeccion de recepcion de materia prima', 4),
  (4, N'Recepción', 4, NULL, NULL, '2025-08-05 07:30:00', N'Aprobado', N'Brix', N'7.8', N'Inspeccion de recepcion de materia prima', 5),
  (5, N'Recepción', 5, NULL, NULL, '2025-08-06 07:30:00', N'Aprobado', N'Humedad', N'OK', N'Inspeccion de recepcion de materia prima', 4),
  (6, N'Recepción', 6, NULL, NULL, '2025-08-07 07:30:00', N'Rechazado', N'Defectos', N'6.0%', N'Inspeccion de recepcion de materia prima', 5),
  (7, N'Recepción', 7, NULL, NULL, '2025-08-08 07:30:00', N'Aprobado', N'Temperatura', N'5.0 C', N'Inspeccion de recepcion de materia prima', 4),
  (8, N'Recepción', 8, NULL, NULL, '2025-08-09 07:30:00', N'Aprobado', N'Residuos', N'< LMR', N'Inspeccion de recepcion de materia prima', 5),
  (9, N'En proceso', NULL, 1, NULL, '2025-08-03 11:00:00', N'Conforme', N'Calibre', N'L', N'Control en linea de proceso', 4),
  (10, N'En proceso', NULL, 2, NULL, '2025-08-04 11:00:00', N'Conforme', N'Defectos', N'2.1%', N'Control en linea de proceso', 5),
  (11, N'En proceso', NULL, 3, NULL, '2025-08-05 11:00:00', N'Conforme', N'Temperatura', N'6.5 C', N'Control en linea de proceso', 4),
  (12, N'En proceso', NULL, 4, NULL, '2025-08-06 11:00:00', N'Conforme', N'Peso atado', N'252 g', N'Control en linea de proceso', 5),
  (13, N'En proceso', NULL, 5, NULL, '2025-08-07 11:00:00', N'No conforme', N'Defectos', N'8.0%', N'Control en linea de proceso', 4),
  (14, N'En proceso', NULL, 6, NULL, '2025-08-08 11:00:00', N'Conforme', N'Higiene', N'OK', N'Control en linea de proceso', 5),
  (15, N'En proceso', NULL, 7, NULL, '2025-08-09 11:00:00', N'Conforme', N'Calibre', N'XL', N'Control en linea de proceso', 4),
  (16, N'En proceso', NULL, 8, NULL, '2025-08-10 11:00:00', N'Conforme', N'Peso atado', N'248 g', N'Control en linea de proceso', 5),
  (17, N'Producto terminado', NULL, NULL, 1, '2025-08-04 17:30:00', N'Aprobado', N'Microbiologico', N'Conforme', N'Liberacion de producto terminado', 4),
  (18, N'Producto terminado', NULL, NULL, 2, '2025-08-05 17:30:00', N'Aprobado', N'Brix', N'8.4', N'Liberacion de producto terminado', 5),
  (19, N'Producto terminado', NULL, NULL, 3, '2025-08-06 17:30:00', N'Aprobado', N'Calibre', N'Jumbo', N'Liberacion de producto terminado', 4),
  (20, N'Producto terminado', NULL, NULL, 4, '2025-08-07 17:30:00', N'Aprobado', N'Defectos', N'1.0%', N'Liberacion de producto terminado', 5),
  (21, N'Producto terminado', NULL, NULL, 5, '2025-08-08 17:30:00', N'Aprobado', N'Temperatura', N'1.0 C', N'Liberacion de producto terminado', 4),
  (22, N'Producto terminado', NULL, NULL, 6, '2025-08-09 17:30:00', N'Aprobado', N'Residuos', N'< LMR', N'Liberacion de producto terminado', 5),
  (23, N'Producto terminado', NULL, NULL, 7, '2025-08-10 17:30:00', N'Rechazado', N'Microbiologico', N'No conforme', N'Liberacion de producto terminado', 4),
  (24, N'Producto terminado', NULL, NULL, 8, '2025-08-11 17:30:00', N'Aprobado', N'Peso neto', N'8.20 kg', N'Liberacion de producto terminado', 5);
SET IDENTITY_INSERT dbo.control_calidad OFF;
GO

/* ===== TRANSACCIONAL 9: DESPACHOS (20, FK->clientes,lotes) ===== */
SET IDENTITY_INSERT dbo.despachos ON;
INSERT INTO dbo.despachos (id, id_cliente, id_lote_producto_final, numero_despacho, fecha_despacho, cantidad, unidad_medida, direccion_entrega, estado, tipo_envio, transportista, placa_vehiculo, precinto, guia_remision, awb_contenedor, temperatura_carga, pais, observaciones) VALUES
  (1, 1, 1, N'DSP-2025-0001', '2025-08-12 20:00:00', 500.0, N'kg', N'Almacen de destino #1, Estados Unidos', N'Entregado', N'Maritimo', N'Maersk Line', NULL, N'PRE100000', N'T001-50000', N'CONT-MSKU700000', 0.5, N'Estados Unidos', N'Carga inspeccionada y precintada'),
  (2, 2, 2, N'DSP-2025-0002', '2025-08-13 20:00:00', 588.0, N'kg', N'Almacen de destino #2, Paises Bajos', N'En transito', N'Aereo', N'DHL Aviation', NULL, N'PRE100001', N'T001-50001', N'AWB-16000000001', 0.9, N'Paises Bajos', N'Despacho con certificado fitosanitario SENASA'),
  (3, 3, 3, N'DSP-2025-0003', '2025-08-14 20:00:00', 676.0, N'kg', N'Almacen de destino #3, Singapur', N'Pendiente', N'Terrestre', N'Transportes Cruz del Sur', N'C34-567', N'PRE100002', N'T001-50002', NULL, 1.3, N'Singapur', N'Carga inspeccionada y precintada'),
  (4, 4, 4, N'DSP-2025-0004', '2025-08-15 20:00:00', 764.0, N'kg', N'Almacen de destino #4, Peru', N'Entregado', N'Maritimo', N'Hapag-Lloyd', NULL, N'PRE100003', N'T001-50003', N'CONT-MSKU700003', 1.7, N'Peru', N'Despacho con certificado fitosanitario SENASA'),
  (5, 5, 5, N'DSP-2025-0005', '2025-08-16 20:00:00', 852.0, N'kg', N'Almacen de destino #5, Reino Unido', N'En transito', N'Aereo', N'LATAM Cargo', NULL, N'PRE100004', N'T001-50004', N'AWB-16000000004', 2.1, N'Reino Unido', N'Carga inspeccionada y precintada'),
  (6, 6, 6, N'DSP-2025-0006', '2025-08-17 20:00:00', 940.0, N'kg', N'Almacen de destino #6, Espana', N'Pendiente', N'Terrestre', N'Maersk Line', N'F67-801', N'PRE100005', N'T001-50005', NULL, 0.5, N'Espana', N'Despacho con certificado fitosanitario SENASA'),
  (7, 7, 7, N'DSP-2025-0007', '2025-08-18 20:00:00', 1028.0, N'kg', N'Almacen de destino #7, Canada', N'Entregado', N'Maritimo', N'DHL Aviation', NULL, N'PRE100006', N'T001-50006', N'CONT-MSKU700006', 0.9, N'Canada', N'Carga inspeccionada y precintada'),
  (8, 8, 8, N'DSP-2025-0008', '2025-08-19 20:00:00', 1116.0, N'kg', N'Almacen de destino #8, Peru', N'En transito', N'Aereo', N'Transportes Cruz del Sur', NULL, N'PRE100007', N'T001-50007', N'AWB-16000000007', 1.3, N'Peru', N'Despacho con certificado fitosanitario SENASA'),
  (9, 1, 9, N'DSP-2025-0009', '2025-08-20 20:00:00', 1204.0, N'kg', N'Almacen de destino #9, Estados Unidos', N'Pendiente', N'Terrestre', N'Hapag-Lloyd', N'C01-234', N'PRE100008', N'T001-50008', NULL, 1.7, N'Estados Unidos', N'Carga inspeccionada y precintada'),
  (10, 2, 10, N'DSP-2025-0010', '2025-08-21 20:00:00', 1292.0, N'kg', N'Almacen de destino #10, Paises Bajos', N'Entregado', N'Maritimo', N'LATAM Cargo', NULL, N'PRE100009', N'T001-50009', N'CONT-MSKU700009', 2.1, N'Paises Bajos', N'Despacho con certificado fitosanitario SENASA'),
  (11, 3, 11, N'DSP-2025-0011', '2025-08-22 20:00:00', 1380.0, N'kg', N'Almacen de destino #11, Singapur', N'En transito', N'Aereo', N'Maersk Line', NULL, N'PRE100010', N'T001-50010', N'AWB-16000000010', 0.5, N'Singapur', N'Carga inspeccionada y precintada'),
  (12, 4, 12, N'DSP-2025-0012', '2025-08-23 20:00:00', 1468.0, N'kg', N'Almacen de destino #12, Peru', N'Pendiente', N'Terrestre', N'DHL Aviation', N'F34-567', N'PRE100011', N'T001-50011', NULL, 0.9, N'Peru', N'Despacho con certificado fitosanitario SENASA'),
  (13, 5, 13, N'DSP-2025-0013', '2025-08-24 20:00:00', 1556.0, N'kg', N'Almacen de destino #13, Reino Unido', N'Entregado', N'Maritimo', N'Transportes Cruz del Sur', NULL, N'PRE100012', N'T001-50012', N'CONT-MSKU700012', 1.3, N'Reino Unido', N'Carga inspeccionada y precintada'),
  (14, 6, 14, N'DSP-2025-0014', '2025-08-25 20:00:00', 1644.0, N'kg', N'Almacen de destino #14, Espana', N'En transito', N'Aereo', N'Hapag-Lloyd', NULL, N'PRE100013', N'T001-50013', N'AWB-16000000013', 1.7, N'Espana', N'Despacho con certificado fitosanitario SENASA'),
  (15, 7, 15, N'DSP-2025-0015', '2025-08-26 20:00:00', 1732.0, N'kg', N'Almacen de destino #15, Canada', N'Pendiente', N'Terrestre', N'LATAM Cargo', N'C67-801', N'PRE100014', N'T001-50014', NULL, 2.1, N'Canada', N'Carga inspeccionada y precintada'),
  (16, 8, 16, N'DSP-2025-0016', '2025-08-27 20:00:00', 1820.0, N'kg', N'Almacen de destino #16, Peru', N'Entregado', N'Maritimo', N'Maersk Line', NULL, N'PRE100015', N'T001-50015', N'CONT-MSKU700015', 0.5, N'Peru', N'Despacho con certificado fitosanitario SENASA'),
  (17, 1, 17, N'DSP-2025-0017', '2025-08-28 20:00:00', 1908.0, N'kg', N'Almacen de destino #17, Estados Unidos', N'En transito', N'Aereo', N'DHL Aviation', NULL, N'PRE100016', N'T001-50016', N'AWB-16000000016', 0.9, N'Estados Unidos', N'Carga inspeccionada y precintada'),
  (18, 2, 18, N'DSP-2025-0018', '2025-08-29 20:00:00', 1996.0, N'kg', N'Almacen de destino #18, Paises Bajos', N'Pendiente', N'Terrestre', N'Transportes Cruz del Sur', N'F01-234', N'PRE100017', N'T001-50017', NULL, 1.3, N'Paises Bajos', N'Despacho con certificado fitosanitario SENASA'),
  (19, 3, 19, N'DSP-2025-0019', '2025-08-30 20:00:00', 2084.0, N'kg', N'Almacen de destino #19, Singapur', N'Entregado', N'Maritimo', N'Hapag-Lloyd', NULL, N'PRE100018', N'T001-50018', N'CONT-MSKU700018', 1.7, N'Singapur', N'Carga inspeccionada y precintada'),
  (20, 4, 20, N'DSP-2025-0020', '2025-08-31 20:00:00', 2172.0, N'kg', N'Almacen de destino #20, Peru', N'En transito', N'Aereo', N'LATAM Cargo', NULL, N'PRE100019', N'T001-50019', N'AWB-16000000019', 2.1, N'Peru', N'Despacho con certificado fitosanitario SENASA');
SET IDENTITY_INSERT dbo.despachos OFF;
GO

/* ------------------------------------------------------------------
   VERIFICACION RAPIDA (conteo por tabla)
   ------------------------------------------------------------------ */
SELECT 'proveedores' AS tabla, COUNT(*) AS registros FROM dbo.proveedores
UNION ALL SELECT 'clientes', COUNT(*) FROM dbo.clientes
UNION ALL SELECT 'productos_finales', COUNT(*) FROM dbo.productos_finales
UNION ALL SELECT 'usuarios', COUNT(*) FROM dbo.usuarios
UNION ALL SELECT 'tipos_merma', COUNT(*) FROM dbo.tipos_merma
UNION ALL SELECT 'fundos', COUNT(*) FROM dbo.fundos
UNION ALL SELECT 'materias_primas', COUNT(*) FROM dbo.materias_primas
UNION ALL SELECT 'aplicaciones_agroquimicas', COUNT(*) FROM dbo.aplicaciones_agroquimicas
UNION ALL SELECT 'ordenes_produccion', COUNT(*) FROM dbo.ordenes_produccion
UNION ALL SELECT 'lotes_producto_final', COUNT(*) FROM dbo.lotes_producto_final
UNION ALL SELECT 'orden_produccion_materia', COUNT(*) FROM dbo.orden_produccion_materia
UNION ALL SELECT 'mermas', COUNT(*) FROM dbo.mermas
UNION ALL SELECT 'cadena_frio', COUNT(*) FROM dbo.cadena_frio
UNION ALL SELECT 'control_calidad', COUNT(*) FROM dbo.control_calidad
UNION ALL SELECT 'despachos', COUNT(*) FROM dbo.despachos
ORDER BY tabla;
GO

/* Indicadores de ejemplo */
SELECT * FROM dbo.vw_rendimiento_orden ORDER BY id_orden;
SELECT * FROM dbo.vw_merma_por_tipo ORDER BY cantidad_total DESC;
SELECT * FROM dbo.vw_calidad_aprobacion;
SELECT TOP 20 * FROM dbo.vw_trazabilidad_lote ORDER BY numero_lote;
GO