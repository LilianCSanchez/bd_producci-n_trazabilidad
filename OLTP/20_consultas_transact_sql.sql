
USE bd_produccion_trazabilidad;
GO


/* ############################################################################
   PARTE 1 — CONSULTAS BASICAS E INTERMEDIAS (01–10)
   ############################################################################ */


/* ----------------------------------------------------------------------------
   CONSULTA 01  (BASICA) — SELECT con WHERE y ORDER BY
   Objetivo: listar los clientes activos, mostrando solo algunas columnas,
   ordenados alfabeticamente por razon social.
   Conceptos: SELECT de columnas, filtro WHERE, orden ASC.
   ---------------------------------------------------------------------------- */
SELECT
    id,
    razon_social,
    pais,
    email
FROM dbo.clientes
WHERE estado = 1                 -- 1 = activo
ORDER BY razon_social ASC;
GO


/* ----------------------------------------------------------------------------
   CONSULTA 02  (BASICA) — TOP + ORDER BY DESC
   Objetivo: ver los 5 lotes de producto final con MAYOR cantidad producida.
   Conceptos: TOP (N), ordenar de mayor a menor.
   ---------------------------------------------------------------------------- */
SELECT TOP (5)
    numero_lote,
    fecha_produccion,
    cantidad,
    unidad_medida,
    categoria
FROM dbo.lotes_producto_final
ORDER BY cantidad DESC;
GO


/* ----------------------------------------------------------------------------
   CONSULTA 03  (BASICA) — Filtro de texto con LIKE
   Objetivo: buscar productos finales cuyo nombre contenga la palabra "fresco".
   Conceptos: LIKE con comodin %, busqueda parcial de texto.
   ---------------------------------------------------------------------------- */
SELECT
    codigo,
    nombre,
    unidad_medida
FROM dbo.productos_finales
WHERE nombre LIKE '%fresco%'
ORDER BY nombre;
GO


/* ----------------------------------------------------------------------------
   CONSULTA 04  (BASICA) — Agregacion con COUNT y GROUP BY
   Objetivo: contar cuantos clientes hay por pais.
   Conceptos: funcion de agregacion COUNT(*), agrupar con GROUP BY.
   ---------------------------------------------------------------------------- */
SELECT
    pais,
    COUNT(*) AS total_clientes
FROM dbo.clientes
GROUP BY pais
ORDER BY total_clientes DESC;
GO


/* ----------------------------------------------------------------------------
   CONSULTA 05  (INTERMEDIA) — INNER JOIN de dos tablas
   Objetivo: mostrar cada fundo junto con la razon social de su proveedor.
   Conceptos: relacionar tablas mediante claves foraneas (id_proveedor).
   ---------------------------------------------------------------------------- */
SELECT
    f.codigo_campo,
    f.nombre        AS fundo,
    f.variedad,
    f.area_hectareas,
    p.razon_social  AS proveedor
FROM dbo.fundos AS f
INNER JOIN dbo.proveedores AS p
        ON p.id = f.id_proveedor
ORDER BY p.razon_social, f.nombre;
GO


/* ----------------------------------------------------------------------------
   CONSULTA 06  (INTERMEDIA) — JOIN de varias tablas
   Objetivo: por cada materia prima recibida, mostrar de que fundo y de que
   proveedor proviene (trazabilidad hacia atras, paso a paso).
   Conceptos: encadenar varios INNER JOIN.
   ---------------------------------------------------------------------------- */
SELECT
    mp.nombre            AS materia_prima,
    mp.fecha_recepcion,
    mp.cantidad_ingresada,
    f.codigo_campo,
    f.variedad,
    pr.razon_social      AS proveedor
FROM dbo.materias_primas AS mp
INNER JOIN dbo.fundos        AS f  ON f.id  = mp.id_fundo
INNER JOIN dbo.proveedores   AS pr ON pr.id = f.id_proveedor
ORDER BY mp.fecha_recepcion DESC;
GO


/* ----------------------------------------------------------------------------
   CONSULTA 07  (INTERMEDIA) — Agregacion + HAVING
   Objetivo: listar los proveedores que tienen MAS DE UN fundo registrado.
   Conceptos: GROUP BY + filtrar grupos con HAVING (no con WHERE).
   ---------------------------------------------------------------------------- */
SELECT
    pr.razon_social,
    COUNT(f.id) AS cantidad_fundos
FROM dbo.proveedores AS pr
INNER JOIN dbo.fundos AS f
        ON f.id_proveedor = pr.id
GROUP BY pr.razon_social
HAVING COUNT(f.id) > 1
ORDER BY cantidad_fundos DESC;
GO


/* ----------------------------------------------------------------------------
   CONSULTA 08  (INTERMEDIA) — Funciones de fecha (DATEDIFF / GETDATE)
   Objetivo: ver los despachos y cuantos dias han pasado desde su fecha.
   Conceptos: DATEDIFF, GETDATE(), columnas calculadas en el SELECT.
   ---------------------------------------------------------------------------- */
SELECT
    numero_despacho,
    fecha_despacho,
    cantidad,
    estado,
    DATEDIFF(DAY, fecha_despacho, GETDATE()) AS dias_desde_despacho
FROM dbo.despachos
ORDER BY fecha_despacho DESC;
GO


/* ----------------------------------------------------------------------------
   CONSULTA 09  (INTERMEDIA) — CASE para clasificar filas
   Objetivo: clasificar cada despacho como "Exportacion" o "Nacional"
   segun el pais de destino.
   Conceptos: expresion CASE WHEN ... THEN ... ELSE ... END.
   ---------------------------------------------------------------------------- */
SELECT
    d.numero_despacho,
    c.razon_social AS cliente,
    d.pais,
    d.cantidad,
    CASE
        WHEN d.pais = N'Peru' THEN N'Nacional'
        ELSE N'Exportacion'
    END AS tipo_mercado
FROM dbo.despachos AS d
INNER JOIN dbo.clientes AS c
        ON c.id = d.id_cliente
ORDER BY tipo_mercado, d.pais;
GO


/* ----------------------------------------------------------------------------
   CONSULTA 10  (INTERMEDIA) — Subconsulta con IN
   Objetivo: listar los clientes que SI tienen al menos un despacho registrado.
   Conceptos: subconsulta dentro de WHERE usando el operador IN.
   ---------------------------------------------------------------------------- */
SELECT
    id,
    razon_social,
    pais
FROM dbo.clientes
WHERE id IN (SELECT DISTINCT id_cliente FROM dbo.despachos)
ORDER BY razon_social;
GO


/* ############################################################################
   PARTE 2 — CONSULTAS AVANZADAS Y EXPERTAS (11–20)
   ############################################################################ */


/* ----------------------------------------------------------------------------
   CONSULTA 11  (AVANZADA) — CTE + ROW_NUMBER() para obtener "el ultimo de cada"
   Objetivo: obtener la ULTIMA lectura de temperatura de cadena de frio
   por cada lote (la mas reciente).
   Conceptos: CTE (WITH), funcion de ventana ROW_NUMBER con PARTITION BY.
   ---------------------------------------------------------------------------- */
WITH lecturas_ordenadas AS (
    SELECT
        cf.id_lote_producto_final,
        cf.ubicacion,
        cf.fecha_hora,
        cf.temperatura,
        ROW_NUMBER() OVER (
            PARTITION BY cf.id_lote_producto_final
            ORDER BY cf.fecha_hora DESC
        ) AS rn
    FROM dbo.cadena_frio AS cf
)
SELECT
    l.numero_lote,
    lo.ubicacion,
    lo.fecha_hora      AS ultima_lectura,
    lo.temperatura
FROM lecturas_ordenadas AS lo
INNER JOIN dbo.lotes_producto_final AS l
        ON l.id = lo.id_lote_producto_final
WHERE lo.rn = 1                  -- nos quedamos solo con la lectura mas reciente
ORDER BY l.numero_lote;
GO


/* ----------------------------------------------------------------------------
   CONSULTA 12  (AVANZADA) — RANK() : ranking de clientes por volumen
   Objetivo: rankear a los clientes segun la cantidad total despachada.
   Conceptos: agregacion + funcion de ventana RANK() OVER (ORDER BY ...).
   ---------------------------------------------------------------------------- */
SELECT
    c.razon_social,
    c.pais,
    SUM(d.cantidad) AS total_despachado,
    RANK() OVER (ORDER BY SUM(d.cantidad) DESC) AS ranking
FROM dbo.despachos AS d
INNER JOIN dbo.clientes AS c
        ON c.id = d.id_cliente
GROUP BY c.razon_social, c.pais
ORDER BY ranking;
GO


/* ----------------------------------------------------------------------------
   CONSULTA 13  (AVANZADA) — Total acumulado (running total) con SUM() OVER
   Objetivo: mostrar la produccion de cada orden y el acumulado en el tiempo.
   Conceptos: SUM() OVER (ORDER BY ... ROWS UNBOUNDED PRECEDING).
   ---------------------------------------------------------------------------- */
SELECT
    op.id            AS id_orden,
    op.fecha_inicio,
    op.cantidad_producida,
    SUM(op.cantidad_producida) OVER (
        ORDER BY op.fecha_inicio, op.id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS produccion_acumulada
FROM dbo.ordenes_produccion AS op
ORDER BY op.fecha_inicio, op.id;
GO


/* ----------------------------------------------------------------------------
   CONSULTA 14  (AVANZADA) — NOT EXISTS : encontrar lo que NO tiene relacion
   Objetivo: listar los lotes de producto final que AUN NO han sido despachados.
   Conceptos: subconsulta correlacionada con NOT EXISTS (deteccion de huerfanos).
   ---------------------------------------------------------------------------- */
SELECT
    l.numero_lote,
    pf.nombre        AS producto,
    l.cantidad,
    l.fecha_produccion
FROM dbo.lotes_producto_final AS l
INNER JOIN dbo.productos_finales AS pf
        ON pf.id = l.id_producto_final
WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.despachos AS d
        WHERE d.id_lote_producto_final = l.id
      )
ORDER BY l.fecha_produccion;
GO


/* ----------------------------------------------------------------------------
   CONSULTA 15  (AVANZADA) — PIVOT : convertir filas en columnas
   Objetivo: mostrar la cantidad de merma por etapa, con cada etapa como columna.
   Conceptos: operador PIVOT con una funcion de agregacion (SUM).
   ---------------------------------------------------------------------------- */
SELECT *
FROM (
    SELECT
        t.nombre   AS tipo_merma,
        m.etapa,
        m.cantidad
    FROM dbo.mermas AS m
    INNER JOIN dbo.tipos_merma AS t
            ON t.id = m.id_tipo_merma
) AS origen
PIVOT (
    SUM(cantidad)
    FOR etapa IN ([Recepcion], [Calibrado], [Seleccion], [Empaque])
) AS tabla_pivote
ORDER BY tipo_merma;
GO


/* ----------------------------------------------------------------------------
   CONSULTA 16  (EXPERTA) — CTE recursiva : generar un calendario de fechas
   Objetivo: generar todos los dias de un rango y contar despachos por dia
   (incluyendo dias con 0 despachos). La recursividad genera la serie de fechas.
   Conceptos: CTE recursiva (ancla + miembro recursivo), LEFT JOIN, OPTION MAXRECURSION.
   ---------------------------------------------------------------------------- */
WITH calendario AS (
    -- Miembro ancla: fecha inicial
    SELECT CAST('2025-01-01' AS DATE) AS dia
    UNION ALL
    -- Miembro recursivo: suma 1 dia hasta el limite
    SELECT DATEADD(DAY, 1, dia)
    FROM calendario
    WHERE dia < '2025-01-31'
)
SELECT
    cal.dia,
    COUNT(d.id) AS despachos_del_dia
FROM calendario AS cal
LEFT JOIN dbo.despachos AS d
       ON CAST(d.fecha_despacho AS DATE) = cal.dia
GROUP BY cal.dia
ORDER BY cal.dia
OPTION (MAXRECURSION 366);       -- permite generar hasta 366 filas
GO


/* ----------------------------------------------------------------------------
   CONSULTA 17  (EXPERTA) — Trazabilidad completa (hacia atras y hacia adelante)
   Objetivo: para cada lote, reconstruir toda la cadena: proveedor -> fundo ->
   materia prima -> orden -> lote -> despacho -> cliente.
   Conceptos: multiples LEFT JOIN, DISTINCT para evitar duplicados del puente M:N.
   ---------------------------------------------------------------------------- */
SELECT DISTINCT
    pr.razon_social      AS proveedor,
    f.codigo_campo,
    f.variedad,
    mp.nombre            AS materia_prima,
    op.id                AS id_orden,
    l.numero_lote,
    pf.nombre            AS producto_final,
    d.numero_despacho,
    cl.razon_social      AS cliente,
    cl.pais              AS pais_destino
FROM dbo.lotes_producto_final AS l
INNER JOIN dbo.productos_finales       AS pf ON pf.id = l.id_producto_final
LEFT  JOIN dbo.ordenes_produccion      AS op ON op.id = l.id_orden_produccion
LEFT  JOIN dbo.orden_produccion_materia AS opm ON opm.id_orden_produccion = op.id
LEFT  JOIN dbo.materias_primas         AS mp ON mp.id = opm.id_materia
LEFT  JOIN dbo.fundos                  AS f  ON f.id  = mp.id_fundo
LEFT  JOIN dbo.proveedores             AS pr ON pr.id = f.id_proveedor
LEFT  JOIN dbo.despachos               AS d  ON d.id_lote_producto_final = l.id
LEFT  JOIN dbo.clientes                AS cl ON cl.id = d.id_cliente
ORDER BY l.numero_lote;
GO


/* ----------------------------------------------------------------------------
   CONSULTA 18  (EXPERTA) — LAG() : comparar una fila con la anterior
   Objetivo: en cada lote, detectar la variacion de temperatura entre una
   lectura de cadena de frio y la lectura inmediatamente anterior.
   Conceptos: funcion de ventana LAG() con PARTITION BY y resta entre filas.
   ---------------------------------------------------------------------------- */
WITH variaciones AS (
    SELECT
        cf.id_lote_producto_final,
        cf.fecha_hora,
        cf.temperatura,
        LAG(cf.temperatura) OVER (
            PARTITION BY cf.id_lote_producto_final
            ORDER BY cf.fecha_hora
        ) AS temperatura_anterior
    FROM dbo.cadena_frio AS cf
)
SELECT
    l.numero_lote,
    v.fecha_hora,
    v.temperatura_anterior,
    v.temperatura,
    CAST(v.temperatura - v.temperatura_anterior AS DECIMAL(5,2)) AS variacion
FROM variaciones AS v
INNER JOIN dbo.lotes_producto_final AS l
        ON l.id = v.id_lote_producto_final
WHERE v.temperatura_anterior IS NOT NULL   -- la primera lectura no tiene anterior
ORDER BY l.numero_lote, v.fecha_hora;
GO


/* ----------------------------------------------------------------------------
   CONSULTA 19  (EXPERTA) — CROSS APPLY : el "Top N por grupo"
   Objetivo: por cada lote, traer su ULTIMA inspeccion de control de calidad.
   Conceptos: CROSS APPLY con una subconsulta TOP(1) correlacionada.
   ---------------------------------------------------------------------------- */
SELECT
    l.numero_lote,
    ultima.etapa,
    ultima.resultado,
    ultima.parametro,
    ultima.valor_medido,
    ultima.fecha_inspeccion
FROM dbo.lotes_producto_final AS l
CROSS APPLY (
    SELECT TOP (1)
        cc.etapa,
        cc.resultado,
        cc.parametro,
        cc.valor_medido,
        cc.fecha_inspeccion
    FROM dbo.control_calidad AS cc
    WHERE cc.id_lote_producto_final = l.id
    ORDER BY cc.fecha_inspeccion DESC
) AS ultima
ORDER BY l.numero_lote;
GO


/* ----------------------------------------------------------------------------
   CONSULTA 20  (EXPERTA) — Analisis integral: rendimiento y merma por orden
   Objetivo: por cada orden de produccion calcular materia consumida, producto
   final obtenido, merma total y los % de rendimiento y merma; ademas clasificar
   las ordenes en 4 grupos (cuartiles) segun su rendimiento.
   Conceptos: multiples CTE, LEFT JOIN de subconsultas agregadas, NULLIF para
   evitar division por cero, y la funcion de ventana NTILE().
   ---------------------------------------------------------------------------- */
WITH consumo AS (        -- materia prima consumida por orden
    SELECT id_orden_produccion, SUM(cantidad_consumida) AS total_consumido
    FROM dbo.orden_produccion_materia
    GROUP BY id_orden_produccion
),
merma AS (               -- merma total por orden
    SELECT id_orden_produccion, SUM(cantidad) AS total_merma
    FROM dbo.mermas
    GROUP BY id_orden_produccion
),
calculo AS (             -- une todo y calcula los indicadores
    SELECT
        op.id                              AS id_orden,
        op.estado,
        ISNULL(c.total_consumido, 0)       AS mp_consumida,
        ISNULL(op.cantidad_producida, 0)   AS producto_final,
        ISNULL(m.total_merma, 0)           AS merma_total,
        CAST(ISNULL(op.cantidad_producida,0) * 100.0
             / NULLIF(c.total_consumido,0) AS DECIMAL(6,2)) AS rendimiento_pct,
        CAST(ISNULL(m.total_merma,0) * 100.0
             / NULLIF(c.total_consumido,0) AS DECIMAL(6,2)) AS merma_pct
    FROM dbo.ordenes_produccion AS op
    LEFT JOIN consumo AS c ON c.id_orden_produccion = op.id
    LEFT JOIN merma   AS m ON m.id_orden_produccion = op.id
)
SELECT
    id_orden,
    estado,
    mp_consumida,
    producto_final,
    merma_total,
    rendimiento_pct,
    merma_pct,
    NTILE(4) OVER (ORDER BY rendimiento_pct DESC) AS cuartil_rendimiento
FROM calculo
ORDER BY rendimiento_pct DESC;
GO



