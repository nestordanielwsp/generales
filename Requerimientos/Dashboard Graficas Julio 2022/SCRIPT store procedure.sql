use rapensambleemm 
GO
IF OBJECT_ID('spq_ObtieneTiemposMuertos_porLinea', 'P') IS NOT NULL
DROP PROC spq_ObtieneTiemposMuertos_porLinea
GO
-- Created on: july 13 2022
-- Filtros por : Dia, semana, Mes, Año  , turno, equipo , linea 
CREATE PROCEDURE spq_ObtieneTiemposMuertos_porLinea
  @pdFechaInicio DATETIME = NULL 
, @pdFechaFinal DATETIME  = NULL 
, @pnLineaId INT		  = 0
, @pnDia INT			  = 0
, @pnSemana INT			  = 0
, @pnMes INT			  = 0
, @pnAnio INT			  = 0
, @pnTurno INT			  = 0
, @pnEquipoId INT		  = 0
AS
BEGIN

IF @pdFechaInicio IS NULL BEGIN
	SET @pdFechaInicio = CAST(GETDATE() AS DATE) 
END
IF @pdFechaFinal IS NULL BEGIN
	SET @pdFechaFinal = CAST(DATEADD(day,1,GETDATE()) AS DATE)
END
ELSE BEGIN
	SET @pdFechaFinal = CAST(DATEADD(day,1,@pdFechaFinal) AS DATE)
END

DECLARE @_DATA TABLE (LineaId INT
				, Linea VARCHAR(200)
				, Departamento VARCHAR(200)
				, Turno INT
				, Tiempo INT
				, NoParte VARCHAR(200)
				, FechaInicioParo datetime
				, FechaFinParo datetime
				, Filtro_FechaInicio datetime
				, Filtro_FechaFinal datetime)

INSERT INTO @_DATA
select
	DW.Prensa as LineaId 
	,L1.Descripcion as Linea 
	,L1.Departamentos as Departamento
	,DW.Turno
	,DW.Tiempo
	,DW.NoParte
	,DW.InicioParo
	,DW.FinParo
	,@pdFechaInicio
	,@pdFechaFinal
from [dbo].[PRENSAS_DownTime] DW (NOLOCK) 
inner join [dbo].[PRENSAS_Cat_NombresLinea] D2 (NOLOCK)  on D2.IdPrensa = DW.Prensa
inner join  Linea L1 (nolock) on L1.Linea =  DW.Prensa
where  
DW.InicioParo between @pdFechaInicio AND @pdFechaFinal
and
D2.Trabajando = '1'
and
(@pnTurno = 0 OR DW.Turno = @pnTurno)
and
(@pnLineaId = 0 OR DW.Prensa = @pnLineaId)


-- requerimiento usuario
DECLARE @_TIME_DISPONIBLE_POR_LINEA float = (SELECT Valor FROM dbo.PRENSAS_Parametros (NOLOCK) WHERE Clave = 'TIME_DISPONIBLE' AND Tipo = 'LINEAS')
DECLARE @_FINAL TABLE (LineaId INT, Linea varchaR(259), Porcentaje float)

INSERT INTO @_FINAL
select 
	LineaId, Linea, SUM(Tiempo) MinutosParo
from @_DATA DW 
group by LineaId, Linea
order by SUM(Tiempo)  desc

select 
	LineaId, Linea, CAST(((Porcentaje/@_TIME_DISPONIBLE_POR_LINEA) * 100) AS DECIMAL(18,2)) PorcentajeParo
from @_FINAL DW  
order by (Porcentaje/@_TIME_DISPONIBLE_POR_LINEA)  desc
   
select @pdFechaInicio, @pdFechaFinal,@_TIME_DISPONIBLE_POR_LINEA 
END
GO
IF OBJECT_ID('spq_ObtieneTiemposMuertos_porLineaPlanDeAccion', 'P') IS NOT NULL
DROP PROC spq_ObtieneTiemposMuertos_porLineaPlanDeAccion
GO
-- Created on: july 13 2022 
CREATE PROCEDURE spq_ObtieneTiemposMuertos_porLineaPlanDeAccion 
 @psTipo VARCHAR(20) = 'LINEA'
, @psUsuarioRegistra VARCHAR(259) = 'admin'
AS
BEGIN

DECLARE @_PLAN TABLE(CompouseRow varchar(529), Id int)

INSERT INTO @_PLAN SELECT '<table><thead class="thead-dark"><tr><td width="20%" scope="col">Fecha</th><td width="50%" scope="col">Plan de acción</th><td width="20%" scope="col">Registró</th><td width="10%" scope="col"></th></tr></thead>' 
	,1

INSERT INTO @_PLAN SELECT '<tboody>'
	,1
INSERT INTO @_PLAN
select
	  '<tr><td width="20%" scope="row">'+CONVERT(VARCHAR,FechaRegistro,103)+'</th>'  
	+ '<td width="50%">'+Descripcion+'</th>'  
	+ '<td width="20%">'+UsuarioRegistra+'</th>'
	+  (case when @psUsuarioRegistra = UsuarioRegistra then
	 '<td width="10%"><button type="button" class="btn btn-danger" onclick="modalEliminarPlanDeAccion('+CAST(PlanDeAccionId as varchar(20))+')">Eliminar</button></th></tr>' 
	 else  
	 '<td width="10%"></th></tr>'
	 end)
	,1 
from dbo.PRENSAS_PlanDeAccion (nolock)
where Tipo = @psTipo
and Activo = 1
order by FechaRegistro desc

INSERT INTO @_PLAN SELECT '</tbody></table>'
	,1
	 
SELECT DISTINCT 
    SUBSTRING(
        (
            SELECT  ST1.CompouseRow  AS [text()]
            FROM @_PLAN ST1
            WHERE ST1.Id = ST2.Id
            ORDER BY ST1.Id
            FOR XML PATH (''), TYPE
        ).value('text()[1]','nvarchar(max)'), 1, 1000) [Resultados]
FROM @_PLAN ST2

END
GO
IF OBJECT_ID('spq_ObtieneLineas_Trabajando', 'P') IS NOT NULL
DROP PROC spq_ObtieneLineas_Trabajando
GO
-- Created on: july 13 2022 
CREATE PROCEDURE spq_ObtieneLineas_Trabajando
@psTrabajando char(1) = '1'
AS
BEGIN
select
	D2.IdPrensa as LineaId 
	,L1.Descripcion as Linea 
	,L1.Departamentos as Departamento 
from  Linea L1 (nolock) 
inner join [dbo].[PRENSAS_Cat_NombresLinea] D2 (NOLOCK)  on D2.IdPrensa = L1.Linea 
where   
D2.Trabajando = @psTrabajando
order by L1.Descripcion
END
GO
IF OBJECT_ID('spq_ObtieneEquiposPorLineas', 'P') IS NOT NULL
DROP PROC spq_ObtieneEquiposPorLineas
GO
-- Created on: july 13 2022 
CREATE PROCEDURE spq_ObtieneEquiposPorLineas
@psTrabajando char(1) = '1'
,@pnLineaId int = 0
AS
BEGIN
select
	D2.IdPrensa as LineaId 
	,L1.Descripcion as Linea 
	,L1.Departamentos as Departamento 
	,E1.Equipo
	,E1.IdEquipo
from  [dbo].Linea_Equipo E1 (nolock)
inner join Linea L1 (nolock) on L1.Linea = E1.IdLinea
inner join [dbo].[PRENSAS_Cat_NombresLinea] D2 (NOLOCK)  on D2.IdPrensa = L1.Linea 
where   
D2.Trabajando = @psTrabajando
and
(@pnLineaId = 0 or L1.Linea = @pnLineaId)
order by E1.Equipo
END
GO 
IF OBJECT_ID('spa_RegistraPlanDeAccion', 'P') IS NOT NULL
DROP PROC spa_RegistraPlanDeAccion
GO
-- Created on: july 13 2022 
CREATE PROCEDURE spa_RegistraPlanDeAccion
@psTipo VARCHAR(20) = 'LINEA'
,@psDescripcion VARCHAR(529) = ''
,@psUsuarioRegistra VARCHAR(259) = 'admin'
AS
BEGIN
	DECLARE @_Id INT = 0
	SELECT @_Id = ISNULL(MAX(PlandeAccionId),0) + 1 FROM dbo.PRENSAS_PlanDeAccion (NOLOCK)

	INSERT INTO dbo.PRENSAS_PlanDeAccion
		   (PlanDeAccionId, Tipo ,Descripcion ,FechaRegistro ,UsuarioRegistra , Activo, FechaBaja, UsuarioBaja)
	SELECT @_Id
			,@psTipo
			,@psDescripcion
			,GETDATE()
			,@psUsuarioRegistra
			,1
			,NULL
			,NULL

END
GO 
IF OBJECT_ID('spb_EliminaPlanDeAccion', 'P') IS NOT NULL
DROP PROC spb_EliminaPlanDeAccion
GO
-- Created on: july 13 2022 
CREATE PROCEDURE spb_EliminaPlanDeAccion
 @pnPlanDeAccionId INT 
,@psUsuarioBaja VARCHAR(259)  = 'admin'
AS
BEGIN 

	UPDATE dbo.PRENSAS_PlanDeAccion
		SET Activo = 0
			, FechaBaja = GETDATE()
			, UsuarioBaja = @psUsuarioBaja
		WHERE PlanDeAccionId = @pnPlanDeAccionId

END
GO
IF OBJECT_ID('spq_ObtieneGrafica_MTBF', 'P') IS NOT NULL
DROP PROC spq_ObtieneGrafica_MTBF
GO
-- Created on: july 13 2022
-- Filtros por : linea 
-- FORMULA: (Tiempo_Disponible_Por_Linea/Número_Paros)/60
CREATE PROCEDURE spq_ObtieneGrafica_MTBF
  @pdFechaInicio DATETIME = NULL 
, @pdFechaFinal DATETIME  = NULL 
, @pnLineaId INT		  = 0 
AS
BEGIN

IF @pdFechaInicio IS NULL BEGIN
	SET @pdFechaInicio = CAST(GETDATE() AS DATE) 
END
IF @pdFechaFinal IS NULL BEGIN
	SET @pdFechaFinal = CAST(DATEADD(day,1,GETDATE()) AS DATE)
END
ELSE BEGIN
	SET @pdFechaFinal = CAST(DATEADD(day,1,@pdFechaFinal) AS DATE)
END

DECLARE @_DATA TABLE (LineaId INT
				, Linea VARCHAR(200)
				, Departamento VARCHAR(200)
				, Turno INT
				, Tiempo INT
				, NoParte VARCHAR(200)
				, FechaInicioParo datetime
				, FechaFinParo datetime
				, Filtro_FechaInicio datetime
				, Filtro_FechaFinal datetime)

INSERT INTO @_DATA
select
	DW.Prensa as LineaId 
	,L1.Descripcion as Linea 
	,L1.Departamentos as Departamento
	,DW.Turno
	,DW.Tiempo
	,DW.NoParte
	,DW.InicioParo
	,DW.FinParo
	,@pdFechaInicio
	,@pdFechaFinal
from [dbo].[PRENSAS_DownTime] DW (NOLOCK) 
inner join [dbo].[PRENSAS_Cat_NombresLinea] D2 (NOLOCK)  on D2.IdPrensa = DW.Prensa
inner join  Linea L1 (nolock) on L1.Linea =  DW.Prensa
where  
DW.InicioParo between @pdFechaInicio AND @pdFechaFinal
and
D2.Trabajando = '1' 
and
(@pnLineaId = 0 OR DW.Prensa = @pnLineaId)
 
-- requerimiento usuario
DECLARE @_TIME_DISPONIBLE_POR_LINEA float = (SELECT Valor FROM dbo.PRENSAS_Parametros (NOLOCK) WHERE Clave = 'TIME_DISPONIBLE' AND Tipo = 'LINEAS')
DECLARE @_META float = (SELECT Valor FROM dbo.PRENSAS_Parametros (NOLOCK) WHERE Clave = 'META' AND Tipo = 'MTBF')
DECLARE @_FINAL TABLE (LineaId INT, Linea varchaR(259), Paros float)

INSERT INTO @_FINAL
select 
	LineaId, Linea, COUNT(1) Paros
from @_DATA DW 
group by LineaId, Linea
order by SUM(Tiempo)  desc

select 
	LineaId, Linea, CAST(((@_TIME_DISPONIBLE_POR_LINEA/Paros)/60)  AS DECIMAL(18,2)) as Horas, @_META As Meta
from @_FINAL DW  
order by Horas desc
   
select @pdFechaInicio, @pdFechaFinal, @_TIME_DISPONIBLE_POR_LINEA

END
GO
IF OBJECT_ID('spq_ObtieneGrafica_MTTR', 'P') IS NOT NULL
DROP PROC spq_ObtieneGrafica_MTTR
GO
-- Created on: july 13 2022
-- Filtros por :  linea 
CREATE PROCEDURE spq_ObtieneGrafica_MTTR
  @pdFechaInicio DATETIME = NULL 
, @pdFechaFinal DATETIME  = NULL 
, @pnLineaId INT		  = 0 
AS
BEGIN

IF @pdFechaInicio IS NULL BEGIN
	SET @pdFechaInicio = CAST(GETDATE() AS DATE) 
END
IF @pdFechaFinal IS NULL BEGIN
	SET @pdFechaFinal = CAST(DATEADD(day,1,GETDATE()) AS DATE)
END
ELSE BEGIN
	SET @pdFechaFinal = CAST(DATEADD(day,1,@pdFechaFinal) AS DATE)
END

DECLARE @_DATA TABLE (LineaId INT
				, Linea VARCHAR(200)
				, Departamento VARCHAR(200)
				, Turno INT
				, Tiempo INT
				, NoParte VARCHAR(200)
				, FechaInicioParo datetime
				, FechaFinParo datetime
				, Filtro_FechaInicio datetime
				, Filtro_FechaFinal datetime)

INSERT INTO @_DATA
select
	DW.Prensa as LineaId 
	,L1.Descripcion as Linea 
	,L1.Departamentos as Departamento
	,DW.Turno
	,DW.Tiempo
	,DW.NoParte
	,DW.InicioParo
	,DW.FinParo
	,@pdFechaInicio
	,@pdFechaFinal
from [dbo].[PRENSAS_DownTime] DW (NOLOCK) 
inner join [dbo].[PRENSAS_Cat_NombresLinea] D2 (NOLOCK)  on D2.IdPrensa = DW.Prensa
inner join  Linea L1 (nolock) on L1.Linea =  DW.Prensa
where  
DW.InicioParo between @pdFechaInicio AND @pdFechaFinal
and
D2.Trabajando = '1' 
and
(@pnLineaId = 0 OR DW.Prensa = @pnLineaId)
 
-- requerimiento usuario
DECLARE @_TIME_DISPONIBLE_POR_LINEA float = (SELECT Valor FROM dbo.PRENSAS_Parametros (NOLOCK) WHERE Clave = 'TIME_DISPONIBLE' AND Tipo = 'LINEAS')
DECLARE @_META float = (SELECT Valor FROM dbo.PRENSAS_Parametros (NOLOCK) WHERE Clave = 'META' AND Tipo = 'MTTR')
DECLARE @_FINAL TABLE (LineaId INT, Linea varchaR(259), MinutosParo float, Paros float)

INSERT INTO @_FINAL
select 
	LineaId, Linea, SUM(Tiempo), COUNT(1) Paros
from @_DATA DW 
group by LineaId, Linea
order by SUM(Tiempo)  desc

select 
	LineaId, Linea, MinutosParo, Paros, CAST((MinutosParo/Paros)  AS DECIMAL(18,1)) As Indicador, @_META As Meta
from @_FINAL DW  
order by (MinutosParo/Paros) desc
   
select @pdFechaInicio, @pdFechaFinal, @_TIME_DISPONIBLE_POR_LINEA 

END
GO
IF OBJECT_ID('spq_ObtieneGrafica_TopFallaPorLinea', 'P') IS NOT NULL
DROP PROC spq_ObtieneGrafica_TopFallaPorLinea
GO
-- Created on: july 13 2022
-- Filtros por :  linea 
-- spq_ObtieneGrafica_TopFallaPorLinea null,null,53
CREATE PROCEDURE spq_ObtieneGrafica_TopFallaPorLinea
  @pdFechaInicio DATETIME = NULL 
, @pdFechaFinal DATETIME  = NULL 
, @pnLineaId INT		  = 0 
AS
BEGIN

IF @pdFechaInicio IS NULL BEGIN
	SET @pdFechaInicio = CAST(GETDATE() AS DATE) 
END
IF @pdFechaFinal IS NULL BEGIN
	SET @pdFechaFinal = CAST(DATEADD(day,1,GETDATE()) AS DATE)
END
ELSE BEGIN
	SET @pdFechaFinal = CAST(DATEADD(day,1,@pdFechaFinal) AS DATE)
END

DECLARE @_DATA TABLE (LineaId INT
				, Linea VARCHAR(200)
				, Departamento VARCHAR(200)
				, Turno INT
				, Tiempo INT
				, NoParte VARCHAR(200)
				, FechaInicioParo datetime
				, FechaFinParo datetime
				, Filtro_FechaInicio datetime
				, Filtro_FechaFinal datetime )

INSERT INTO @_DATA
select
	 M1.IdMotivo --DW.Prensa as LineaId 
	,M1.Descripcion --,L1.Descripcion as Linea 
	,L1.Departamentos as Departamento
	,DW.Turno
	,DW.Tiempo
	,DW.NoParte
	,DW.InicioParo
	,DW.FinParo
	,@pdFechaInicio
	,@pdFechaFinal 
from [dbo].[PRENSAS_DownTime] DW (NOLOCK) 
inner join [dbo].[PRENSAS_Cat_NombresLinea] D2 (NOLOCK)  on D2.IdPrensa = DW.Prensa
inner join [dbo].[PRENSAS_Cat_MotivosParo] M1 (NOLOCK) on M1.IdLinea = DW.Prensa and M1.IdDepto = DW.IdDepto and DW.Valor = M1.Valor
inner join  Linea L1 (nolock) on L1.Linea =  DW.Prensa
where  
DW.InicioParo between @pdFechaInicio AND @pdFechaFinal
and
D2.Trabajando = '1' 
and
(@pnLineaId = 0 OR DW.Prensa = @pnLineaId)
order by DW.Tiempo DESC

select TOP 10
	LineaId, Linea, SUM(Tiempo) MinutosParo
from @_DATA DW 
group by LineaId, Linea 
order by SUM(Tiempo) desc

select @pdFechaInicio, @pdFechaFinal

END
GO
IF OBJECT_ID('spq_ObtieneGrafica_TopFalla', 'P') IS NOT NULL
DROP PROC spq_ObtieneGrafica_TopFalla
GO
-- Created on: july 13 2022
-- Filtros por :  linea 
CREATE PROCEDURE spq_ObtieneGrafica_TopFalla
  @pdFechaInicio DATETIME = NULL 
, @pdFechaFinal DATETIME  = NULL 
, @pnLineaId INT		  = 0 
AS
BEGIN

IF @pdFechaInicio IS NULL BEGIN
	SET @pdFechaInicio = CAST(GETDATE() AS DATE) 
END
IF @pdFechaFinal IS NULL BEGIN
	SET @pdFechaFinal = CAST(DATEADD(day,1,GETDATE()) AS DATE)
END
ELSE BEGIN
	SET @pdFechaFinal = CAST(DATEADD(day,1,@pdFechaFinal) AS DATE)
END

DECLARE @_DATA TABLE (LineaId INT
				, Linea VARCHAR(200)
				, Departamento VARCHAR(200)
				, Turno INT
				, Tiempo INT
				, NoParte VARCHAR(200)
				, FechaInicioParo datetime
				, FechaFinParo datetime
				, Filtro_FechaInicio datetime
				, Filtro_FechaFinal datetime)

INSERT INTO @_DATA
select
	 M1.IdMotivo --DW.Prensa as LineaId 
	,M1.Descripcion --,L1.Descripcion as Linea 
	,L1.Departamentos as Departamento
	,DW.Turno
	,DW.Tiempo
	,DW.NoParte
	,DW.InicioParo
	,DW.FinParo
	,@pdFechaInicio
	,@pdFechaFinal 
from [dbo].[PRENSAS_DownTime] DW (NOLOCK) 
inner join [dbo].[PRENSAS_Cat_NombresLinea] D2 (NOLOCK)  on D2.IdPrensa = DW.Prensa
inner join [dbo].[PRENSAS_Cat_MotivosParo] M1 (NOLOCK) on M1.IdLinea = DW.Prensa and M1.IdDepto = DW.IdDepto and DW.Valor = M1.Valor
inner join  Linea L1 (nolock) on L1.Linea =  DW.Prensa
where  
DW.InicioParo between @pdFechaInicio AND @pdFechaFinal
and
D2.Trabajando = '1' 
and
(@pnLineaId = 0 OR DW.Prensa = @pnLineaId)
order by DW.Tiempo DESC

select TOP 10
	LineaId, Linea, SUM(Tiempo) MinutosParo
from @_DATA DW 
group by LineaId, Linea 
order by SUM(Tiempo) desc

select @pdFechaInicio, @pdFechaFinal


END
GO