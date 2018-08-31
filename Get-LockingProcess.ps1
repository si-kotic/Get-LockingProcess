<#

.SYNOPSIS

Identifies which processes are locking a specified file.

Written by Simon Brown (2013).

.DESCRIPTION

Use Get-LockingProcess to identify which processes are currently

accessing and therefore locking a specified file.

.PARAMETER lockedfile

The file against which you would like to run the script.

#>
Function Get-LockingProcess {
[CmdletBinding(SupportsShouldProcess=$true)]
Param (
[Parameter(Mandatory=$true,ValueFromPipeline=$true,Position=1)]$LockedFile
)

$table = New-Object system.Data.DataTable “Processes”

$col1 = New-Object system.Data.DataColumn ProcessName,([string])
$col2 = New-Object system.Data.DataColumn ProcessID,([string])

$table.columns.add($col1)
$table.columns.add($col2)

Get-Process | Foreach-Object {
	$Process = $_
	$_.Modules | ForEach-Object {
		IF ($_.FileName -eq $LockedFile)
		{
			$row = $table.NewRow()
			$row.ProcessName = $Process.Name
			$row.ProcessID = $Process.ID
			$table.rows.add($row)
			#$Process.Name + " PID: " + $Process.id
		}
	}
}

$table

}