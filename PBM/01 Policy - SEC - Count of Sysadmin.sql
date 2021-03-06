Declare @condition_id int
EXEC msdb.dbo.sp_syspolicy_add_condition @name=N'SEC - Count of Sysadmin', @description=N'', @facet=N'IServerConfigurationFacet', @expression=N'<Operator>
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
      <Value>SELECT  COUNT(*)&lt;?char 13?&gt;
FROM    sys.server_principals p&lt;?char 13?&gt;
        JOIN sys.syslogins s ON p.sid = s.sid&lt;?char 13?&gt;
WHERE   p.type_desc IN (''''SQL_LOGIN'''', ''''WINDOWS_LOGIN'''', ''''WINDOWS_GROUP'''')&lt;?char 13?&gt;
        AND p.name NOT LIKE ''''##%''''&lt;?char 13?&gt;
        AND s.sysadmin = 1&lt;?char 13?&gt;
		AND s.name NOT LIKE ''''NT%''''&lt;?char 13?&gt;
		AND P.is_disabled != 1</Value>
    </Constant>
  </Function>
  <Constant>
    <TypeClass>Numeric</TypeClass>
    <ObjType>System.Double</ObjType>
    <Value>3</Value>
  </Constant>
</Operator>', @is_name_condition=0, @obj_name=N'', @condition_id=@condition_id OUTPUT
Select @condition_id


Declare @object_set_id int
EXEC msdb.dbo.sp_syspolicy_add_object_set @object_set_name=N'SEC - Count of Sysadmin_ObjectSet', @facet=N'IServerConfigurationFacet', @object_set_id=@object_set_id OUTPUT
Select @object_set_id

Declare @target_set_id int
EXEC msdb.dbo.sp_syspolicy_add_target_set @object_set_name=N'SEC - Count of Sysadmin_ObjectSet', @type_skeleton=N'Server', @type=N'SERVER', @enabled=True, @target_set_id=@target_set_id OUTPUT
Select @target_set_id




Declare @policy_id int
EXEC msdb.dbo.sp_syspolicy_add_policy @name=N'SEC - Count of Sysadmin', @condition_name=N'SEC - Count of Sysadmin', @policy_category=N'Security', @description=N'This policy will count the number of enabled SQL Logins, Windows Logins and AD Groups who have Sysadmin rights. The count should be 3.', @help_text=N'', @help_link=N'', @schedule_uid=N'00000000-0000-0000-0000-000000000000', @execution_mode=0, @is_enabled=False, @policy_id=@policy_id OUTPUT, @root_condition_name=N'', @object_set=N'SEC - Count of Sysadmin_ObjectSet'
Select @policy_id


