<#
.SYNOPSIS
    Tenant B: creates /sites/isms-<ini> for each student with the library "Dokumentace" and
    uploads the 7 fictional sample documents. The student becomes site owner, nothing more.

.DESCRIPTION
    Instructor script, run before the course (environment.md, go/no-go Tenant B). For every
    student in the CSV:

      1. Communication site /sites/isms-<ini>, title "ISMS <ini>", English (LCID 1033).
         Primary site collection administrator = -InstructorUpn (app-only creation needs an
         owner; the instructor stays the admin of every site, as day-5 go/no-go expects:
         "kazdy jen vlastnik + lektor").
      2. The student's Tenant B account (CSV column TenantBUserPrincipalName) is added to the
         site's Owners group -- site owner, no site collection admin, no tenant role.
      3. Document library "Dokumentace" (/Dokumentace).
      4. Upload of the .docx files from scripts/out/sample-docs (run Build-SampleDocs.ps1
         first). The script refuses to run unless exactly 7 documents are there, because the
         labs check for seven (content-type-hub step 5, ai-agents-tenant step 2).
      5. Report: members of Owners/Members/Visitors, with a warning when an "Everyone" style
         claim is present -- the day-5 negative test (canary) proves nothing on a site that
         everybody can read.

    Data boundary: only the fictional documents from this repo go to Tenant B. Nothing is
    copied from Tenant A (scenario-isms-vltava.md).

    Idempotent: an existing site, library, owner membership or file is kept. An existing
    file is NOT overwritten unless -Overwrite is given (a new version would also need a new
    Autofill run, which is billed again). Supports -WhatIf.

    The canary document KAN-<ini> is created by the student in the day-5 lab. Upload a
    canary built by Build-SampleDocs.ps1 only for the instructor fallback, with -CanaryPath.

    Authentication (PnP PowerShell): app-only certificate (-ClientId -Tenant -Thumbprint) or
    interactive (-Interactive -ClientId). Needs SharePoint Sites.FullControl.All (app-only)
    or SharePoint Administrator (interactive) in Tenant B. App registration details are in the
    instructor file outside the repo. Not verified on the course tenant (2026-10-17).

.PARAMETER TenantAdminUrl
    URL of the SharePoint admin center of Tenant B (from the instructor file).

.PARAMETER SiteUrlBase
    Managed path for the sites, e.g. https://<tenant>.sharepoint.com/sites

.PARAMETER InstructorUpn
    Instructor account in Tenant B; becomes the primary site collection administrator.

.PARAMETER CsvPath
    Student CSV with columns Initials and TenantBUserPrincipalName.
    Default scripts/students.local.csv.

.PARAMETER Initials
    Optional subset of students.

.PARAMETER DocsPath
    Folder with the built .docx files. Default scripts/out/sample-docs.

.PARAMETER CanaryPath
    Optional path to a canary .docx (instructor fallback only).

.PARAMETER Overwrite
    Replace files that already exist in the library.

.PARAMETER ClientId
    Client ID of the Entra app registration used by PnP PowerShell in Tenant B.

.PARAMETER Tenant
    Tenant B ID or primary domain. Required for app-only.

.PARAMETER Thumbprint
    Certificate thumbprint for app-only.

.PARAMETER Interactive
    Interactive sign-in instead of app-only.

.EXAMPLE
    ./Build-SampleDocs.ps1
    ./New-SampleDocsSite.ps1 -TenantAdminUrl <TenantAdminUrl> -SiteUrlBase https://<tenant>.sharepoint.com/sites -InstructorUpn <instructor-upn> -ClientId <app-id> -Tenant <tenant-id> -Thumbprint <thumbprint> -WhatIf
    Builds the documents, then shows what would be created on Tenant B.

.EXAMPLE
    ./New-SampleDocsSite.ps1 -TenantAdminUrl <TenantAdminUrl> -SiteUrlBase https://<tenant>.sharepoint.com/sites -InstructorUpn <instructor-upn> -ClientId <app-id> -Tenant <tenant-id> -Thumbprint <thumbprint>
    Creates all student sites and uploads the documents.

.EXAMPLE
    ./New-SampleDocsSite.ps1 -Initials lk -TenantAdminUrl <TenantAdminUrl> -SiteUrlBase https://<tenant>.sharepoint.com/sites -InstructorUpn <instructor-upn> -ClientId <app-id> -Interactive -CanaryPath "./out/canary/KAN-lk Kontrolni dokument.docx"
    Instructor's own fallback site (CSV row with the instructor's initials, here lk) with the
    canary document built by Build-SampleDocs.ps1 -CanaryInitials lk.
#>
[CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'AppOnly')]
param(
    [Parameter(Mandatory)][ValidatePattern('^https://[^/]+/?$')][string]$TenantAdminUrl,
    [Parameter(Mandatory)][ValidatePattern('^https://[^/]+/sites/?$')][string]$SiteUrlBase,
    [Parameter(Mandatory)][ValidatePattern('^[^@\s]+@[^@\s]+$')][string]$InstructorUpn,
    [string]$CsvPath = (Join-Path $PSScriptRoot 'students.local.csv'),
    [string[]]$Initials,
    [string]$DocsPath = (Join-Path $PSScriptRoot 'out/sample-docs'),
    [string]$CanaryPath,
    [switch]$Overwrite,
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
$students = Import-StudentCsv -Path $CsvPath -Initials $Initials -RequiredColumns @('Initials', 'TenantBUserPrincipalName')

$docs = @(Get-ChildItem -Path $DocsPath -Filter '*.docx' -File -ErrorAction SilentlyContinue)
if ($docs.Count -ne 7) {
    throw "Expected exactly 7 .docx files in $DocsPath, found $($docs.Count). Run Build-SampleDocs.ps1 first."
}
if ($CanaryPath) {
    if (-not (Test-Path -LiteralPath $CanaryPath)) { throw "Canary file not found: $CanaryPath" }
    $docs += Get-Item -LiteralPath $CanaryPath
}

Assert-SameTenantHost -TenantAdminUrl $TenantAdminUrl -SiteUrlBase $SiteUrlBase
$auth = @{ ClientId = $ClientId; Tenant = $Tenant; Thumbprint = $Thumbprint; Interactive = $Interactive }
$admin = Connect-CoursePnP -Url $TenantAdminUrl.TrimEnd('/') @auth
$lib = $schema.sampleDocs

foreach ($s in $students) {
    $ini = $s.Initials
    $siteUrl = '{0}/{1}' -f $SiteUrlBase.TrimEnd('/'), ($schema.site.urlFormat -f $ini)
    Write-Host ''
    Write-Host "== $ini -> $siteUrl ==" -ForegroundColor Cyan

    # ---- Site ----------------------------------------------------------------------------
    if (-not (Get-PnPTenantSite -Identity $siteUrl -Connection $admin -ErrorAction SilentlyContinue)) {
        if (-not $PSCmdlet.ShouldProcess($siteUrl, "Create communication site (admin $InstructorUpn)")) {
            Write-Host 'Site does not exist (WhatIf) -- skipping the rest for this student.' -ForegroundColor DarkGray
            continue
        }
        if (Get-PnPTenantDeletedSite -Identity $siteUrl -Connection $admin -ErrorAction SilentlyContinue) {
            throw "$siteUrl is in the tenant recycle bin. Purge it first (Remove-CourseArtifacts.ps1 -TenantLabel B -PurgeDeletedSites)."
        }
        New-PnPSite -Type CommunicationSite -Title ($schema.site.titleFormat -f $ini) -Url $siteUrl `
            -Owner $InstructorUpn -Lcid $schema.site.lcid `
            -TimeZone UTCPLUS0100_BELGRADE_BRATISLAVA_BUDAPEST_LJUBLJANA_PRAGUE -Connection $admin | Out-Null
        $ready = $false
        for ($i = 0; $i -lt 40 -and -not $ready; $i++) {
            if (Get-PnPTenantSite -Identity $siteUrl -Connection $admin -ErrorAction SilentlyContinue) { $ready = $true }
            else { Start-Sleep -Seconds 15 }
        }
        if (-not $ready) { throw "Site $siteUrl not available after 10 minutes." }
        Write-Host "Created site: $siteUrl" -ForegroundColor Green
    }
    else {
        Write-Host "Site exists: $siteUrl" -ForegroundColor DarkGray
    }

    $conn = Connect-CoursePnP -Url $siteUrl @auth

    # ---- Student = owner (Owners group), not site collection admin -----------------------
    $owners = Get-PnPGroup -AssociatedOwnerGroup -Connection $conn
    $ownerLogins = @(Get-PnPGroupMember -Group $owners -Connection $conn | ForEach-Object { $_.LoginName })
    if ($ownerLogins | Where-Object { $_ -like "*|$($s.TenantBUserPrincipalName)" }) {
        Write-Host "Owner exists: $($s.TenantBUserPrincipalName)" -ForegroundColor DarkGray
    }
    elseif ($PSCmdlet.ShouldProcess("$($owners.Title) <- $($s.TenantBUserPrincipalName)", 'Add site owner')) {
        Add-PnPGroupMember -LoginName $s.TenantBUserPrincipalName -Group $owners -Connection $conn
        Write-Host "Added owner: $($s.TenantBUserPrincipalName)" -ForegroundColor Green
    }

    # ---- Library -------------------------------------------------------------------------
    $list = Get-PnPList -Identity $lib.libraryUrl -Connection $conn
    if (-not $list) {
        if ($PSCmdlet.ShouldProcess($lib.libraryUrl, 'Create document library')) {
            New-PnPList -Title $lib.libraryCreateTitle -Template DocumentLibrary -Url $lib.libraryUrl -OnQuickLaunch -Connection $conn | Out-Null
            Write-Host "Created library: $($lib.libraryUrl)" -ForegroundColor Green
        }
        else { continue }
    }
    else { Write-Host "Library exists: $($lib.libraryUrl)" -ForegroundColor DarkGray }

    # ---- Upload --------------------------------------------------------------------------
    $sitePath = ([uri]$siteUrl).AbsolutePath.TrimEnd('/')
    foreach ($doc in $docs) {
        $serverRelative = "$sitePath/$($lib.libraryUrl)/$($doc.Name)"
        $exists = Get-PnPFile -Url $serverRelative -AsListItem -Connection $conn -ErrorAction SilentlyContinue
        if ($exists -and -not $Overwrite) {
            Write-Host "File exists: $($doc.Name)" -ForegroundColor DarkGray
            continue
        }
        if ($PSCmdlet.ShouldProcess($serverRelative, 'Upload')) {
            Add-PnPFile -Path $doc.FullName -Folder $lib.libraryUrl -Connection $conn | Out-Null
            Write-Host "Uploaded: $($doc.Name)" -ForegroundColor Green
        }
    }

    # ---- Report: who can read the site ---------------------------------------------------
    foreach ($g in @($owners, (Get-PnPGroup -AssociatedMemberGroup -Connection $conn), (Get-PnPGroup -AssociatedVisitorGroup -Connection $conn))) {
        $members = @(Get-PnPGroupMember -Group $g -Connection $conn)
        Write-Host ("  {0,-28} {1}" -f $g.Title, (($members | ForEach-Object { $_.Title }) -join '; '))
        if ($members | Where-Object { $_.LoginName -match 'spo-grid-all-users|c:0\(\.s\|true' }) {
            Write-Warning "$($g.Title) contains an Everyone-style claim -- the day-5 canary test would prove nothing. Remove it."
        }
    }
}

Write-Host ''
Write-Host 'Go/no-go: open one site as a student account; the library must show 7 documents and Site permissions must list the student as owner.' -ForegroundColor DarkGray
