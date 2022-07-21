use rapensambleemm 
GO
CREATE TABLE dbo.PRENSAS_PlanDeAccion
(
PlanDeAccionId INT PRIMARY KEY
,Tipo VARCHAR(20)
,Descripcion VARCHAR(529)
,FechaRegistro DATETIME
,UsuarioRegistra VARCHAR(259)
,Activo BIT
,FechaBaja     DATETIME
,UsuarioBaja VARCHAR(259)
)
GO
CREATE TABLE dbo.PRENSAS_Parametros
(
ParametroId INT PRIMARY KEY
,Tipo VARCHAR(20)
,Clave  VARCHAR(20)
,Descripcion VARCHAR(529)
,Valor VARCHAR(529)
,FechaRegistro DATETIME
,UsuarioRegistra VARCHAR(259) 
)
GO

INSERT INTO dbo.PRENSAS_Parametros SELECT 1, 'LINEAS', 'TIME_DISPONIBLE', 'Tiempo Disponible por Línea', '5580', GETDATE(), 'admin' 
INSERT INTO dbo.PRENSAS_Parametros SELECT 2, 'MTBF', 'META', 'Meta', '20', GETDATE(), 'admin' 
INSERT INTO dbo.PRENSAS_Parametros SELECT 3, 'MTTR', 'META', 'Meta', '50', GETDATE(), 'admin' 

SELECT * FROM dbo.PRENSAS_Parametros
