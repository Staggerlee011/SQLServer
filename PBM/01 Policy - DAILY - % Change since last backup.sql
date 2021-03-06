Declare @condition_id int
EXEC msdb.dbo.sp_syspolicy_add_condition @name=N'DAILY - % Change since last backup', @description=N'', @facet=N'Database', @expression=N'<Operator>
  <TypeClass>Bool</TypeClass>
  <OpType>LT</OpType>
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
      <Value>	IF EXISTS ( SELECT  *&lt;?char 13?&gt;
            FROM    sys.objects&lt;?char 13?&gt;
            WHERE   NAME = ''''SQLskillsDBCCPage'''' )&lt;?char 13?&gt;
    DROP TABLE msdb.dbo.SQLskillsDBCCPage;&lt;?char 13?&gt;
 CREATE TABLE msdb.dbo.SQLskillsDBCCPage (&lt;?char 13?&gt;
		[ParentObject]	VARCHAR (100),&lt;?char 13?&gt;
		[Object]		VARCHAR (100),&lt;?char 13?&gt;
		[Field]			VARCHAR (100),&lt;?char 13?&gt;
		[VALUE]			VARCHAR (100));	&lt;?char 13?&gt;
	DECLARE @fileID			INT;&lt;?char 13?&gt;
	DECLARE @fileSizePages	INT;&lt;?char 13?&gt;
	DECLARE @extentID		INT;&lt;?char 13?&gt;
	DECLARE @pageID			INT;&lt;?char 13?&gt;
	DECLARE	@DIFFTotal		INT;&lt;?char 13?&gt;
	DECLARE @sizeTotal		INT;&lt;?char 13?&gt;
	DECLARE @total			INT;&lt;?char 13?&gt;
	DECLARE @dbccPageString	VARCHAR (200)&lt;?char 13?&gt;
	DECLARE @dbname			VARCHAR (200);	&lt;?char 13?&gt;
	SELECT @DIFFtotal = 0;&lt;?char 13?&gt;
	SELECT @sizeTotal = 0;&lt;?char 13?&gt;
	SET @dbname = DB_NAME()&lt;?char 13?&gt;
	DECLARE files CURSOR FOR&lt;?char 13?&gt;
		SELECT [file_id], [size] FROM master.sys.master_files&lt;?char 13?&gt;
		WHERE [type_desc] = ''''ROWS''''&lt;?char 13?&gt;
		AND [state_desc] = ''''ONLINE''''&lt;?char 13?&gt;
		AND [database_id] = DB_ID();&lt;?char 13?&gt;
&lt;?char 13?&gt;
	OPEN files;&lt;?char 13?&gt;
&lt;?char 13?&gt;
	FETCH NEXT FROM files INTO @fileID, @fileSizePages;&lt;?char 13?&gt;
&lt;?char 13?&gt;
	WHILE @@FETCH_STATUS = 0&lt;?char 13?&gt;
	BEGIN&lt;?char 13?&gt;
		SELECT @extentID = 0;&lt;?char 13?&gt;
&lt;?char 13?&gt;
		SELECT @sizeTotal = @sizeTotal + @fileSizePages / 8;&lt;?char 13?&gt;
&lt;?char 13?&gt;
		WHILE (@extentID &lt; @fileSizePages)&lt;?char 13?&gt;
		BEGIN&lt;?char 13?&gt;
&lt;?char 13?&gt;
			SELECT @pageID = @extentID + 6;&lt;?char 13?&gt;
&lt;?char 13?&gt;
&lt;?char 13?&gt;
SELECT @dbccPageString = ''''DBCC PAGE (['''' + @dbname + ''''], '''' + CAST (@fileID AS VARCHAR)+ '''', '''' + CAST (@pageID AS VARCHAR)+ '''' , 3) WITH TABLERESULTS, NO_INFOMSGS'''';&lt;?char 13?&gt;
print @dbccpagestring&lt;?char 13?&gt;
			DELETE FROM msdb.dbo.SQLskillsDBCCPage;&lt;?char 13?&gt;
			INSERT INTO msdb.dbo.SQLskillsDBCCPage EXEC (@dbccPageString);&lt;?char 13?&gt;
&lt;?char 13?&gt;
			SELECT @total = SUM ([msdb].[dbo].[SQLskillsConvertToExtents] ([Field]))&lt;?char 13?&gt;
			FROM msdb.dbo.SQLskillsDBCCPage&lt;?char 13?&gt;
				WHERE [VALUE] = ''''    CHANGED''''&lt;?char 13?&gt;
				AND [ParentObject] LIKE ''''DIFF_MAP%'''';&lt;?char 13?&gt;
&lt;?char 13?&gt;
			SET @DIFFtotal = @DIFFtotal + @total;&lt;?char 13?&gt;
&lt;?char 13?&gt;
			SET @extentID = @extentID + 511232;&lt;?char 13?&gt;
		END&lt;?char 13?&gt;
&lt;?char 13?&gt;
		FETCH NEXT FROM files INTO @fileID, @fileSizePages;&lt;?char 13?&gt;
	END;&lt;?char 13?&gt;
&lt;?char 13?&gt;
	DROP TABLE msdb.dbo.SQLskillsDBCCPage;&lt;?char 13?&gt;
	CLOSE files;&lt;?char 13?&gt;
	DEALLOCATE files;&lt;?char 13?&gt;
&lt;?char 13?&gt;
	SELECT&lt;?char 13?&gt;
			ROUND (&lt;?char 13?&gt;
			(CONVERT (FLOAT, @DIFFtotal) /&lt;?char 13?&gt;
			CONVERT (FLOAT, @sizeTotal)) * 100, 2) AS [Percentage Changed]&lt;?char 13?&gt;
	</Value>
    </Constant>
  </Function>
  <Constant>
    <TypeClass>Numeric</TypeClass>
    <ObjType>System.Double</ObjType>
    <Value>30</Value>
  </Constant>
</Operator>', @is_name_condition=0, @obj_name=N'', @condition_id=@condition_id OUTPUT
Select @condition_id


Declare @condition_id int
EXEC msdb.dbo.sp_syspolicy_add_condition @name=N'User Databases', @description=N'Only run against user databases. ', @facet=N'Database', @expression=N'<Operator>
  <TypeClass>Bool</TypeClass>
  <OpType>GT</OpType>
  <Count>2</Count>
  <Attribute>
    <TypeClass>Numeric</TypeClass>
    <Name>ID</Name>
  </Attribute>
  <Constant>
    <TypeClass>Numeric</TypeClass>
    <ObjType>System.Double</ObjType>
    <Value>4</Value>
  </Constant>
</Operator>', @is_name_condition=0, @obj_name=N'', @condition_id=@condition_id OUTPUT
Select @condition_id


Declare @object_set_id int
EXEC msdb.dbo.sp_syspolicy_add_object_set @object_set_name=N'DAILY - % Change since last backup_ObjectSet', @facet=N'Database', @object_set_id=@object_set_id OUTPUT
Select @object_set_id

Declare @target_set_id int
EXEC msdb.dbo.sp_syspolicy_add_target_set @object_set_name=N'DAILY - % Change since last backup_ObjectSet', @type_skeleton=N'Server/Database', @type=N'DATABASE', @enabled=True, @target_set_id=@target_set_id OUTPUT
Select @target_set_id

EXEC msdb.dbo.sp_syspolicy_add_target_set_level @target_set_id=@target_set_id, @type_skeleton=N'Server/Database', @level_name=N'Database', @condition_name=N'User Databases', @target_set_level_id=0



Declare @policy_id int
EXEC msdb.dbo.sp_syspolicy_add_policy @name=N'DAILY - % Change since last backup', @condition_name=N'DAILY - % Change since last backup', @policy_category=N'Daily Health Check', @description=N'Returns % of database changed since the last full backup', @help_text=N'', @help_link=N'', @schedule_uid=N'00000000-0000-0000-0000-000000000000', @execution_mode=0, @is_enabled=False, @policy_id=@policy_id OUTPUT, @root_condition_name=N'', @object_set=N'DAILY - % Change since last backup_ObjectSet'
Select @policy_id


