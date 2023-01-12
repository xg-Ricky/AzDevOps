function Update-Team
{
 [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low',
  HelpURI = 'https://github.com/Azure-Devops-PowerShell-Module/teams/blob/master/docs/Update-AzDevOpsTeam.md#update-azdevopsteam',
  PositionalBinding = $true)]
 [OutputType([Object])]
 param (
  [Parameter(Mandatory = $false)]
  [string]$Name,
  [Parameter(Mandatory = $false)]
  [string]$Description,
  [Parameter(ValueFromPipeline)]
  [object]$Team,
  [Parameter(Mandatory = $false)]
  [ValidateSet('5.1-preview.3', '7.1-preview.3')]
  [string]$ApiVersion = '7.1-preview.3'
 )

 begin
 {
  Write-Verbose "UpdateTeam   : Process Record";
  Write-Verbose " Name        : $($Name)";
  Write-Verbose " Description : $($Description)";
  Write-Verbose " TeamId      : $($Team.Id)";
  Write-Verbose " ApiVersion  : $($ApiVersion)";
  try
  {
   $ErrorActionPreference = 'Stop';
   $Error.Clear();
   #
   # Are we connected
   #
   if ($Global:azDevOpsConnected)
   {
    $Body = @{
     "name"        = $Name
     "description" = $Description
    } | ConvertTo-Json -Depth 5 -Compress;

    $Uri = $Global:azDevOpsOrg + "_apis/projects/$($Team.projectid)/teams/$($Team.id)?api-version=$($ApiVersion)";
    if ($PSCmdlet.ShouldProcess("Update", "Update new team in $($Project.name) Azure Devops Projects"))
    {
     return (Invoke-AdoEndpoint -Uri ([System.Uri]::new($Uri)) -Method PATCH -Body $Body -ContentType "application/json" -Headers $Global:azDevOpsHeader -Verbose:$VerbosePreference);
    }
   }
  }
  catch
  {
   throw $_;
  }
 }
}