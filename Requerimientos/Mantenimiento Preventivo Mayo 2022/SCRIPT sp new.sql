 

-- =============================================  
-- Author:  Daniel Almaguer 
-- Create date: 30/05/2022  
-- Project: Mantenimiento Predictivo  
-- Description: Datos de Alertas y Detalle de Estas por Equipo   
-- =============================================  
  
-- exec [spq_ObtieneAlertasPorEquipo]  'red'
-- exec [spq_ObtieneAlertasPorEquipo]  'orange'
 --exec [spq_ObtieneAlertasPorEquipo]  'gray'
 --exec [spq_ObtieneAlertasPorEquipo]  'blue'
 --exec [spq_ObtieneAlertasPorEquipo]  'yellow'
 --exec [spq_ObtieneAlertasPorEquipo]  '','robot se encuentra'
  
ALTER PROCEDURE [dbo].[spq_ObtieneAlertasPorEquipo]  
@color varchar(259) = ''
,@searchText varchar(259) = ''
AS
BEGIN

	DECLARE @Data TABLE(Site varchar(259)
						,Line  varchar(259)
						, ProductionLine  varchar(259)
						, NombreEquipo  varchar(259)
						, description  varchar(259)
						, priority	   varchar(259)
						, prioritydesc varchar(259)
						, durationString  varchar(259)
						, Timestamp		 varchar(259)
						, color varchar(259))

 INSERT INTO @Data
 SELECT   isnull([Site], '') as Site  
    ,isnull([Line], '') as Line  
    ,isnull([Production Line],'') as ProductionLine    
    ,isnull([Nombre_Equipo],'') as NombreEquipo  
    ,ISNULL([description],'') as description 
	,isnull([priority],0) as priority
	,isnull([priority],'') as prioritydesc
	,isnull(durationString,'') as durationString
	,isnull([timestamp],'') as Timestamp
	,case 
		when priority = 1 or priority = 2 then 'red' 
		when priority = 3 or priority = 4 then 'orange' 
		when priority = 5 then 'yellow'
		when priority = 6 or priority = 7 or priority = 8 or priority = 9 then 'blue'
		when priority = 10 then 'gray' 
	 else ''
	 end color
  FROM [ConsumoEnergia].[dbo].[vw_AlertasActivas]   
  WHERE isnull(Site,'') <> ''  
  ORDER BY [Site]  
    ,[Line]  
    ,[Production Line]  
	,[timestamp]

 SELECT
	*
	FROM @Data
	WHERE 
	(@color = '' OR color = @color)
	AND
	(@searchText = '' OR
		UPPER(Site) like '%'+UPPER(@searchText)+'%'OR
		UPPER(Line) like '%'+UPPER(@searchText)+'%'OR
		UPPER(ProductionLine) like '%'+UPPER(@searchText)+'%'OR
		UPPER(NombreEquipo) like '%'+UPPER(@searchText)+'%'OR
		UPPER(description) like '%'+UPPER(@searchText)+'%')
		 
END
GO
 