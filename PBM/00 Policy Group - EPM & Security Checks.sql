Declare @policy_category_id int
EXEC msdb.dbo.sp_syspolicy_add_policy_category @name=N'Daily Health Check', @policy_category_id=@policy_category_id OUTPUT, @mandate_database_subscriptions=True
Select @policy_category_id

