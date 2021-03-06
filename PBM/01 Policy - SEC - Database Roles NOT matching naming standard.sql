Declare @condition_id int
EXEC msdb.dbo.sp_syspolicy_add_condition @name=N'SEC - Database Roles NOT matching naming standard', @description=N'', @facet=N'Database', @expression=N'<Operator>
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
      <Value>WITH    customDBRoles ( name )&lt;?char 13?&gt;
          AS ( SELECT   name&lt;?char 13?&gt;
               FROM     sys.database_principals&lt;?char 13?&gt;
               WHERE    type_desc = ''''DATABASE_ROLE''''&lt;?char 13?&gt;
                        AND name NOT IN ( ''''db_owner'''', ''''db_accessadmin'''',&lt;?char 13?&gt;
                                          ''''db_securityadmin'''', ''''db_ddladmin'''',&lt;?char 13?&gt;
                                          ''''db_backupoperator'''', ''''db_datareader'''',&lt;?char 13?&gt;
                                          ''''db_datawriter'''', ''''db_denydatareader'''',&lt;?char 13?&gt;
                                          ''''db_denydatawriter'''', ''''public'''' )&lt;?char 13?&gt;
             )&lt;?char 13?&gt;
    SELECT  COUNT(*)&lt;?char 13?&gt;
    FROM    customDBRoles&lt;?char 13?&gt;
    WHERE   name NOT LIKE ''''app_%''''&lt;?char 13?&gt;
            AND name NOT LIKE ''''user_%''''&lt;?char 13?&gt;
            AND name NOT LIKE ''''admin_%''''</Value>
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
EXEC msdb.dbo.sp_syspolicy_add_object_set @object_set_name=N'SEC - Database Roles NOT matching naming standard_ObjectSet', @facet=N'Database', @object_set_id=@object_set_id OUTPUT
Select @object_set_id

Declare @target_set_id int
EXEC msdb.dbo.sp_syspolicy_add_target_set @object_set_name=N'SEC - Database Roles NOT matching naming standard_ObjectSet', @type_skeleton=N'Server/Database', @type=N'DATABASE', @enabled=True, @target_set_id=@target_set_id OUTPUT
Select @target_set_id

EXEC msdb.dbo.sp_syspolicy_add_target_set_level @target_set_id=@target_set_id, @type_skeleton=N'Server/Database', @level_name=N'Database', @condition_name=N'', @target_set_level_id=0



Declare @policy_id int
EXEC msdb.dbo.sp_syspolicy_add_policy @name=N'SEC - Database Roles NOT matching naming standard', @condition_name=N'SEC - Database Roles NOT matching naming standard', @policy_category=N'Security', @description=N'Checks if the database roles created by ETX match the naming standard put in place ', @help_text=N'', @help_link=N'', @schedule_uid=N'00000000-0000-0000-0000-000000000000', @execution_mode=0, @is_enabled=False, @policy_id=@policy_id OUTPUT, @root_condition_name=N'', @object_set=N'SEC - Database Roles NOT matching naming standard_ObjectSet'
Select @policy_id


