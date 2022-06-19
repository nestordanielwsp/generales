use Visita_Proveedor
go

update [CONFIG].[User] Set IsLDAPAuth = 0 where email = 'josue.flores@magna.com'

select  * from SEC_VM.VisitRecord order by VisitRecordId desc
select * from SEC_VM.Visitor
select * from SEC_VM.VisitorType
select * from SEC_VM.Document
select * from SEC_VM.SecurityBadge
select * from SEC_VM.SecurityCourse
select * from SEC_VM.SecurityCourseRecord

select * from SEC_VM.VisitStatus 

INSERT INTO SEC_VM.VisitStatus SELECT 'Deleted', 1

select 
    CONVERT(varbinary (255),(PasswordHash)), pwdencrypt(PasswordHash)   
	,* from [CONFIG].[User] where email = 'josue.flores@magna.com'

 
insert into [CONFIG].[UserRole] 
select 841,RoleId,GETDATE(),1 from [CONFIG].Role where RoleId not in (1,3,6)
 
select * from [CONFIG].[UserRole] where UserId=841
	 
update [CONFIG].[UserRole] set RoleId = 1 where UserId=7

/*
insert into SEC_VM.SecurityBadge select 'A04', 1
insert into SEC_VM.SecurityBadge select 'A05', 1
insert into SEC_VM.SecurityBadge select 'A06', 1
insert into SEC_VM.SecurityBadge select 'A07', 1
insert into SEC_VM.SecurityBadge select 'A08', 1
UPDATE SEC_VM.VisitRecord SET SecurityBadgeId = NULL, DocumentId = NULL WHERE VisitRecordId = 21
*/

