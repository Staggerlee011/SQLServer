Declare @condition_id int
EXEC msdb.dbo.sp_syspolicy_add_condition @name=N'DAILY - Databases File Size', @description=N'', @facet=N'DataFile', @expression=N'<Operator>
  <TypeClass>Bool</TypeClass>
  <OpType>EQ</OpType>
  <Count>2</Count>
  <Attribute>
    <TypeClass>Numeric</TypeClass>
    <Name>UsedSpace</Name>
  </Attribute>
  <Attribute>
    <TypeClass>Numeric</TypeClass>
    <Name>UsedSpace</Name>
  </Attribute>
</Operator>', @is_name_condition=0, @obj_name=N'', @condition_id=@condition_id OUTPUT
Select @condition_id


Declare @object_set_id int
EXEC msdb.dbo.sp_syspolicy_add_object_set @object_set_name=N'DAILY - Databases File Size_ObjectSet', @facet=N'DataFile', @object_set_id=@object_set_id OUTPUT
Select @object_set_id

Declare @target_set_id int
EXEC msdb.dbo.sp_syspolicy_add_target_set @object_set_name=N'DAILY - Databases File Size_ObjectSet', @type_skeleton=N'Server/Database/FileGroup/File', @type=N'FILE', @enabled=True, @target_set_id=@target_set_id OUTPUT
Select @target_set_id

EXEC msdb.dbo.sp_syspolicy_add_target_set_level @target_set_id=@target_set_id, @type_skeleton=N'Server/Database/FileGroup/File', @level_name=N'File', @condition_name=N'', @target_set_level_id=0
EXEC msdb.dbo.sp_syspolicy_add_target_set_level @target_set_id=@target_set_id, @type_skeleton=N'Server/Database/FileGroup', @level_name=N'FileGroup', @condition_name=N'', @target_set_level_id=0
EXEC msdb.dbo.sp_syspolicy_add_target_set_level @target_set_id=@target_set_id, @type_skeleton=N'Server/Database', @level_name=N'Database', @condition_name=N'', @target_set_level_id=0



Declare @policy_id int
EXEC msdb.dbo.sp_syspolicy_add_policy @name=N'DAILY - Databases File Size', @condition_name=N'DAILY - Databases File Size', @policy_category=N'Daily Health Check', @description=N'Reports size of each file in a database, there is no failure on this, as its just used for reporting from', @help_text=N'', @help_link=N'', @schedule_uid=N'00000000-0000-0000-0000-000000000000', @execution_mode=0, @is_enabled=False, @policy_id=@policy_id OUTPUT, @root_condition_name=N'', @object_set=N'DAILY - Databases File Size_ObjectSet'
Select @policy_id


