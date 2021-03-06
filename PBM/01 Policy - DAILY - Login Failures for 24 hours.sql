Declare @condition_id int
EXEC msdb.dbo.sp_syspolicy_add_condition @name=N'DAILY - Login Failures in last 24 hours', @description=N'', @facet=N'IServerConfigurationFacet', @expression=N'<Operator>
  <TypeClass>Bool</TypeClass>
  <OpType>EQ</OpType>
  <Count>2</Count>
  <Function>
    <TypeClass>Numeric</TypeClass>
    <FunctionType>ExecuteSql</FunctionType>
    <ReturnType>Numeric</ReturnType>
    <Count>2</Count>
    <Constant>
      <TypeClass>String</TypeClass>
      <ObjType>System.String</ObjType>
      <Value>numeric</Value>
    </Constant>
    <Constant>
      <TypeClass>String</TypeClass>
      <ObjType>System.String</ObjType>
      <Value>CREATE TABLE #ErrorLog&lt;?char 13?&gt;
(&lt;?char 13?&gt;
LogID INT IDENTITY(1, 1)&lt;?char 13?&gt;
NOT NULL&lt;?char 13?&gt;
PRIMARY KEY ,&lt;?char 13?&gt;
LogDate DATETIME NULL ,&lt;?char 13?&gt;
ProcessInfo NVARCHAR(100) NULL ,&lt;?char 13?&gt;
LogText NVARCHAR(4000) NULL&lt;?char 13?&gt;
)&lt;?char 13?&gt;
INSERT INTO #ErrorLog&lt;?char 13?&gt;
( LogDate, ProcessInfo, LogText )&lt;?char 13?&gt;
EXEC master..xp_readerrorlog 0, 1&lt;?char 13?&gt;
SELECT COUNT(*)&lt;?char 13?&gt;
FROM #ErrorLog&lt;?char 13?&gt;
WHERE LogDate &gt; GETDATE () -1&lt;?char 13?&gt;
AND LogText LIKE ''''login failed%''''&lt;?char 13?&gt;
drop table #ErrorLog</Value>
    </Constant>
  </Function>
  <Constant>
    <TypeClass>Numeric</TypeClass>
    <ObjType>System.Double</ObjType>
    <Value>0</Value>
  </Constant>
</Operator>', @is_name_condition=0, @obj_name=N'', @condition_id=@condition_id OUTPUT
Select @condition_id


Declare @object_set_id int
EXEC msdb.dbo.sp_syspolicy_add_object_set @object_set_name=N'DAILY - Login Failures in last 24 hours_ObjectSet', @facet=N'IServerConfigurationFacet', @object_set_id=@object_set_id OUTPUT
Select @object_set_id

Declare @target_set_id int
EXEC msdb.dbo.sp_syspolicy_add_target_set @object_set_name=N'DAILY - Login Failures in last 24 hours_ObjectSet', @type_skeleton=N'Server', @type=N'SERVER', @enabled=True, @target_set_id=@target_set_id OUTPUT
Select @target_set_id




Declare @policy_id int
EXEC msdb.dbo.sp_syspolicy_add_policy @name=N'DAILY - Login Failures for 24 hours', @condition_name=N'DAILY - Login Failures in last 24 hours', @policy_category=N'Daily Health Check', @description=N'Checks the number of login failures raised in the errorlog during the last 24 hours from when its ran', @help_text=N'', @help_link=N'', @schedule_uid=N'00000000-0000-0000-0000-000000000000', @execution_mode=0, @is_enabled=False, @policy_id=@policy_id OUTPUT, @root_condition_name=N'', @object_set=N'DAILY - Login Failures in last 24 hours_ObjectSet'
Select @policy_id


