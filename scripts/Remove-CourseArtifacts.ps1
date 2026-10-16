<#
.SYNOPSIS
    Cleanup after a course run: deletes the per-student sites, groups and test users that
    the course scripts created, and prints a checklist of everything that must be removed
    by hand.

.DESCRIPTION
    Instructor script, run after the course. Conservative by design:

    * Targets come from the student CSV (exact names per initials), never from a wildcard.
      Tenant A is shared with another course (SPO_DEV_1), so anything else matching
      isms-* / test-* is only LISTED as "not in CSV, not touched".
    * ConfirmImpact is High: every deletion asks for confirmation unless -Confirm:$false is
      given. Run with -WhatIf first.
    * -TenantLabel (A or B) is mandatory and selects WHAT is deleted (A: sites, groups, users;
      B: sites). It does not identify the tenant: the site URLs isms-<ini> are the same on A
      and B, so the connection decides WHERE. The script checks that -SiteUrlBase belongs to
      the same tenant as -TenantAdminUrl, prints the connected URLs, and -WhatIf shows the
      full target list -- read it before the real run.

    -TenantLabel A deletes, per student in the CSV:
      - site /sites/isms-<ini>              (Remove-PnPTenantSite)
      - Entra group isms-<ini>-users        (Remove-MgGroup; soft delete, restorable 30 days)
      - user test-<ini>@<student domain>    (Remove-MgUser; soft delete, restorable 30 days)

    -TenantLabel B deletes, per student in the CSV:
      - site /sites/isms-<ini>              (with the library Dokumentace, Agent Assets and
                                             the Skill's SKILL.md)

    Deleted sites go to the tenant recycle bin and keep their URL reserved for 93 days; the
    next run's day-1 checkpoint ("address without numeric suffix") then fails.
    -PurgeDeletedSites removes the sites without the recycle bin and also purges course
    URLs already sitting in the recycle bin. Irreversible.

    What the script does NOT delete (checklist only):
      Tenant A: sensitivity labels and label policies (GOC248-*, <ini>-*), retention labels
      and policies, records (locked records block site deletion), DLP and auto-labeling
      policies (<ini>-*), Conditional Access policies <ini>-CA0x, PIM for Groups settings
      and the student groups <ini>-isms-admins, Audit search jobs, content types <ini>-* in
      category <ini>-ISMS of the Content Type Hub, Compliance Manager assessments (assessment
      groups cannot be deleted in Compliance Manager -- they stay, document it).
      Tenant B: students' agents <ini>-ISMS Asistent, Autofill site scope, PAYG billing
      policies and budgets, user.NN account reset.
    Tenant-wide security and compliance policies are deliberately not deleted by script:
    a wrong match removes another course's or the tenant's own policy.
    Order and pitfalls of the Purview cleanup: day-3/sensitivity-labels/guide-priprava-tenantu.md
    (section "Uklid po kurzu"). The checklist is printed and saved to scripts/out/.

    Site deletion that fails (retention policy, records, holds) is reported, never forced.

    Authentication: PnP PowerShell for SharePoint (admin center connection) and, on Tenant A,
    Microsoft Graph PowerShell SDK for groups and users. Same app registration parameters for
    both: app-only certificate (-ClientId -Tenant -Thumbprint) or interactive
    (-Interactive -ClientId -Tenant). Graph application permissions: Group.ReadWrite.All,
    User.ReadWrite.All. Not verified on the course tenant (2026-10-17).

.PARAMETER TenantLabel
    A or B -- which course tenant this run cleans.

.PARAMETER TenantAdminUrl
    URL of the SharePoint admin center of the tenant (instructor file).

.PARAMETER SiteUrlBase
    Managed path of the sites, e.g. https://<tenant>.sharepoint.com/sites

.PARAMETER CsvPath
    Student CSV used for the run. Default scripts/students.local.csv.

.PARAMETER Initials
    Optional subset of students.

.PARAMETER UserDomain
    Domain of the test users test-<ini> (Tenant A). Default: the domain of the student's
    account. Use the same value as with New-CourseScope.ps1 -UserDomain.

.PARAMETER PurgeDeletedSites
    Delete sites without the recycle bin and purge course URLs from the recycle bin.

.PARAMETER ClientId
    Client ID of the app registration in the selected tenant.

.PARAMETER Tenant
    Tenant ID or primary domain of the selected tenant (always required).

.PARAMETER Thumbprint
    Certificate thumbprint for app-only.

.PARAMETER Interactive
    Interactive sign-in instead of app-only.

.PARAMETER OutputPath
    Folder for the checklist file. Default scripts/out.

.EXAMPLE
    ./Remove-CourseArtifacts.ps1 -TenantLabel A -TenantAdminUrl <TenantAdminUrl> -SiteUrlBase https://<tenant>.sharepoint.com/sites -ClientId <app-id> -Tenant <tenant-id> -Thumbprint <thumbprint> -WhatIf
    Lists what would be deleted on Tenant A and prints the manual checklist.

.EXAMPLE
    ./Remove-CourseArtifacts.ps1 -TenantLabel A -TenantAdminUrl <TenantAdminUrl> -SiteUrlBase https://<tenant>.sharepoint.com/sites -ClientId <app-id> -Tenant <tenant-id> -Thumbprint <thumbprint> -PurgeDeletedSites
    Deletes the course sites, groups and test users on Tenant A, asking before each
    deletion, and frees the site URLs for the next run.

.EXAMPLE
    ./Remove-CourseArtifacts.ps1 -TenantLabel B -TenantAdminUrl <TenantAdminUrl> -SiteUrlBase https://<tenant>.sharepoint.com/sites -ClientId <app-id> -Tenant <tenant-id> -Interactive -Initials pm
    Deletes only pm's site on Tenant B (e.g. to rebuild it with New-SampleDocsSite.ps1).
#>
[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High', DefaultParameterSetName = 'AppOnly')]
param(
    [Parameter(Mandatory)][ValidateSet('A', 'B')][string]$TenantLabel,
    [Parameter(Mandatory)][ValidatePattern('^https://[^/]+/?$')][string]$TenantAdminUrl,
    [Parameter(Mandatory)][ValidatePattern('^https://[^/]+/sites/?$')][string]$SiteUrlBase,
    [string]$CsvPath = (Join-Path $PSScriptRoot 'students.local.csv'),
    [string[]]$Initials,
    [ValidatePattern('^[a-z0-9.-]+\.[a-z]{2,}$')][string]$UserDomain,
    [switch]$PurgeDeletedSites,
    [Parameter(Mandatory)][ValidatePattern('^[0-9a-fA-F-]{36}$')][string]$ClientId,
    [Parameter(Mandatory)][string]$Tenant,
    [Parameter(Mandatory, ParameterSetName = 'AppOnly')][string]$Thumbprint,
    [Parameter(Mandatory, ParameterSetName = 'Interactive')][switch]$Interactive,
    [string]$OutputPath = (Join-Path $PSScriptRoot 'out')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib/CourseHelpers.ps1')

$modules = @('PnP.PowerShell')
if ($TenantLabel -eq 'A') { $modules += 'Microsoft.Graph.Authentication', 'Microsoft.Graph.Users', 'Microsoft.Graph.Groups' }
Assert-CourseModule -Name $modules

$schema = Get-CourseSchema -ScriptRoot $PSScriptRoot
$required = if ($TenantLabel -eq 'A') { @('Initials', 'UserPrincipalName') } else { @('Initials') }
$students = Import-StudentCsv -Path $CsvPath -Initials $Initials -RequiredColumns $required
$knownInitials = @($students | ForEach-Object { $_.Initials })

Assert-SameTenantHost -TenantAdminUrl $TenantAdminUrl -SiteUrlBase $SiteUrlBase
$admin = Connect-CoursePnP -Url $TenantAdminUrl.TrimEnd('/') -ClientId $ClientId -Tenant $Tenant -Thumbprint $Thumbprint -Interactive:$Interactive

if ($TenantLabel -eq 'A') {
    if ($Interactive) {
        Connect-MgGraph -ClientId $ClientId -TenantId $Tenant -Scopes 'Group.ReadWrite.All', 'User.ReadWrite.All' -NoWelcome
    }
    else {
        Connect-MgGraph -ClientId $ClientId -TenantId $Tenant -CertificateThumbprint $Thumbprint -NoWelcome
    }
    Write-Host "Graph connected to tenant $((Get-MgContext).TenantId)" -ForegroundColor Cyan
}

$report = New-Object System.Collections.Generic.List[object]
function Add-Report { param([string]$Object, [string]$Result) $report.Add([pscustomobject]@{ Object = $Object; Result = $Result }) }
function ConvertTo-ODataLiteral { param([string]$Value) $Value.Replace("'", "''") }

# ---- Sites (A and B) -----------------------------------------------------------------------
foreach ($s in $students) {
    $url = '{0}/{1}' -f $SiteUrlBase.TrimEnd('/'), ($schema.site.urlFormat -f $s.Initials)
    $site = Get-PnPTenantSite -Identity $url -Connection $admin -ErrorAction SilentlyContinue
    if ($site) {
        $action = if ($PurgeDeletedSites) { 'Delete site permanently (no recycle bin)' } else { 'Delete site (to tenant recycle bin)' }
        if ($PSCmdlet.ShouldProcess($url, $action)) {
            try {
                if ($PurgeDeletedSites) { Remove-PnPTenantSite -Url $url -Force -SkipRecycleBin -Connection $admin }
                else { Remove-PnPTenantSite -Url $url -Force -Connection $admin }
                Add-Report $url 'deleted'
            }
            catch {
                Add-Report $url "NOT deleted: $($_.Exception.Message) -- retention policy, record or hold? See guide-priprava-tenantu.md"
            }
        }
        else { Add-Report $url 'would be deleted' }
        continue
    }

    $deleted = Get-PnPTenantDeletedSite -Identity $url -Connection $admin -ErrorAction SilentlyContinue
    if ($deleted -and $PurgeDeletedSites) {
        if ($PSCmdlet.ShouldProcess($url, 'Purge from tenant recycle bin')) {
            try { Clear-PnPTenantRecycleBinItem -Url $url -Force -Wait -Connection $admin; Add-Report $url 'purged from recycle bin' }
            catch { Add-Report $url "NOT purged: $($_.Exception.Message)" }
        }
        else { Add-Report $url 'would be purged from recycle bin' }
    }
    elseif ($deleted) { Add-Report $url 'in recycle bin (URL reserved) -- use -PurgeDeletedSites' }
    else { Add-Report $url 'not found' }
}

# ---- Groups and users (A only) -------------------------------------------------------------
if ($TenantLabel -eq 'A') {
    foreach ($s in $students) {
        $groupName = "isms-$($s.Initials)-users"
        $groups = @(Get-MgGroup -Filter "displayName eq '$(ConvertTo-ODataLiteral $groupName)'" -Property 'id,displayName')
        if ($groups.Count -eq 0) { Add-Report $groupName 'not found' }
        elseif ($groups.Count -gt 1) { Add-Report $groupName 'NOT deleted: more than one group with this name -- resolve by hand' }
        elseif ($PSCmdlet.ShouldProcess($groupName, 'Delete Entra group (soft delete, 30 days)')) {
            Remove-MgGroup -GroupId $groups[0].Id
            Add-Report $groupName 'deleted (soft)'
        }
        else { Add-Report $groupName 'would be deleted' }

        $domain = if ($UserDomain) { $UserDomain } else { ($s.UserPrincipalName -split '@')[1] }
        $testUpn = 'test-{0}@{1}' -f $s.Initials, $domain
        $users = @(Get-MgUser -Filter "userPrincipalName eq '$(ConvertTo-ODataLiteral $testUpn)'" -Property 'id,userPrincipalName')
        if ($users.Count -eq 0) { Add-Report $testUpn 'not found' }
        elseif ($PSCmdlet.ShouldProcess($testUpn, 'Delete test user (soft delete, 30 days)')) {
            Remove-MgUser -UserId $users[0].Id
            Add-Report $testUpn 'deleted (soft)'
        }
        else { Add-Report $testUpn 'would be deleted' }

        $adminGroup = "$($s.Initials)-isms-admins"
        if (@(Get-MgGroup -Filter "displayName eq '$(ConvertTo-ODataLiteral $adminGroup)'" -Property 'id').Count -gt 0) {
            Add-Report $adminGroup 'exists -- manual: remove PIM for Groups settings, then delete the group'
        }
    }
}

# ---- Report-only scan: course-like objects not in the CSV ----------------------------------
$siteRx = '/sites/isms-(?<ini>[a-z]+)$'
foreach ($site in @(Get-PnPTenantSite -Filter "Url -like 'isms-'" -Connection $admin)) {
    $m = [regex]::Match($site.Url, $siteRx)
    if ($m.Success -and $knownInitials -notcontains $m.Groups['ini'].Value) {
        Add-Report $site.Url 'not in CSV -- NOT touched (other course or older run?)'
    }
}
if ($TenantLabel -eq 'A') {
    foreach ($g in @(Get-MgGroup -Filter "startswith(displayName,'isms-')" -All -Property 'id,displayName')) {
        if ($g.DisplayName -match '^isms-(?<ini>[a-z]+)-users$' -and $knownInitials -notcontains $Matches['ini']) {
            Add-Report $g.DisplayName 'not in CSV -- NOT touched'
        }
    }
    foreach ($u in @(Get-MgUser -Filter "startswith(userPrincipalName,'test-')" -All -Property 'id,userPrincipalName')) {
        if ($u.UserPrincipalName -match '^test-(?<ini>[a-z]+)@' -and $knownInitials -notcontains $Matches['ini']) {
            Add-Report $u.UserPrincipalName 'not in CSV -- NOT touched'
        }
    }
}

Write-Host ''
$report | Format-Table -AutoSize -Wrap | Out-Host

# ---- Manual checklist ----------------------------------------------------------------------
$iniList = ($knownInitials | ForEach-Object { "$_-" }) -join ', '
$checklist = if ($TenantLabel -eq 'A') {
    @"
# GOC248 cleanup checklist -- Tenant A ($(Get-Date -Format 'yyyy-MM-dd'))
Student prefixes: $iniList
Order matters (records and retention block deletion) -- day-3/sensitivity-labels/guide-priprava-tenantu.md.

- [ ] Purview Data Lifecycle Management: student retention policies (<ini>-*) removed from sites or deleted
- [ ] Records: unlocked records locked again, then retention labels removed from locked records as site admin
- [ ] Retention label policies, then retention labels: student labels (<ini>-*) and course label 'GOC248 ISMS zaznam' policy
- [ ] Sensitivity labels: student labels removed from label policies, wait, then delete; course labels GOC248-* and policy 'GOC248 - kurzovni stitky' -- keep or remove per instructor file
- [ ] DLP and auto-labeling policies with student prefixes; LEKTOR-DLP-demo
- [ ] Conditional Access: <ini>-CA01..CA04 (check nothing else references break-glass exclusions)
- [ ] PIM for Groups: settings and assignments on <ini>-isms-admins; then delete those groups
- [ ] Audit search jobs <ini>-* (optional)
- [ ] Content Type Hub: content types in categories <ini>-ISMS (unpublish first); keep 'VS ISMS' columns for the next run
- [ ] Compliance Manager: student assessments -- assessment groups cannot be deleted; rename or document
- [ ] Re-run this script with -PurgeDeletedSites if sites went to the recycle bin
- [ ] Student accounts: remove Global Administrator, reset passwords and MFA methods (account lifecycle, instructor file)
- [ ] Never touch the break-glass accounts
"@
}
else {
    @"
# GOC248 cleanup checklist -- Tenant B ($(Get-Date -Format 'yyyy-MM-dd'))
Student prefixes: $iniList

- [ ] Agents <ini>-ISMS Asistent: remove in the Microsoft 365 admin center (agent inventory) or ask the owners to delete them
- [ ] Shared agent links: no agent remains shared with 'Can chat' outside the course
- [ ] Autofill / Document processing: remove isms-* sites from the selected-sites scope (or switch scope back)
- [ ] Copilot PAYG and Document processing PAYG: billing policies, budgets and alerts back to the pre-course state; record actual spend
- [ ] user.NN accounts: reset passwords and MFA methods; release the range for the next course (GOC224)
- [ ] Re-run this script with -PurgeDeletedSites if sites went to the recycle bin
"@
}
Write-Host $checklist
New-Item -ItemType Directory -Path $OutputPath -Force -WhatIf:$false | Out-Null
$file = Join-Path $OutputPath ("cleanup-checklist-{0}-{1:yyyyMMdd-HHmmss}.txt" -f $TenantLabel, (Get-Date))
Set-Content -LiteralPath $file -Value $checklist -Encoding UTF8 -WhatIf:$false
Write-Host "Checklist saved: $file" -ForegroundColor Cyan
