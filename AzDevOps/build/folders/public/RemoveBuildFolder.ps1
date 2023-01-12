function Remove-BuildFolder
{
 [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High',
  HelpURI = 'https://github.com/Azure-Devops-PowerShell-Module/build/blob/master/docs/Remove-AzDevOpsBuildFolder.md#remove-azdevopsbuildfolder',
  PositionalBinding = $true)]
 [OutputType([string])]
 param (
  [Parameter(ValueFromPipeline, Mandatory = $false, ParameterSetName = 'Project')]
  [object]$Project,
  [Parameter(Mandatory = $false, ParameterSetName = 'ProjectId')]
  [Guid]$ProjectId,
  [Parameter(Mandatory = $true, ParameterSetName = 'Project')]
  [Parameter(Mandatory = $true, ParameterSetName = 'ProjectId')]
  [string]$Name,
  [Parameter(Mandatory = $false)]
  [ValidateSet('5.0-preview.2', '7.1-preview.2')]
  [string]$ApiVersion = '7.1-preview.2'
 )
 process
 {
  try
  {
   Write-Verbose "RemoveBuildFolder : Begin Processing";
   if ($PSCmdlet.ParameterSetName -eq 'Project')
   {
    Write-Verbose " ProjectId        : $($Project.Id)";
   }
   else
   {
    Write-Verbose " ProjectId        : $($ProjectId)";
   }
   Write-Verbose " Name             : $($Path)";
   Write-Verbose " ApiVersion       : $($ApiVersion)";
   $ErrorActionPreference = 'Stop'
   $Error.Clear()
   #
   # Are we connected
   #
   if ($Global:azDevOpsConnected)
   {
    if ($PSCmdlet.ParameterSetName -eq 'ProjectId')
    {
     $Project = Get-AzDevOpsProject -ProjectId $ProjectId -Verbose:$VerbosePreference;
    }
    $Folder = Get-AzDevOpsBuildFolder -Project $Project -Path $Name -Verbose:$VerbosePreference;
    $Uri = $Global:azDevOpsOrg + "$($Project.Id)/_apis/build/folders/?api-version=$($ApiVersion)&path=$($Folder.Path)"
    if ($PSCmdlet.ShouldProcess("Delete", "Remove Folder $($Name) from $($Project.name) Azure Devops Projects"))
    {
     Invoke-AdoEndpoint -Uri ([System.Uri]::new($Uri)) -Method DELETE -Headers $Global:azDevOpsHeader -Verbose:$VerbosePreference;
     $Project | Get-AzDevOpsBuildFolder -Verbose:$VerbosePreference;
    }
   }
  }
  catch
  {
   throw $_;
  }
 }
}