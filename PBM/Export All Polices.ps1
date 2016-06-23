<#
 
Export All PBM
 
#>
 
IF (!(Get-Module -Name sqlps))
    {
        Push-Location
        Import-Module sqlps -DisableNameChecking
        Pop-Location
    }
 
## Define Server holding policies you wish to export
$SourcePolicyServer = "LON-SQLMON01"
## Define locations for policy group and policy
$PolicyRoot = "SQLSERVER:\sqlpolicy\$SourcePolicyServer\default\policies"
$PolicyCateRoot = "SQLSERVER:\sqlpolicy\$SourcePolicyServer\default\policycategories"
## Define where to export SQL Script per policy
$DistinationFolder = "C:\SourceTree\DBA\Scripts\Monitoring\PBM\"
 
## Export All user made Policy groups
Set-Location $PolicyCateRoot
## This maybe wrong! works on SQL 2014 to remove premade groups (couldnt find a way to find out if object was made by user)
$UserMadePolicyGroups = Get-ChildItem | Where-Object {$_.ID -gt 10}
Pop-Location
 
foreach ($UserPolicyGroup in $UserMadePolicyGroups)
    {
        $UserPolicyGroupName = $UserPolicyGroup.Name
        write-host "Exporting Policy Category : $UserPolicyGroupName"
        $OutputFile = $DistinationFolder + "00 Policy Group - " + $UserPolicyGroupName + ".sql"
        $PolicyGroupScript = $UserMadePolicyGroups[0].ScriptCreate() 
        $PolicyGroupScript.GetScript() | Out-File $OutputFile
    }
 
 
## Export All the Policies
Push-Location
Set-Location $PolicyRoot
$Policies = Get-ChildItem
Pop-Location
 
foreach ($Policy in $Policies)
    {
        $PolicyName = $Policy.Name
        write-host "Exporting Policy : $PolicyName"
        $OutputFile = $DistinationFolder + "01 Policy - " + $PolicyName + ".sql"
        $ExportPolicyScript = $Policy.ScriptCreateWithDependencies()
        $ExportPolicyScript.Getscript() | Out-File $OutputFile
    }