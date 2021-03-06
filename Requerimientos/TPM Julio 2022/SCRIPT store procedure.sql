USE [TpmMtto]
GO
/*
ALTER TABLE [CheckListCapEnc] ADD EstatusId INT 
ALTER TABLE [CheckListCapEnc] ADD FechaIPreCaptura DATETIME 
ALTER TABLE [CheckListCapEnc] ADD FechaIniciaFlujo DATETIME 
ALTER TABLE [CheckListCapEnc] ADD FechaFinalFlujo DATETIME 
INSERT INTO CatEstatus SELECT 4, 'Pre Captura'
UPDATE [CheckListCapEnc] SET EstatusId = 2, FechaFinalFlujo = GETDATE()

select * from CatEstatus
update EquipoUltimaEjec set Estatus=0,UltimaEjec=null,FechaFlujo=null
select * from usuariostpm
ALTER TABLE [EquipoUltimaEjec] ADD FechaCalculoDe DATETIME 
ALTER TABLE [EquipoUltimaEjec] ADD FechaCalculoHasta DATETIME 
ALTER TABLE [EquipoUltimaEjec] ADD PiezasProducidas DECIMAL(15,3) 

UPDATE EquipoUltimaEjec SET FechaCalculoDe = DATEADD(YEAR,-1,GETDATE()), FechaCalculoHasta = GETDATE(), PiezasProducidas = 0

select top 10 * from [dbo].[CheckListCapEnc](nolock) where codequipo = 'T01061005/30'  order by IdChkEquipo desc
select * from EquipoUltimaEjec where CodEquipo = 'T01061005/30' 
UPDATE EquipoUltimaEjec SET FechaCalculoDe = DATEADD(YEAR,-1,GETDATE()), FechaCalculoHasta = GETDATE(), PiezasProducidas = 0 where CodEquipo = 'T01061005/30' 


Hola buen dia!!
  
Tines maneniminetos listos para aprobar
  
Saludos
*/
GO
-- EXEC  [envia_correo] 1, 0, '', ''
-- EXEC  [envia_correo] 0, 1, '', ''
ALTER PROCEDURE [envia_correo]
	@EsNotificacion	int, 
	@EsAprobado		int, 
	@CodEquipo      varchar(200) = '',
	@estatus NVARCHAR(MAX)
AS
BEGIN

		DECLARE @userID	INTEGER,
		@desc_actual	NVARCHAR(MAX),
		@planteamiento	NVARCHAR(MAX),
		@idArea	INTEGER,
		@idSupervisor INTEGER = NULL,
		@idMejora INTEGER = NULL,
		@idFinanzas INTEGER = NULL,
		@idEquipo INTEGER = NULL,
		@folio INTEGER = NULL
		  
		DECLARE @tbHtml  VARCHAR(MAX)
		DECLARE @Nombre NVARCHAR(MAX)
		DECLARE @Area NVARCHAR(MAX)
		DECLARE @Supervisor NVARCHAR(MAX)
		DECLARE @Equipo NVARCHAR(MAX)
		DECLARE @Mails NVARCHAR(MAX)
		DECLARE @Mail NVARCHAR(MAX)
		DECLARE @EmailSupervisor NVARCHAR(MAX)
		DECLARE @EmailMejora NVARCHAR(MAX)
		DECLARE @EmailFinanzas NVARCHAR(MAX) 
		DECLARE @titulo nvarchar(300)
		DECLARE @body nvarchar(300)
		 
		SELECT @Nombre = ''
		SELECT @Area = ''
		SELECT @Supervisor = ''	
		SELECT @EmailMejora  = ''
		SELECT @EmailFinanzas = ''
		SELECT @Equipo = ''
		
		SELECT @Mails = '' 
		
		set @titulo = CASE WHEN @EsNotificacion = 1 THEN 'Tienes mantenimientos listos para aprobar' WHEN @EsAprobado = 1 THEN 'Notificación de aprobación' ELSE 'Notificación de rechazo' END
		set @body = CASE WHEN @EsNotificacion = 1 THEN 'Tienes mantenimientos listos para aprobar.' WHEN @EsAprobado = 1 THEN 'Notificación de aprobación' ELSE 'Notificación de rechazo' END

		SET @tbHtml = 
		'<style>th{background: #dc4d4d;color: white;padding: 5px 20px;}' +
		'td{background: whitesmoke;padding: 5px 10px;}h1{color: #dc4d4d}</style>' +
		'<h2>Hola buen día!!</h2>' +
		'<table style="max-width: 600px;">' + 
		'<tr><th>Fecha:</th><td>'+CONVERT(VARCHAR(11),GETDATE())+'</td></tr>' +
		'<tr><th>Descripción:</th><td colspan="3" style="text-transform: capitalize;">'+@body+'</td></tr></table>' +
		'<br /><br />'

		DECLARE @copy_mails VARCHAR(MAX)= ''   
		declare @email_recipients varchar(400)

		set @email_recipients = 'daniel.almaguer@wsp.com.mx;'	
		set @estatus = 'Dashboard TPM |' + @titulo + '| Check List' 
		
        EXEC msdb.dbo.sp_send_dbmail
					@profile_name = 'Email', 
					@recipients = @email_recipients,	 
					@copy_recipients = '', 
					@body = @tbHtml,
					@body_format = 'HTML',
					@subject = @estatus 

END
GO
ALTER PROCEDURE [dbo].[sp_UpdMonitorTPM_JE]     
  @pnIdChkEquipo INT 
  ,@psUser varchar(20)
  ,@psNombreUser varchar(200)      
AS    
BEGIN    
     declare @psCodEquipo varchar(200), @psCodDepartamento  varchar(200), @psCodWorkCenter  varchar(200)

	SELECT @psCodEquipo = CodEquipo
		, @psCodDepartamento = CodDepartamento
		, @psCodWorkCenter = CodWorkCenter
	FROM [dbo].[CheckListCapEnc]    (NOLOCK)
	Where IdChkEquipo = @pnIdChkEquipo 

	 UPDATE EquipoUltimaEjec  
	 SET Estatus = 1  
		, FechaFlujo = GETDATE()
	  WHERE CodEquipo = @psCodEquipo   
	 AND CodDepartamento = @psCodDepartamento
	 AND WorkCenter = @psCodWorkCenter
  
  	-- ACTUALIZA EL CHECK LIST CAPTURADO
	UPDATE [dbo].[CheckListCapEnc]  
        SET  UserModif   = @psNombreUser    
			,FchModif     = GETDATE()
			,EstatusId		 = 1	 
	Where IdChkEquipo = @pnIdChkEquipo  

	 -- ENVIAR NOTIFICACION SOLICITANDO APROBACION O RECHAZO DE CAPTURA DE CHECKLIST
	 --EXEC  dbo.[envia_correo] 1, 0, @psCodEquipo, ''

END  
GO 
-- sp_SelMonitorTPM 3    
-- [sp_SelMonitorTPM_JE] 0   , 'MATR', 'LA'  
-- [sp_SelMonitorTPM_JE]  99999, 'MATR', 'LA'  
-- [sp_SelMonitorTPM_JE]  1, 'MATR', ''  
-- [sp_SelMonitorTPM_JE]  2, 'MATR', ''  
-- [sp_SelMonitorTPM_JE]  3, 'MATR', ''   
ALTER PROCEDURE [dbo].[sp_SelMonitorTPM_JE]     
 @pnIdEquipo int = 0,    
 @psDepto varchar(100) = 'MATR',    
 @psLinea varchar(100) = '',  
 @psColor varchar(100) = ''
 --,  
 --@pnEstatus int = 0    
AS    
BEGIN    
 SET NOCOUNT ON    
 --DECLARE @TRANS_ERRORS int    
    
 --SET @TRANS_ERRORS = 0    
 --BEGIN TRANSACTION T_iu_MonitorTPM    
     
     
 BEGIN     
    
      
  declare @Tmp1 TABLE(    
   MDV01 varchar(50),    
   WEMNG decimal(15,3),    
   SPTAG datetime,     
   CodEquipo varchar(18),    
   UltimaEjec date,    
   DescripTechnical varchar(40),    
   CodDepartamento varchar(10),  
   EstatusId int,    
   FechaFlujo datetime  
  )    
    
  INSERT INTO @Tmp1    
  select DISTINCT b.MDV01, SUM(b.WEMNG) as WEMNG, b.SPTAG, EquipoUltimaEjec.CodEquipo, EquipoUltimaEjec.UltimaEjec, EquipoUltimaEjec.DescripTechnical, EquipoUltimaEjec.CodDepartamento    
 , ISNULL(EquipoUltimaEjec.Estatus,0), EquipoUltimaEjec.FechaFlujo   
  FROM [ProdHist].[dbo].[HtProdxDia] b     (NOLOCK)
  inner join EquipoUltimaEjec     (NOLOCK) on EquipoUltimaEjec.WorkCenter = b.MDV01      
	  where (@psDepto = '' OR UPPER(rtrim(ltrim(EquipoUltimaEjec.CodDepartamento))) = UPPER(rtrim(ltrim(@psDepto))))    
	  and (@psLinea = '' OR UPPER(rtrim(ltrim(EquipoUltimaEjec.WorkCenter))) = UPPER(rtrim(ltrim(@psLinea))))    
	  AND b.FEC_UPDATE BETWEEN EquipoUltimaEjec.FechaCalculoDe AND GETDATE()
	  group by b.MDV01, b.SPTAG, EquipoUltimaEjec.CodEquipo, EquipoUltimaEjec.UltimaEjec, EquipoUltimaEjec.DescripTechnical, EquipoUltimaEjec.CodDepartamento, EquipoUltimaEjec.Estatus , EquipoUltimaEjec.FechaFlujo   
	  HAVING  SUM(b.WEMNG) > 0    
	  order by b.SPTAG desc    
    
  --select * from @Tmp1    
    
  delete from @Tmp1    
  where SPTAG < UltimaEjec     
  and UltimaEjec is null    
    
   IF @pnIdEquipo = 0    
   BEGIN    
    
    SELECT distinct  f.WorkCenter, f.DescripTechnical, f.CodEquipo
	  , CONVERT(VARCHAR, CONVERT(VARCHAR, CAST(p.Frecuencia  AS MONEY), 1)) as Frecuencia
	  , CONVERT(VARCHAR, CONVERT(VARCHAR, CAST(f.PzsProduc  AS MONEY), 1)) as PzsProduc    
      , CONVERT(VARCHAR, CONVERT(VARCHAR, CAST(((f.PzsProduc/p.Frecuencia)*100)  AS MONEY), 1)) as Porcentaje    
      , case when f.UltimaEjec is not null then format(f.UltimaEjec, 'dd-MM-yyyy') else '' end as UltimaEjec    
      , f.CodDepartamento    
   ,  
        isnull(CASE  WHEN f.PzsProduc >= p.Frecuencia THEN 1 END ,0) as 'Critico',            
        isnull(CASE WHEN  Convert(numeric(10,2),(convert(numeric(18,2),f.PzsProduc)/convert(numeric(18,2),p.Frecuencia)))*100 BETWEEN 91  AND 100 THEN 1 END ,0) as 'Medio',           
        isnull(CASE WHEN  Convert(numeric(10,2),(convert(numeric(18,2),f.PzsProduc)/convert(numeric(18,2),p.Frecuencia)))*100 < 90 THEN 1 END ,0) as 'Warning'    
 ,   
   CASE  WHEN f.PzsProduc >= p.Frecuencia THEN 'summary_color_RED' ELSE   
    CASE WHEN  Convert(numeric(10,2),(convert(numeric(18,2),f.PzsProduc)/convert(numeric(18,2),p.Frecuencia)))*100 BETWEEN 91  AND 100 THEN 'summary_color_YELLOW' ELSE  
    CASE WHEN  Convert(numeric(10,2),(convert(numeric(18,2),f.PzsProduc)/convert(numeric(18,2),p.Frecuencia)))*100 < 90 THEN 'summary_color_GREEN' ELSE '' END  
    END   
    END  summary_color  
 , f.Estatus  
 , f.EstatusId  
 , f.FechaFlujo  
    FROM [CatPlanesMantto] p    (NOLOCK)
    inner join (    
        select Distinct CodEquipo, MDV01 as WorkCenter, DescripTechnical, UltimaEjec, sum(WEMNG) as PzsProduc, CodDepartamento , e.Descripcion AS Estatus, t.EstatusId, t.FechaFlujo           
        from @Tmp1   t  
		inner join CatEstatus e (nolock) on e.EstatusId = t.EstatusId  
        group by CodEquipo, MDV01, DescripTechnical, UltimaEjec, CodDepartamento, e.Descripcion, t.EstatusId, t.FechaFlujo  
       ) f     
    on upper(ltrim(rtrim(f.CodEquipo))) = upper(ltrim(rtrim(p.CodEquipo)))    
 WHERE   
 (@psColor = '' OR CASE  WHEN f.PzsProduc >= p.Frecuencia THEN 'ROJO' ELSE   
    CASE WHEN  Convert(numeric(10,2),(convert(numeric(18,2),f.PzsProduc)/convert(numeric(18,2),p.Frecuencia)))*100 BETWEEN 91  AND 100 THEN 'AMARILLO' ELSE  
    CASE WHEN  Convert(numeric(10,2),(convert(numeric(18,2),f.PzsProduc)/convert(numeric(18,2),p.Frecuencia)))*100 < 90 THEN 'VERDE' ELSE '' END  
    END   
    END = @psColor)  
    ORDER BY f.WorkCenter, f.DescripTechnical, f.CodEquipo    
    
    END    
   ELSE IF @pnIdEquipo = 2    
   BEGIN     
       
    DECLARE @TOTALES TABLE(    
     WorkCenter varchar(300),    
     Critico int Not null default(0),         
     Medio int Not null default(0),         
     Warning int Not null default(0)    
    )    
     
    DECLARE @TOTALES8 TABLE(    
     WorkCenter varchar(300),    
     CodEquipo varchar(18),    
     PzsProduc decimal(15,3),         
     Frecuencia int  default(0)    
    )    
    
    Insert into @TOTALES8    
    SELECT     
       distinct f.WorkCenter, f.CodEquipo,  f.PzsProduc, p.Frecuencia     
    FROM [CatPlanesMantto] p    
    inner join (    
        select Distinct CodEquipo, MDV01 as WorkCenter, DescripTechnical, UltimaEjec, sum(WEMNG) as PzsProduc            
        from @Tmp1    
        group by CodEquipo, MDV01, DescripTechnical, UltimaEjec    
       ) f         
    on f.CodEquipo = p.CodEquipo      
        
    INSERT INTO @TOTALES    
    SELECT WorkCenter,    
        isnull(CASE  WHEN PzsProduc >= Frecuencia THEN COUNT(PzsProduc) END ,0) as 'Critico',            
        isnull(CASE WHEN  Convert(numeric(10,2),(convert(numeric(18,2),PzsProduc)/convert(numeric(18,2),Frecuencia)))*100 BETWEEN 91  AND 100 THEN COUNT(PzsProduc) END ,0) as 'Medio',           
        isnull(CASE WHEN  Convert(numeric(10,2),(convert(numeric(18,2),PzsProduc)/convert(numeric(18,2),Frecuencia)))*100 < 90 THEN COUNT(PzsProduc) END ,0) as 'Warning'       
    FROM @TOTALES8    
    group by PzsProduc, Frecuencia, WorkCenter    
    
    select WorkCenter, isnull(sum(Critico),0) as Critico, isnull(Sum(Medio),0) as Medio, isnull(Sum(Warning),0) as Warning     
    from @TOTALES    
    group by WorkCenter    
        
   END    
   ELSE IF @pnIdEquipo = 1    
   BEGIN     
    
    DECLARE @TOTALES2 TABLE(    
     Critico int Not null default(0),         
     Medio int Not null default(0),         
     Warning int Not null default(0)    
    )    
     
    DECLARE @TOTALES7 TABLE(    
     CodEquipo varchar(18),    
     PzsProduc decimal(15,3),         
     Frecuencia int  default(0)    
    )    
    
    Insert into @TOTALES7    
    SELECT     
       distinct f.CodEquipo,  f.PzsProduc, p.Frecuencia     
    FROM [CatPlanesMantto] p    
    inner join (    
        select Distinct CodEquipo, MDV01 as WorkCenter, DescripTechnical, UltimaEjec, sum(WEMNG) as PzsProduc            
        from @Tmp1    
        group by CodEquipo, MDV01, DescripTechnical, UltimaEjec    
       ) f         
    on f.CodEquipo = p.CodEquipo      
        
    INSERT INTO @TOTALES2    
    SELECT     
        isnull(CASE  WHEN PzsProduc >= Frecuencia THEN COUNT(PzsProduc) END ,0) as 'Critico',            
        isnull(CASE WHEN  Convert(numeric(10,2),(convert(numeric(18,2),PzsProduc)/convert(numeric(18,2),Frecuencia)))*100 BETWEEN 91  AND 100 THEN COUNT(PzsProduc) END ,0) as 'Medio',           
        isnull(CASE WHEN  Convert(numeric(10,2),(convert(numeric(18,2),PzsProduc)/convert(numeric(18,2),Frecuencia)))*100 < 90 THEN COUNT(PzsProduc) END ,0) as 'Warning'       
    FROM @TOTALES7    
    group by PzsProduc, Frecuencia    
     
    select isnull(sum(Critico),0) as Critico, isnull(Sum(Medio),0) as Medio, isnull(Sum(Warning),0) as Warning from @TOTALES2    
   END    
   ELSE IF @pnIdEquipo = 3    
   BEGIN     
    
    DECLARE @TOTALES9 TABLE(    
     WorkCenter varchar(300),    
     Critico int Not null default(0)    
    )    
     
    DECLARE @TOTALES10 TABLE(    
     WorkCenter varchar(300),    
     CodEquipo varchar(18),    
     PzsProduc decimal(15,3),         
     Frecuencia int  default(0)    
    )    
    
    Insert into @TOTALES10    
    SELECT     
       distinct f.WorkCenter, f.CodEquipo,  f.PzsProduc, p.Frecuencia     
    FROM [CatPlanesMantto] p    
    inner join (    
        select Distinct CodEquipo, MDV01 as WorkCenter, DescripTechnical, UltimaEjec, sum(WEMNG) as PzsProduc            
        from @Tmp1    
        group by CodEquipo, MDV01, DescripTechnical, UltimaEjec    
       ) f         
    on f.CodEquipo = p.CodEquipo      
        
    INSERT INTO @TOTALES9    
    SELECT WorkCenter,    
        isnull(CASE  WHEN PzsProduc >= Frecuencia THEN COUNT(PzsProduc) END ,0) as 'Critico'     
    FROM @TOTALES10    
    group by PzsProduc, Frecuencia, WorkCenter    
    
    select Top 10 WorkCenter, isnull(sum(Critico),0) as Critico    
    from @TOTALES9    
    group by WorkCenter    
    order by isnull(sum(Critico),0) desc    
   END    
   ELSE IF @pnIdEquipo = 99999    
   BEGIN     
    
    DECLARE @TOTALES4 TABLE(    
     Critico int Not null default(0),         
     Medio int Not null default(0),         
     Warning int Not null default(0)    
    )    
     
    DECLARE @TOTALES5 TABLE(    
     CodEquipo varchar(18),    
     PzsProduc decimal(15,3),         
     Frecuencia int  default(0)    
    )    
    
    Insert into @TOTALES5    
    SELECT     
       distinct f.CodEquipo,  f.PzsProduc, p.Frecuencia     
    FROM [CatPlanesMantto] p    
    inner join (    
        select Distinct CodEquipo, MDV01 as WorkCenter, DescripTechnical, UltimaEjec, sum(WEMNG) as PzsProduc, CodDepartamento            
        from @Tmp1    
        group by CodEquipo, MDV01, DescripTechnical, UltimaEjec, CodDepartamento    
       ) f         
    on f.CodEquipo = p.CodEquipo      
    where (@psDepto = '' OR UPPER(rtrim(ltrim(f.CodDepartamento))) = UPPER(rtrim(ltrim(@psDepto))))    
    and (@psLinea = '' OR UPPER(rtrim(ltrim(f.WorkCenter))) = UPPER(rtrim(ltrim(@psLinea))))    
    
    INSERT INTO @TOTALES4    
    SELECT     
        isnull(CASE  WHEN PzsProduc >= Frecuencia THEN COUNT(PzsProduc) END ,0) as 'Critico',            
        isnull(CASE WHEN  Convert(numeric(10,2),(convert(numeric(18,2),PzsProduc)/convert(numeric(18,2),Frecuencia)))*100 BETWEEN 91  AND 100 THEN COUNT(PzsProduc) END ,0) as 'Medio',           
        isnull(CASE WHEN  Convert(numeric(10,2),(convert(numeric(18,2),PzsProduc)/convert(numeric(18,2),Frecuencia)))*100 < 90 THEN COUNT(PzsProduc) END ,0) as 'Warning'       
    FROM @TOTALES5    
    group by PzsProduc, Frecuencia    
    
    select 'Todos' as WorkCenter, isnull(sum(Critico),0) as Critico, isnull(Sum(Medio),0) as Medio, isnull(Sum(Warning),0) as Warning from @TOTALES4    
    
   END     
 END    
 SET NOCOUNT OFF    
 --RETURN(CASE WHEN (@TRANS_ERRORS > 0) THEN 1 ELSE 0 END)    
    
END    
GO    
ALTER PROCEDURE [dbo].[sp_SelEstatus]    
AS  
BEGIN    
  SELECT EstatusId, Descripcion
  FROM CatEstatus (NOLOCK)
  WHERE EstatusId > 0 
END  
GO   
ALTER  PROCEDURE [dbo].[sp_RechazarMonitorTPM_JE]     
  @psIdChkEquipo int    
  ,@psUser varchar(20)
  ,@psNombreUser varchar(200)      
AS      
BEGIN       
	declare @psCodEquipo varchar(200), @psCodDepartamento  varchar(200), @psCodWorkCenter  varchar(200)

	SELECT @psCodEquipo = CodEquipo
		, @psCodDepartamento = CodDepartamento
		, @psCodWorkCenter = CodWorkCenter
	FROM [dbo].[CheckListCapEnc]    (NOLOCK)
	Where IdChkEquipo = @psIdChkEquipo  

	 -- RESET
	 UPDATE EquipoUltimaEjec    
	 SET UltimaEjec = GETDATE()   
		 , Estatus = 0  
		 , FechaFlujo = NULL
	 WHERE CodEquipo = @psCodEquipo   
	 AND CodDepartamento = @psCodDepartamento
	 AND WorkCenter = @psCodWorkCenter
	  
	 -- RESET NUEVA TABLA  NO APLICA
	 
	-- ACTUALIZA EL CHECK LIST CAPTURADO
	UPDATE [dbo].[CheckListCapEnc]  
        SET  UserCancela   = @psNombreUser    
			,FchCancel     = GETDATE()
			,EstatusId		 = 3	
			,FechaFinalFlujo = GETDATE()
	Where IdChkEquipo = @psIdChkEquipo  
     
 -- ENVIAR NOTIFICACION DE RECHAZO DE CAPTURA DE CHECKLIST
 --EXEC  [envia_correo] 0, 1, @psCodEquipo, 'RECHAZADO'

END    
GO 
ALTER  PROCEDURE [dbo].[sp_AprobarMonitorTPM_JE]       
  @psIdChkEquipo int    
  ,@psUser varchar(20)
  ,@psNombreUser varchar(200)  
AS      
BEGIN      
        
	declare @psCodEquipo varchar(200), @psCodDepartamento  varchar(200), @psCodWorkCenter  varchar(200)

	SELECT @psCodEquipo = CodEquipo
		, @psCodDepartamento = CodDepartamento
		, @psCodWorkCenter = CodWorkCenter
	FROM [dbo].[CheckListCapEnc]   
	Where IdChkEquipo = @psIdChkEquipo  

	 -- RESET
	 /*
		  - Al realizar la aprobación de la solicitud reiniciar lo siguiente:
			   - Piezas Producidas
			   - Porcentaje
			   - Estatus
			   - Fecha Flujo
	 */
	 UPDATE EquipoUltimaEjec    
	 SET   UltimaEjec = GETDATE()   
		 , Estatus = 0  
		 , FechaFlujo = NULL
		 , FechaCalculoDe = GETDATE()
		 , FechaCalculoHasta = NULL
		 , PiezasProducidas = 0
	 WHERE CodEquipo = @psCodEquipo   
	 AND CodDepartamento = @psCodDepartamento
	 AND WorkCenter = @psCodWorkCenter
	  
	 -- RESET NUEVA TABLA 
	 
	-- ACTUALIZA EL CHECK LIST CAPTURADO
	UPDATE [dbo].[CheckListCapEnc]  
        SET  UserActiva   = @psNombreUser 
			,UserEjecuto  = @psNombreUser 
			,FchEjecucion = GETDATE()  
			,[FchModif]		 = GETDATE()   
			,EstatusId		 = 2	
			,FechaFinalFlujo = GETDATE()
	Where IdChkEquipo = @psIdChkEquipo  
    
 -- ENVIAR NOTIFICACION DE APROBACION DE CAPTURA DE CHECKLIST
 --EXEC  [envia_correo] 0, 1, @psCodEquipo, 'AUTORIZADO'
END    
GO 
-- exec [sp_SelCheckListxEqEncPreCaptura_JE] @psCodDepto = 'MATR', @psCodEquipo = 'T00131036/30'    
ALTER PROCEDURE [dbo].[sp_SelCheckListxEqEncPreCaptura_JE]      
 @psCodDepto varchar(100) = '',    
 @psCodEquipo varchar(100) = ''    
AS    
BEGIN    
 SET NOCOUNT ON    
      
 BEGIN     

	DECLARE @_IdChkEquipo INT 

	SELECT @_IdChkEquipo = e.IdChkEquipo
	  FROM [CheckListCapEnc] e  (nolock)   
	  Where  rtrim(ltrim(e.CodDepartamento)) = rtrim(ltrim(@psCodDepto))     
			 --and rtrim(ltrim(e.IdChkEquipo)) = (select MAX(IdChkEquipo) from CheckListxEqEnc   (nolock)   
			 --where CodEquipo = ltrim(rtrim(@psCodEquipo)))  
			 and e.CodEquipo = @psCodEquipo
			 and e.EstatusId IN (1,4) -- Captura y Pre Captura
	  order by e.IdChkEquipo desc
    
	  IF @_IdChkEquipo IS NULL BEGIN
		  SELECT 'TEMPLATE' Result, 0 as IdChkEquipo, e.ChkEquipo, e.CodWorkCenter, e.CodEquipo, e.IdCheckList, e.CodChkList, e.DescripChkList,     
				  e.CodClasif, e.EqParado, case when e.Activo = 1 then 'Activo' else 'Inactivo' end as Activo, e.CodDepartamento, e.IdFrecuencia, c.Descripcion as DesripFrencu,    
				  e.Frecuencia, e.UserModif, e.FchModif, e.IniProgram , eq.Estatus, eq.EstatusId, eq.FechaFlujo, eq.WorkCenter  
		  FROM [CheckListxEqEnc] e  (nolock)  
		  left Join [CatCiclos] c (nolock) on c.CodCiclo = e.IdFrecuencia    
		  outer apply(  
				select top 1 eq.Estatus as EstatusId, eq.FechaFlujo, es.Descripcion as Estatus, eq.WorkCenter  
				from EquipoUltimaEjec eq (nolock)  
				inner join CatEstatus es (nolock) on es.EstatusId = eq.Estatus  
					 where eq.CodEquipo= e.CodEquipo   
					 and eq.WorkCenter=   e.CodWorkCenter   
					 order by IdEquipoUltimaEjec desc  
		   ) as eq  
		  Where  rtrim(ltrim(e.CodDepartamento)) = rtrim(ltrim(@psCodDepto))     
		  and	 rtrim(ltrim(e.IdChkEquipo)) = (select MAX(IdChkEquipo) from CheckListxEqEnc (nolock)    
				   where CodEquipo = ltrim(rtrim(@psCodEquipo)))    
	  END
	  ELSE BEGIN
		  SELECT 'PRE CAPTURA' Result, e.IdChkEquipo, e.DescripChkList as ChkEquipo, e.CodWorkCenter, e.CodEquipo, e.IdCheckList, e.CodChkList, e.DescripChkList,     
						  e.CodClasif, e.EqParado, case when e.Activo = 1 then 'Activo' else 'Inactivo' end as Activo, e.CodDepartamento, e.IdFrecuencia, c.Descripcion as DesripFrencu,    
						  e.Frecuencia, e.UserModif, e.FchModif, e.IniProgram , eq.Estatus, eq.EstatusId, eq.FechaFlujo, eq.WorkCenter  
				  FROM [CheckListCapEnc] e  (nolock)  
				  left Join [CatCiclos] c (nolock) on c.CodCiclo = e.IdFrecuencia    
				  outer apply(  
						select top 1 eq.Estatus as EstatusId, eq.FechaFlujo, es.Descripcion as Estatus, eq.WorkCenter  
						from EquipoUltimaEjec eq (nolock)  
						inner join CatEstatus es (nolock) on es.EstatusId = eq.Estatus  
							 where eq.CodEquipo= e.CodEquipo   
							 and eq.WorkCenter=   e.CodWorkCenter   
							 order by IdEquipoUltimaEjec desc  
				   ) as eq  
				  Where  e.IdChkEquipo = @_IdChkEquipo  
	  END

 END    
 SET NOCOUNT OFF    
     
END    
GO
-- exec [sp_SelCheckListxEqDetPreCaptura_JE]  @pnIdChkEquipo = 49669, @psCodDepto = 'LA      ', @psCodEquipo = 'T00131036/30' 
ALTER PROCEDURE [dbo].[sp_SelCheckListxEqDetPreCaptura_JE]      
 @pnIdChkEquipo INT = 0,
 @psCodDepto varchar(100) = '',    
 @psCodEquipo varchar(100) = ''        
AS    
BEGIN    
 SET NOCOUNT ON    
      
 BEGIN     
    
	IF @pnIdChkEquipo = 0  BEGIN
	 
			SELECT top 1 @pnIdChkEquipo = e.IdChkEquipo
			  FROM [CheckListxEqEnc] e  (nolock)   
			  Where  rtrim(ltrim(e.CodDepartamento)) = rtrim(ltrim(@psCodDepto))     
					 and rtrim(ltrim(e.IdChkEquipo)) = (select MAX(IdChkEquipo) from CheckListxEqEnc   (nolock)   
					 where CodEquipo = ltrim(rtrim(@psCodEquipo)))   
			  order by e.IdChkEquipo desc

		  SELECT 'TEMPLATE' Result, d.IdDtCheckList, d.IdChkEquipo, d.CodWorkCenter, d.CodEquipo, d.IdCheckList, d.CodChkList, d.CodGpoActiv, d.idActividad,    
				d.CodActividad ,a.DescripcionAct, s.CodSistema,s.Sistema as DescripSistema ,c.IdComponente,c.DescripCompo,    
				d.Orden, d.TipoActividad, d.TipoOperacion, CASE WHEN d.EqParado = 1 THEN 'SI' ELSE 'NO' END AS EqParado, d.RangoMin, d.OperadorMin, d.RangoMax, d.OperadorMax, isnull(d.CodUom, '') as CodUom, isnull(u.Descrip,'') as DescripUom,    
				d.Ponderacion, d.Activo, d.Item, d.CodUom, '' AS Comentarios    
				FROM [CheckListxEqDet]  d    (nolock)
					inner join[CatActivChkLst] a (nolock)on a.IdActividad = d.idActividad    
					inner join[CatSistemasEquipos] s (nolock)on s.CodSistema = a.CodSistema    
					inner join[CatComponentes] c (nolock)on c.IdComponente = a.IdComponente    
					left join[CatUom] u (nolock)on u.CodUom = d.CodUom    
					Where d.IdChkEquipo =  @pnIdChkEquipo    
					order by d.Orden    
	END
	ELSE BEGIN
		 SELECT 'PRE CAPTURA' Result, d.IdDtCheckList, d.IdChkEquipo, d.CodWorkCenter, d.CodEquipo, d.IdCheckList, d.CodChkList, d.CodGpoActiv, d.idActividad,    
					d.CodActividad ,a.DescripcionAct, s.CodSistema,s.Sistema as DescripSistema ,c.IdComponente,c.DescripCompo,    
					d.Orden, d.TipoActividad, d.TipoOperacion, CASE WHEN d.EqParado = 1 THEN 'SI' ELSE 'NO' END AS EqParado, d.RangoMin, d.OperadorMin, d.RangoMax, d.OperadorMax, isnull(d.CodUom, '') as CodUom, isnull(u.Descrip,'') as DescripUom,    
					d.Ponderacion, d.Activo, d.Item, d.CodUom, d.ResultVisual, '' AS Comentarios   
					FROM [CheckListCapDet]  d    (nolock)
						inner join[CatActivChkLst] a (nolock)on a.IdActividad = d.idActividad    
						inner join[CatSistemasEquipos] s (nolock)on s.CodSistema = a.CodSistema    
						inner join[CatComponentes] c (nolock)on c.IdComponente = a.IdComponente    
						left join[CatUom] u (nolock)on u.CodUom = d.CodUom    
						Where d.IdChkEquipo =  @pnIdChkEquipo    
						order by d.Orden  
	END
    
 END    
 SET NOCOUNT OFF    
     
END    
GO
ALTER PROCEDURE [dbo].[sp_UpdMonitorPreCapturaTPM_JE]     
@psIdChkEquipo int   
  ,@psUser varchar(20)
  ,@psNombreUser varchar(200)  
AS    
BEGIN    
     declare @psCodEquipo varchar(200), @psCodDepartamento  varchar(200), @psCodWorkCenter  varchar(200)

	SELECT @psCodEquipo = CodEquipo
		, @psCodDepartamento = CodDepartamento
		, @psCodWorkCenter = CodWorkCenter
	FROM [dbo].[CheckListCapEnc]   (NOLOCK)
	Where IdChkEquipo = @psIdChkEquipo  

	 UPDATE EquipoUltimaEjec  
			SET Estatus = 4
			, FechaFlujo =GETDATE()
	 WHERE CodEquipo = @psCodEquipo   
	 AND CodDepartamento = @psCodDepartamento
	 AND WorkCenter = @psCodWorkCenter
   
    -- ACTUALIZA EL CHECK LIST CAPTURADO
	UPDATE [dbo].[CheckListCapEnc]  
        SET  UserModif   = @psNombreUser  
			,[FchModif]		 = GETDATE()   
			,EstatusId		 = 4	 
	Where IdChkEquipo = @psIdChkEquipo  
END  
GO 
ALTER PROCEDURE [dbo].[sp_InsCheckListCapEnc_JE]     
  @psIdChkEquipo int   
  ,@pnEsPreCaptura int = 0
  ,@psUser varchar(20)
  ,@psNombreUser varchar(200)
  ,@psCodDepto varchar(100) = ''    
  ,@psCodEquipo varchar(100) = ''      
  ,@pnIdChkEquipoOutput int output  
AS    
BEGIN    

	 IF @psIdChkEquipo = 0 BEGIN
		 SELECT top 1 @psIdChkEquipo = e.IdChkEquipo
					  FROM [CheckListxEqEnc] e  (nolock)   
					  Where  rtrim(ltrim(e.CodDepartamento)) = rtrim(ltrim(@psCodDepto))     
							 and rtrim(ltrim(e.IdChkEquipo)) = (select MAX(IdChkEquipo) from CheckListxEqEnc   (nolock)   
							 where CodEquipo = ltrim(rtrim(@psCodEquipo)))   
					  order by e.IdChkEquipo desc
		
		INSERT INTO [dbo].[CheckListCapEnc]  
           ([Planta]  
           ,[CentroCostos]  
           ,[CodDepartamento]  
           ,[CodWorkCenter]  
           ,[CodEquipo]  
           ,[IdCheckList]  
           ,[CodChkList]  
           ,[DescripChkList]  
           ,[CodClasif]  
           ,[EqParado]  
           ,[Activo]  
           ,[IdFrecuencia]  
           ,[Frecuencia]  
           ,[UserAlta]  
           ,[FchAlta]  
           ,[UserModif]  
           ,[FchModif]  
           ,[IniProgram]  
           ,[UserActiva]  
           ,[FchCancel]  
           ,[UserCancela]  
           ,[FchEjecucion]  
           ,[UserEjecuto]  
           ,[Observaciones]  
           ,[FecProgramada]
		   ,EstatusId
		   ,FechaIniciaFlujo
		   ,FechaFinalFlujo
		   ,FechaIPreCaptura)  
     SELECT  
            e.Planta   
           ,CentroCostos   
           ,CodDepartamento   
           ,CodWorkCenter  
           ,CodEquipo  
           ,IdCheckList   
           ,CodChkList   
           ,DescripChkList   
           ,CodClasif   
           ,EqParado   
           ,Activo   
           ,IdFrecuencia   
           ,Frecuencia   
           ,@psNombreUser UserAlta   
           ,GETDATE() FchAlta   
           ,NULL UserModif   
           ,NULL FchModif   
           ,NULL IniProgram   
           ,NULL UserActiva   
           ,NULL FchCancel   
           ,NULL UserCancela   
           ,NULL FchEjecucion   
           ,NULL UserEjecuto   
           ,''															  as Observaciones   
           ,NULL														  as FecProgramada
		   ,(case when @pnEsPreCaptura = 1 then 4 else 1 end)			  as EstatusId	-- Captura / Pre Captura 
		   ,(case when @pnEsPreCaptura = 1 then NULL else GETDATE() end)  as FechaIniciaFlujo
		   ,NULL														  as FechaFinalFlujo
		   ,(case when @pnEsPreCaptura = 1 then GETDATE() else NULL end)  as FechaIPreCaptura
   FROM [CheckListxEqEnc] e     (NOLOCK)
   Where rtrim(ltrim(e.IdChkEquipo)) = @psIdChkEquipo  
	
		SET @pnIdChkEquipoOutput = @@IDENTITY  

	 END
	 ELSE BEGIN

		UPDATE [dbo].[CheckListCapEnc]  
           SET [UserModif]   = @psNombreUser
           ,[FchModif]		 = GETDATE()   
		   ,EstatusId		 = (case when @pnEsPreCaptura = 1 then 4 else 1 end)	
		   ,FechaIniciaFlujo = (case when @pnEsPreCaptura = 1 then NULL else GETDATE() end)  
		Where IdChkEquipo = @psIdChkEquipo  
		
		SET @pnIdChkEquipoOutput = @psIdChkEquipo  
	 END
	
END  
GO
ALTER PROCEDURE [dbo].[sp_InsCheckListxEqDet_JE]      
 @pnIdDtCheckList INT   
 ,@pnResultVisual  INT = null  
 ,@psIdChkEquipo int  
 ,@psComentarios varchar(259) = ''
AS    
BEGIN    

		IF EXISTS(SELECT 1 FROM [dbo].[CheckListCapDet] (NOLOCK) WHERE IdDtCheckList = @pnIdDtCheckList and IdChkEquipo = @psIdChkEquipo) BEGIN
			UPDATE [dbo].[CheckListCapDet]
				SET ResultVisual = @pnResultVisual
				, DescripUom=@psComentarios
				WHERE IdDtCheckList = @pnIdDtCheckList
		END 
		ELSE BEGIN
			INSERT INTO [dbo].[CheckListCapDet]  
				   ([IdChkEquipo]  
				   ,[CodWorkCenter]  
				   ,[CodEquipo]  
				   ,[IdCheckList]  
				   ,[CodChkList]  
				   ,[CodGpoActiv]  
				   ,[idActividad]  
				   ,[CodActividad]  
				   ,[Orden]  
				   ,[TipoActividad]  
				   ,[TipoOperacion]  
				   ,[EqParado]  
				   ,[RangoMin]  
				   ,[OperadorMin]  
				   ,[RangoMax]  
				   ,[OperadorMax]  
				   ,[Ponderacion]  
				   ,[Activo]  
				   ,[Item]  
				   ,[ResultVisual]  
				   ,[ResultMedible]  
				   ,[CodUom]  
				   ,[DescripUom]  
				   ,[ResultActiv])  
			 SELECT  
					@psIdChkEquipo   
				   ,CodWorkCenter   
				   ,CodEquipo   
				   ,IdCheckList   
				   ,'' CodChkListz   
				   ,CodGpoActiv   
				   ,idActividad   
				   ,CodActividad   
				   ,Orden   
				   ,TipoActividad   
				   ,TipoOperacion   
				   ,EqParado   
				   ,RangoMin   
				   ,OperadorMin   
				   ,RangoMax   
				   ,OperadorMax   
				   ,Ponderacion   
				   ,Activo   
				   ,Item   
				   ,@pnResultVisual  
				   ,0 ResultMedible   
				   ,CodUom   
				   ,@psComentarios DescripUom   
				   ,0 ResultActiv   
		  FROM [CheckListxEqDet] (NOLOCK)  
		  WHERE IdDtCheckList = @pnIdDtCheckList  
		END
END  
GO
ALTER PROCEDURE [dbo].[sp_HistoricoCheckListCapEnc_JE]   
@psCodEquipo VARCHAR(200) = ''
,@pnEstatusId INT = 0
AS
BEGIN
	select DISTINCT
	   E1.IdChkEquipo
	 , E1.Planta
	 , E1.CentroCostos
	 , E1.CodWorkCenter
	 , E1.CodEquipo
	 , E1.CodChkList
	 , E1.DescripChkList
	 , E1.CodClasif
	 , E1.Activo
	 , CASE WHEN E1.Activo = 1 THEN 'SI' ELSE 'NO' END AS ActivoNombre
	 , E1.UserAlta
	 , E1.FchAlta
	 , E1.UserCancela
	 , E1.FchCancel
	 , E1.FchEjecucion
	 , E1.UserModif
	 , E1.FchModif
	 , E1.Observaciones
	 , E1.EstatusId
	 , E2.Descripcion AS Estatus
	 , E1.FechaIniciaFlujo
	 , E1.FechaFinalFlujo
	 , E1.FechaIPreCaptura
	 , E1.UserActiva
	from CheckListCapEnc E1 (nolock)
	inner join CatEstatus E2 (nolock) on E2.EstatusId = E1.EstatusId
	where (@psCodEquipo = '' OR E1.CodEquipo = @psCodEquipo) --'T00131036/30'  
	and (@pnEstatusId = 0 OR E1.EstatusId = @pnEstatusId)
	ORDER BY E1.IdChkEquipo DESC
END
GO
ALTER PROCEDURE [dbo].[sp_SelCheckListxEqEncNotasHistorico_JE]      
 @psIdChkEquipo int  
AS    
BEGIN    

	SELECT 'HISTORICO' Result, e.IdChkEquipo, e.DescripChkList as ChkEquipo, e.CodWorkCenter, e.CodEquipo, e.IdCheckList, e.CodChkList, e.DescripChkList,     
						  e.CodClasif, e.EqParado, case when e.Activo = 1 then 'Activo' else 'Inactivo' end as Activo, e.CodDepartamento, e.IdFrecuencia, c.Descripcion as DesripFrencu,    
						  e.Frecuencia, e.UserModif, e.FchModif, e.IniProgram , eq.Estatus, eq.EstatusId, eq.FechaFlujo, eq.WorkCenter  
				  FROM [CheckListCapEnc] e  (nolock)  
				  left Join [CatCiclos] c (nolock) on c.CodCiclo = e.IdFrecuencia    
				  outer apply(  
						select top 1 eq.Estatus as EstatusId, eq.FechaFlujo, es.Descripcion as Estatus, eq.WorkCenter  
						from EquipoUltimaEjec eq (nolock)  
						inner join CatEstatus es (nolock) on es.EstatusId = eq.Estatus  
							 where eq.CodEquipo= e.CodEquipo   
							 and eq.WorkCenter=   e.CodWorkCenter   
							 order by IdEquipoUltimaEjec desc  
				   ) as eq  
				  Where  e.IdChkEquipo = @psIdChkEquipo    
     
END    
GO
ALTER PROCEDURE [dbo].[sp_SelCheckListxEqDetNotasHistorico_JE]      
 @psIdChkEquipo int        
AS    
BEGIN    
  
  SELECT 'HISTORICO' Result, d.IdDtCheckList, d.IdChkEquipo, d.CodWorkCenter, d.CodEquipo, d.IdCheckList, d.CodChkList, d.CodGpoActiv, d.idActividad,    
					d.CodActividad ,a.DescripcionAct, s.CodSistema,s.Sistema as DescripSistema ,c.IdComponente,c.DescripCompo,    
					d.Orden, d.TipoActividad, d.TipoOperacion, CASE WHEN d.EqParado = 1 THEN 'SI' ELSE 'NO' END AS EqParado, d.RangoMin, d.OperadorMin, d.RangoMax, d.OperadorMax, isnull(d.CodUom, '') as CodUom, isnull(u.Descrip,'') as DescripUom,    
					d.Ponderacion, d.Activo, d.Item, d.CodUom, d.ResultVisual, d.DescripUom as Comentarios 
					FROM [CheckListCapDet]  d    (nolock)
						inner join[CatActivChkLst] a (nolock)on a.IdActividad = d.idActividad    
						inner join[CatSistemasEquipos] s (nolock)on s.CodSistema = a.CodSistema    
						inner join[CatComponentes] c (nolock)on c.IdComponente = a.IdComponente    
						left join[CatUom] u (nolock)on u.CodUom = d.CodUom    
						Where d.IdChkEquipo =  @psIdChkEquipo    
						order by d.Orden  
     
END    
GO 
ALTER PROCEDURE [dbo].[Usuario_Login]    
    
(@psUsuario VARCHAR(100) = '',    
@psContrasenia VARCHAR(100) = ''    
    
)    
AS    
BEGIN    
    
Declare @nUsuarioId INT = 0, @nEmpresaId INT, @sNombreUsuario VARCHAR(100), @sUsuario VARCHAR(100),     
@nPerfilId INT, @sImg VARCHAR(100) = '', @sNumUsuario VARCHAR(100) = '', @nSucursalId INT = 0,@sUid VARCHAR(50),    
 @pnPerfilFuncionalId INT, @nAreaId INT = 0, @bEsCrearModificarActivity bit = 0  , @bEsAprobador bit = 0  , @bUsuarioCompuesto varchar(259) = '' 
    
--Revisar si el usuario Existe en la Bd    
IF NOT EXISTS(Select 1 from [UsuariosTpm] where [NumControl]=@psUsuario)    
BEGIN     
RAISERROR('El Usuario   No existe',16,1)    
RETURN    
END    
    
IF   EXISTS(Select 1 from [UsuariosTpm] where [NumControl]=@psUsuario and [StatusEmpTpm]=0)    
BEGIN    
RAISERROR('El Usuario  si existe pero no esta activo',16,1)    
RETURN    
END    
    
SELECT      
   @nUsuarioId = ceu.[Id],     
   @sUsuario = ceu.[Nombre],     
   @nPerfilId = ceu.PerfilFuncionalId,  
   @sNombreUsuario = ceu.Nombre,   
   @sNumUsuario = [NumControl],      
   @pnPerfilFuncionalId = ceu.PerfilFuncionalId,  
   @bEsCrearModificarActivity = isNull(pf.EsCrearModificarInfo, 0),  
   @bEsAprobador = isNull(pf.EsAprobador, 0)    
FROM  [UsuariosTpm] ceu WITH (NOLOCK)        
left join PerfilFuncional pf with(nolock) on ceu.PerfilFuncionalId = pf.PerfilId     
WHERE ceu.[NumControl] = @psUsuario AND ceu.[NumControl] <> ''    
and [Password]= @psContrasenia    
    
IF(@nUsuarioId = 0)    
BEGIN    
 RAISERROR('Favor de verificar el usuario o contraseña, datos inválidos.', 16, 1)                                                                
 RETURN      
END    

SET @bUsuarioCompuesto = CASE 
						 WHEN @bEsCrearModificarActivity = 1 THEN 'Función: Check List - ' 
						 WHEN @bEsAprobador = 1 THEN 'Función: Aprobador - ' 
						 ELSE '' END
						 +
						 @sNumUsuario + ' - '
						 + 
						 @sNombreUsuario
SELECT    
 @nUsuarioId UsuarioId, @sUsuario Usuario, @nPerfilId PerfilId, @sNombreUsuario NombreUsuario, @sImg ImgUser,    
@sNumUsuario NumUsuario,@sUid UID, @pnPerfilFuncionalId PerfilFuncionalId, @nAreaId AreaId,   
@bEsCrearModificarActivity esCrearModificarInfo, @bEsAprobador esAprobador , @bUsuarioCompuesto as UsuarioCompuesto  
END    
GO
