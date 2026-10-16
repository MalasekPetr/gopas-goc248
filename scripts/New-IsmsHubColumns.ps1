<#
.SYNOPSIS
    Tenant A: creates the shared site columns of category "VS ISMS" in the Content Type Hub.

.DESCRIPTION
    Instructor script, run once before the course (go/no-go of content-type-hub, day before
    day 2). Creates in /sites/ContentTypeHub the six site columns the students add to their
    own content types <ini>-Politika, <ini>-Smernice and <ini>-Zaznam. Schema is binding per
    day-2/content-type-hub/README.md (section "Sdilene sloupce v hubu"):

      Internal name      Type                     Display name (Czech)
      DocOwner           Person (people only)     Vlastnik dokumentu
      EffectiveDate      Date only                Datum ucinnosti
      DocNextReview      Date only                Datum pristi revize
      DocClassification  Choice, 4 values         Klasifikace
      ParentPolicy       Single line of text      Nadrazena politika
      RecordDate         Date only                Datum vzniku zaznamu

    The Czech display names and choice values come from scripts/schema/isms-schema.json.
    Every column is created with Required = FALSE; "required" is set per content type by
    the students (lab step 2-3), not on the site column.

    Each column is created with the ASCII internal name as its display name first and renamed
    afterwards -- the same order the labs use, so no internal name ever gets _x00 encoding.

    Idempotent: an existing column is never modified, only reported. Supports -WhatIf.
    It does NOT create or publish content types; that is the students' tenant step [T].

    Authentication (PnP PowerShell): app-only with certificate (-ClientId -Tenant -Thumbprint)
    or interactive (-Interactive -ClientId). The app registration and certificate are
    described in the instructor file outside this repo. The account or app needs write access
    to the Content Type Hub site (SharePoint Administrator or Sites.FullControl.All app-only).

.PARAMETER HubUrl
    Full URL of the Content Type Hub, e.g. https://<tenant>.sharepoint.com/sites/ContentTypeHub

.PARAMETER ClientId
    Client ID of the Entra app registration used by PnP PowerShell in Tenant A.

.PARAMETER Tenant
    Tenant A ID or primary domain. Required for app-only.

.PARAMETER Thumbprint
    Certificate thumbprint (CurrentUser\My or LocalMachine\My) for app-only.

.PARAMETER Interactive
    Interactive sign-in instead of app-only.

.EXAMPLE
    ./New-IsmsHubColumns.ps1 -HubUrl https://<tenant>.sharepoint.com/sites/ContentTypeHub -ClientId <app-id> -Tenant <tenant-id> -Thumbprint <thumbprint>
    Creates the six columns app-only.

.EXAMPLE
    ./New-IsmsHubColumns.ps1 -HubUrl https://<tenant>.sharepoint.com/sites/ContentTypeHub -ClientId <app-id> -Interactive -WhatIf
    Shows what would be created, signing in interactively.

.EXAMPLE
    ./New-IsmsHubColumns.ps1 -HubUrl https://<tenant>.sharepoint.com/sites/ContentTypeHub -ClientId <app-id> -Interactive
    Re-run after day 2: creates nothing new and prints the current state of the VS ISMS
    columns, so a student's accidental change (renamed column, new choice) is visible.
#>
[CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'AppOnly')]
param(
    [Parameter(Mandatory)][ValidatePattern('^https://[^/]+/sites/ContentTypeHub/?$')][string]$HubUrl,
    [Parameter(Mandatory)][ValidatePattern('^[0-9a-fA-F-]{36}$')][string]$ClientId,
    [Parameter(Mandatory, ParameterSetName = 'AppOnly')]
    [Parameter(ParameterSetName = 'Interactive')][string]$Tenant,
    [Parameter(Mandatory, ParameterSetName = 'AppOnly')][string]$Thumbprint,
    [Parameter(Mandatory, ParameterSetName = 'Interactive')][switch]$Interactive
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib/CourseHelpers.ps1')

Assert-CourseModule -Name 'PnP.PowerShell'
$schema = Get-CourseSchema -ScriptRoot $PSScriptRoot
$group = $schema.hubColumns.group

$conn = Connect-CoursePnP -Url $HubUrl.TrimEnd('/') -ClientId $ClientId -Tenant $Tenant -Thumbprint $Thumbprint -Interactive:$Interactive

# ---- 1. Create missing columns with ASCII display names ------------------------------------
$created = @()
foreach ($field in $schema.hubColumns.fields) {
    $before = Get-PnPField -Identity $field.name -Connection $conn -ErrorAction SilentlyContinue
    if ($before) { Write-Host "Column exists: $($field.name) (not changed)" -ForegroundColor DarkGray; continue }
    if (Add-CourseField -Field $field -Connection $conn -Caller $PSCmdlet -Group $group) { $created += $field }
}

# ---- 2. Rename only the columns created in this run ----------------------------------------
# Existing columns are never renamed back: a student's change must stay visible in the report.
foreach ($field in $created) {
    Rename-CourseField -InternalName $field.name -DisplayName $field.displayName -Connection $conn -Caller $PSCmdlet
}

# ---- 3. Report -----------------------------------------------------------------------------
Write-Host ''
Write-Host "Columns in group '$group':" -ForegroundColor Cyan
$problems = 0
foreach ($field in $schema.hubColumns.fields) {
    $f = Get-PnPField -Identity $field.name -Connection $conn -ErrorAction SilentlyContinue
    if (-not $f) {
        Write-Host ("  {0,-18} missing" -f $field.name) -ForegroundColor Yellow
        $problems++
        continue
    }
    $notes = @()
    if ($f.Group -cne $group) { $notes += "group '$($f.Group)'" }
    if ($f.Title -cne $field.displayName) { $notes += 'display name differs from schema' }
    if ($f.Required) { $notes += 'Required=TRUE on the site column' }
    if ($field.type -eq 'Choice') {
        try {
            $actual = @(([xml]$f.SchemaXml).SelectNodes('//CHOICE') | ForEach-Object { $_.InnerText })
            if (($actual -join '|') -cne ($field.choices -join '|')) { $notes += 'choices differ from schema' }
        }
        catch { $notes += 'choices not readable -- check by hand' }
    }
    $status = if ($notes) { 'CHECK: ' + ($notes -join ', ') } else { 'OK' }
    if ($notes) { $problems++ }
    Write-Host ("  {0,-18} {1,-10} {2}" -f $f.InternalName, $f.TypeAsString, $status)
}
if ($problems -gt 0) {
    Write-Warning "$problems column(s) need attention. Fix by hand in the Content type gallery; this script never changes existing columns."
}
