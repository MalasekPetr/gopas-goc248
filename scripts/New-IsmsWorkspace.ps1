<#
.SYNOPSIS
    Tenant A: catch-up script. Creates or completes a student's ISMS workspace
    /sites/isms-<ini> in the state after day 1 or after day 2.

.DESCRIPTION
    Instructor script for students who lost a day (scenario-isms-vltava.md, "Kdo nestihne").
    Builds exactly the schema the labs build, from scripts/schema/isms-schema.json:

    -AfterDay 1 (isms-design-m365):
      - Communication site /sites/isms-<ini>, title "ISMS <ini>" (canonical name table),
        language English (LCID 1033), owner = the student.
      - Entra security group isms-<ini>-users added to the site's Members group.
      - List SoA (/Lists/SoA): Title renamed to the Czech display name, columns Requirement,
        Applicable, Justification, Capability, Evidence, Module, Tenant -- created with ASCII
        internal names, renamed to Czech display names afterwards.

    -AfterDay 2 (document-libraries-governance, lists-registers-workflow), in addition:
      - Library ControlledDocs (/ControlledDocs) with Czech display title; major and minor
        versions, content approval, drafts visible only to approvers (and authors),
        check-out not required, version limit NOT touched (inherited from the organization,
        as in the lab). Unique permissions: site owners Full Control (kept), Members and
        Visitors removed, isms-<ini>-users Read, test-<ini> Contribute.
      - Lists AssetRegister, RiskRegister, IncidentLog with the binding schemas from
        day-2/lists-registers-workflow/reseni-registry-revize.md: lookups to Asset Register
        (RiskAsset single, AffectedAssets multi), calculated RiskScore =[Likelihood]*[Impact]
        (Number, 0 decimals) and ReportDeadline =[ClassifiedAt]+1 (Date and Time). Calculated
        columns are created while all names are still ASCII, then everything is renamed.
      - View "K revizi" on the Risk Register (NextReview <= [Today] and RiskStatus not
        Uzavreno, sorted by RiskScore descending).

    What the script deliberately does NOT do:
      - no data: no SoA rows, no assets, risks or incidents, no POL-01/POL-02 documents --
        students enter those from the reseni-*.md files (the labs' fallback);
      - no Mapa ISMS page, no mapping workbook, no content types, no Approvals on the
        Risk Register (Approvals has no documented scripting path -- student step);
      - no tenant-wide or Purview/Entra policies: no sensitivity or retention labels, DLP,
        retention policies, Conditional Access, PIM. Those are per-student lab work; whoever
        missed them documents the instructor's policy in SoA (scenario rule).

    Idempotent: existing sites, lists, columns, views and permissions are kept; only missing
    parts are added. Existing columns keep their type and settings; their display names are
    set to the schema names (catch-up = class state). Supports -WhatIf.

    Authentication (PnP PowerShell): app-only certificate (-ClientId -Tenant -Thumbprint)
    or interactive (-Interactive -ClientId). The app needs SharePoint Sites.FullControl.All
    and Microsoft Graph Group.Read.All (Get-PnPEntraIDGroup resolves isms-<ini>-users).
    Details of the app registration are in the instructor file outside the repo.

    Not verified on the course tenant (2026-10-17). Unverified assumptions, check in the
    trial run: adding an Entra security group via its claim c:0t.c|tenant|<objectId> with
    Add-PnPGroupMember / Set-PnPListPermission -User (PnP docs show only user login names);
    the object returned by Get-PnPEntraIDGroup exposes .Id; ReportDeadline shows +24 h in the
    site's time zone.

.PARAMETER TenantAdminUrl
    URL of the SharePoint admin center of Tenant A (from the instructor file).

.PARAMETER SiteUrlBase
    Managed path for the sites, e.g. https://<tenant>.sharepoint.com/sites

.PARAMETER AfterDay
    1 or 2 -- target state. Default 1.

.PARAMETER CsvPath
    Student CSV (Initials, UserPrincipalName). Default scripts/students.local.csv.

.PARAMETER Initials
    Students to process (mandatory). Deliberately no 'all students' mode: run before day 1 it
    would occupy every isms-<ini> URL and break day-1 lab step 2.

.PARAMETER UserDomain
    Domain of the test users test-<ini>. Default: the domain of the student's account.
    Must match -UserDomain used with New-CourseScope.ps1.

.PARAMETER ClientId
    Client ID of the Entra app registration used by PnP PowerShell in Tenant A.

.PARAMETER Tenant
    Tenant A ID or primary domain. Required for app-only.

.PARAMETER Thumbprint
    Certificate thumbprint for app-only.

.PARAMETER Interactive
    Interactive sign-in instead of app-only.

.EXAMPLE
    ./New-IsmsWorkspace.ps1 -Initials pm -AfterDay 1 -TenantAdminUrl <TenantAdminUrl> -SiteUrlBase https://<tenant>.sharepoint.com/sites -ClientId <app-id> -Tenant <tenant-id> -Thumbprint <thumbprint> -WhatIf
    Shows what would be created for student pm to reach the day-1 state.

.EXAMPLE
    ./New-IsmsWorkspace.ps1 -Initials pm -AfterDay 2 -TenantAdminUrl <TenantAdminUrl> -SiteUrlBase https://<tenant>.sharepoint.com/sites -ClientId <app-id> -Tenant <tenant-id> -Thumbprint <thumbprint>
    Completes pm's workspace to the day-2 state; whatever pm already built is kept.

.EXAMPLE
    ./New-IsmsWorkspace.ps1 -Initials pm,jn -AfterDay 2 -TenantAdminUrl <TenantAdminUrl> -SiteUrlBase https://<tenant>.sharepoint.com/sites -ClientId <app-id> -Interactive
    Same for two students, interactive sign-in.
#>
[CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'AppOnly')]
param(
    [Parameter(Mandatory)][ValidatePattern('^https://[^/]+/?$')][string]$TenantAdminUrl,
    [Parameter(Mandatory)][ValidatePattern('^https://[^/]+/sites/?$')][string]$SiteUrlBase,
    [ValidateSet(1, 2)][int]$AfterDay = 1,
    [string]$CsvPath = (Join-Path $PSScriptRoot 'students.local.csv'),
    [Parameter(Mandatory)][string[]]$Initials,
    [ValidatePattern('^[a-z0-9.-]+\.[a-z]{2,}$')][string]$UserDomain,
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
$students = Import-StudentCsv -Path $CsvPath -Initials $Initials
Assert-SameTenantHost -TenantAdminUrl $TenantAdminUrl -SiteUrlBase $SiteUrlBase
$auth = @{ ClientId = $ClientId; Tenant = $Tenant; Thumbprint = $Thumbprint; Interactive = $Interactive }

$admin = Connect-CoursePnP -Url $TenantAdminUrl.TrimEnd('/') @auth

# ---- Site ----------------------------------------------------------------------------------
function Confirm-StudentSite {
    param([string]$Ini, [string]$OwnerUpn, [string]$Url)

    $site = Get-PnPTenantSite -Identity $Url -Connection $admin -ErrorAction SilentlyContinue
    if ($site) {
        Write-Host "Site exists: $Url" -ForegroundColor DarkGray
        return $true
    }
    if (-not $PSCmdlet.ShouldProcess($Url, "Create communication site (owner $OwnerUpn)")) { return $false }

    $title = $schema.site.titleFormat -f $Ini
    try {
        # Time zone matters: IncidentLog.ReportDeadline is computed in the site's time zone (day-1 lab step 2).
        New-PnPSite -Type CommunicationSite -Title $title -Url $Url -Owner $OwnerUpn -Lcid $schema.site.lcid `
            -TimeZone UTCPLUS0100_BELGRADE_BRATISLAVA_BUDAPEST_LJUBLJANA_PRAGUE -Connection $admin | Out-Null
    }
    catch {
        throw "Creating $Url failed: $($_.Exception.Message). If a deleted site with this URL is in the tenant recycle bin, purge it first (Remove-CourseArtifacts.ps1 -PurgeDeletedSites) -- the lab forbids a suffixed URL."
    }
    # Poll instead of relying on -Wait (documented inconsistently for CommunicationSite).
    for ($i = 0; $i -lt 40; $i++) {
        if (Get-PnPTenantSite -Identity $Url -Connection $admin -ErrorAction SilentlyContinue) {
            Write-Host "Created site: $Url" -ForegroundColor Green
            return $true
        }
        Start-Sleep -Seconds 15
    }
    throw "Site $Url not available after 10 minutes."
}

# ---- Lists ---------------------------------------------------------------------------------
function Confirm-CourseList {
    param($Def, $Conn)

    $list = Get-PnPList -Identity $Def.url -Connection $Conn
    if ($list) {
        Write-Host "List exists: $($Def.url)" -ForegroundColor DarkGray
    }
    elseif ($PSCmdlet.ShouldProcess($Def.url, 'Create list')) {
        $list = New-PnPList -Title $Def.createTitle -Template $Def.template -Url $Def.url -Connection $Conn
        Write-Host "Created list: $($Def.url)" -ForegroundColor Green
    }
    if (-not $list) { return $null }

    $list = Get-PnPList -Identity $Def.url -Connection $Conn
    if ($list.Title -cne $Def.displayTitle -and $PSCmdlet.ShouldProcess($Def.url, "Set title '$($Def.displayTitle)'")) {
        Set-PnPList -Identity $Def.url -Title $Def.displayTitle -Connection $Conn | Out-Null
    }
    if ($Def.PSObject.Properties.Name -contains 'description' -and $list.Description -cne $Def.description -and
        $PSCmdlet.ShouldProcess($Def.url, 'Set description')) {
        Set-PnPList -Identity $Def.url -Description $Def.description -Connection $Conn | Out-Null
    }
    return $list
}

function Confirm-CourseColumns {
    param($Def, $Conn)

    # 1. Create every column with its ASCII internal name (calculated ones included).
    $created = @()
    foreach ($field in $Def.fields) {
        $lookupId = $null
        if ($field.type -in 'Lookup', 'LookupMulti') {
            $target = Get-PnPList -Identity $field.lookupList -Connection $Conn
            if (-not $target) { Write-Warning "Lookup target $($field.lookupList) missing -- $($field.name) skipped."; continue }
            $lookupId = $target.Id.ToString()
        }
        if (Add-CourseField -Field $field -Connection $Conn -Caller $PSCmdlet -List $Def.url -LookupListId $lookupId) {
            $created += $field.name
        }
    }

    # 2. Rename to Czech display names only after all columns exist.
    if ($Def.PSObject.Properties.Name -contains 'titleDisplayName') {
        Rename-CourseField -InternalName 'Title' -DisplayName $Def.titleDisplayName -List $Def.url -Connection $Conn -Caller $PSCmdlet
    }
    foreach ($field in $Def.fields) {
        Rename-CourseField -InternalName $field.name -DisplayName $field.displayName -List $Def.url -Connection $Conn -Caller $PSCmdlet
    }

    # 3. Show the columns in the default view (Add-PnPFieldFromXml does not add them).
    if ($created.Count -gt 0 -and $Def.template -eq 'GenericList') {
        $default = @(Get-PnPView -List $Def.url -Connection $Conn | Where-Object DefaultView) | Select-Object -First 1
        if ($default) {
            $view = Get-PnPView -List $Def.url -Identity $default.Id -Includes ViewFields -Connection $Conn
            $current = @($view.ViewFields)
            $missing = @($created | Where-Object { $current -notcontains $_ })
            if ($missing.Count -gt 0 -and $PSCmdlet.ShouldProcess("$($Def.url) default view", "Add $($missing -join ', ')")) {
                Set-PnPView -List $Def.url -Identity $default.Id -Fields ($current + $missing) -Connection $Conn | Out-Null
            }
        }
    }

    # 4. Extra views (K revizi).
    if ($Def.PSObject.Properties.Name -contains 'views') {
        foreach ($v in $Def.views) {
            $existing = @(Get-PnPView -List $Def.url -Connection $Conn | Where-Object Title -ceq $v.title)
            if ($existing.Count -gt 0) {
                Write-Host "View exists: $($Def.url) / $($v.title)" -ForegroundColor DarkGray
            }
            elseif ($PSCmdlet.ShouldProcess("$($Def.url) / $($v.title)", 'Add view')) {
                Add-PnPView -List $Def.url -Title $v.title -Fields $v.fields -Query $v.query -Connection $Conn | Out-Null
                Write-Host "Added view: $($Def.url) / $($v.title)" -ForegroundColor Green
            }
        }
    }
}

# ---- ControlledDocs settings and permissions -----------------------------------------------
function Confirm-ControlledDocs {
    param([string]$Ini, [string]$TestUpn, [string]$GroupClaim, $Conn)

    $cfg = $schema.controlledDocs
    $url = 'ControlledDocs'
    if ($PSCmdlet.ShouldProcess($url, 'Versioning: major+minor, content approval, drafts to approvers, no check-out')) {
        Set-PnPList -Identity $url -EnableVersioning $cfg.enableVersioning -EnableMinorVersions $cfg.enableMinorVersions `
            -EnableModeration $cfg.enableModeration -DraftVersionVisibility $cfg.draftVersionVisibility `
            -ForceCheckout $cfg.forceCheckout -Connection $Conn | Out-Null
    }

    $list = Get-PnPList -Identity $url -Includes HasUniqueRoleAssignments -Connection $Conn
    if (-not $list.HasUniqueRoleAssignments) {
        if ($PSCmdlet.ShouldProcess($url, 'Break permission inheritance (copy, then trim)')) {
            Set-PnPList -Identity $url -BreakRoleInheritance -CopyRoleAssignments -Connection $Conn | Out-Null
        }
        else { return }
    }

    # Members and Visitors leave the library; Owners keep Full Control.
    foreach ($g in @((Get-PnPGroup -AssociatedMemberGroup -Connection $Conn), (Get-PnPGroup -AssociatedVisitorGroup -Connection $Conn))) {
        $roles = @(Get-PnPListPermissions -Identity $url -PrincipalId $g.Id -Connection $Conn -ErrorAction SilentlyContinue |
                Where-Object { $_ -and $_.Name -ne 'Limited Access' })
        foreach ($r in $roles) {
            if ($PSCmdlet.ShouldProcess("$url / $($g.Title)", "Remove role $($r.Name)")) {
                Set-PnPListPermission -Identity $url -Group $g -RemoveRole $r.Name -Connection $Conn | Out-Null
            }
        }
    }

    # Role names are localized; the site is created in English (LCID 1033) on purpose.
    if ($GroupClaim -and $PSCmdlet.ShouldProcess("$url / isms-$Ini-users", 'Grant Read')) {
        Set-PnPListPermission -Identity $url -User $GroupClaim -AddRole 'Read' -Connection $Conn | Out-Null
    }
    if ($PSCmdlet.ShouldProcess("$url / $TestUpn", 'Grant Contribute')) {
        try { Set-PnPListPermission -Identity $url -User $TestUpn -AddRole 'Contribute' -Connection $Conn | Out-Null }
        catch { Write-Warning "Could not grant Contribute to $TestUpn ($($_.Exception.Message)). Run New-CourseScope.ps1 first." }
    }

    # Report the final state; the lab checkpoint expects exactly three entries.
    $list = Get-PnPList -Identity $url -Connection $Conn
    $assignments = Get-PnPProperty -ClientObject $list -Property RoleAssignments -Connection $Conn
    $rows = foreach ($ra in $assignments) {
        $member = Get-PnPProperty -ClientObject $ra -Property Member -Connection $Conn
        $bindings = Get-PnPProperty -ClientObject $ra -Property RoleDefinitionBindings -Connection $Conn
        [pscustomobject]@{ Principal = $member.Title; Login = $member.LoginName; Roles = (@($bindings | ForEach-Object { $_.Name }) -join ', ') }
    }
    $rows | Format-Table -AutoSize | Out-Host
    if (@($rows).Count -ne 3) {
        Write-Warning "ControlledDocs has $(@($rows).Count) permission entries, the lab expects 3 (Owners Full Control, isms-$Ini-users Read, test-$Ini Contribute). Remove extras by hand."
    }
}

# ---- Main loop -----------------------------------------------------------------------------
foreach ($s in $students) {
    $ini = $s.Initials
    $siteUrl = '{0}/{1}' -f $SiteUrlBase.TrimEnd('/'), ($schema.site.urlFormat -f $ini)
    $domain = if ($UserDomain) { $UserDomain } else { ($s.UserPrincipalName -split '@')[1] }
    $testUpn = 'test-{0}@{1}' -f $ini, $domain
    Write-Host ''
    Write-Host "== $ini -> $siteUrl (after day $AfterDay) ==" -ForegroundColor Cyan

    if (-not (Confirm-StudentSite -Ini $ini -OwnerUpn $s.UserPrincipalName -Url $siteUrl)) {
        Write-Host 'Site does not exist (WhatIf) -- nothing more to show for this student.' -ForegroundColor DarkGray
        continue
    }

    $conn = Connect-CoursePnP -Url $siteUrl @auth

    $web = Get-PnPWeb -Includes Language -Connection $conn
    if ($web.Language -ne $schema.site.lcid) {
        Write-Warning "Site language is $($web.Language), not $($schema.site.lcid). Permission role names (Read, Contribute) may not resolve."
    }

    # isms-<ini>-users -> site Members (day-1 lab step 4).
    $groupClaim = $null
    $entraGroup = Get-PnPEntraIDGroup -Identity "isms-$ini-users" -Connection $conn -ErrorAction SilentlyContinue
    if (-not $entraGroup) {
        Write-Warning "Entra group isms-$ini-users not found -- run New-CourseScope.ps1 first. Members and library permissions for the group skipped."
    }
    else {
        $groupClaim = "c:0t.c|tenant|$($entraGroup.Id)"
        $membersGroup = Get-PnPGroup -AssociatedMemberGroup -Connection $conn
        if ($PSCmdlet.ShouldProcess("$($membersGroup.Title) <- isms-$ini-users", 'Add to site Members')) {
            Add-PnPGroupMember -LoginName $groupClaim -Group $membersGroup -Connection $conn
        }
    }

    foreach ($def in ($schema.lists | Where-Object { $_.day -le $AfterDay })) {
        $list = Confirm-CourseList -Def $def -Conn $conn
        if (-not $list) { continue }
        if (@($def.fields).Count -gt 0) { Confirm-CourseColumns -Def $def -Conn $conn }
        if ($def.key -eq 'ControlledDocs') {
            Confirm-ControlledDocs -Ini $ini -TestUpn $testUpn -GroupClaim $groupClaim -Conn $conn
        }
    }
    Write-Host "Done: $siteUrl" -ForegroundColor Green
}

Write-Host ''
Write-Host 'Students now enter data and SoA rows from the reseni-*.md files; Approvals on the Risk Register is a manual step.' -ForegroundColor DarkGray
