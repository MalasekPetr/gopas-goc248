<#
.SYNOPSIS
    Tenant A: creates each student's own scope -- security group isms-<ini>-users and test
    user test-<ini> -- and puts the student and the test user into the group.

.DESCRIPTION
    Instructor script, run before the course (environment.md, go/no-go Tenant A). For every
    row of the student CSV it ensures:

      1. Security group  isms-<ini>-users  (Security, Assigned, not mail-enabled, not
         role-assignable -- PIM for Groups in privileged-access-pim does not need it).
      2. Test user       test-<ini>@<UserDomain>  (display name test-<ini>, enabled, usage
         location set, temporary password, must change it at first sign-in).
      3. Membership: the student's course account AND test-<ini> are members of
         isms-<ini>-users. The task brief names only the student; the day-3 go/no-go
         (guide-priprava-tenantu.md) and the PIM lab ("test-<ini> je na webu clenem pres
         isms-<ini>-users") also need test-<ini> in the group, so both are added.
      4. Optional (-LicenseSkuPartNumber): a licence for test-<ini>. Day 3 needs a licence
         with Purview (E5) on test-<ini>; without it the label steps fall back to demo.

    Tool choice: Microsoft Graph PowerShell SDK, not PnP PowerShell. PnP PowerShell has
    New-PnPEntraIDGroup but no cmdlet for creating users (New-PnPEntraIDUser does not exist,
    checked 2026-10-17), and licence assignment is a Graph operation anyway.
    Modules: Microsoft.Graph.Authentication, Microsoft.Graph.Users, Microsoft.Graph.Groups,
    Microsoft.Graph.Users.Actions, Microsoft.Graph.Identity.DirectoryManagement.

    Passwords: temporary passwords of NEWLY created test users are written only to
    scripts/out/test-users-<timestamp>.local.csv (scripts/out/ is gitignored). Print the
    tickets, then delete the file. Existing users keep their password; nothing is reset.

    Idempotent: existing groups, users, memberships and licences are left as they are.
    Supports -WhatIf. Never removes anything (cleanup: Remove-CourseArtifacts.ps1).

    Authentication: app-only with certificate (-ClientId -Tenant -Thumbprint) or interactive
    (-Interactive -ClientId -Tenant). Application permissions for app-only:
    User.ReadWrite.All, Group.ReadWrite.All, GroupMember.ReadWrite.All,
    LicenseAssignment.ReadWrite.All, Organization.Read.All. Interactive requests the same
    as delegated scopes. App registration details live in the instructor file outside the
    repo. Not verified on the course tenant yet (2026-10-17).

.PARAMETER CsvPath
    Student CSV. Columns: Initials (2-4 lowercase letters), UserPrincipalName (the student's
    Tenant A account). Default scripts/students.local.csv (gitignored).

.PARAMETER Initials
    Optional subset of initials to process.

.PARAMETER UserDomain
    Domain for the test users, e.g. the Tenant A domain from environment.md.

.PARAMETER UsageLocation
    Two-letter usage location for the test users. Default CZ. Required for licensing.

.PARAMETER LicenseSkuPartNumber
    Optional SkuPartNumber to assign to test-<ini>. List the tenant's SKUs with
    Get-MgSubscribedSku -All | Select-Object SkuPartNumber, ConsumedUnits.

.PARAMETER ClientId
    Client ID of the Entra app registration in Tenant A.

.PARAMETER Tenant
    Tenant A ID or primary domain (always required -- the script never guesses the tenant).

.PARAMETER Thumbprint
    Certificate thumbprint for app-only.

.PARAMETER Interactive
    Delegated sign-in instead of app-only.

.PARAMETER OutputPath
    Folder for the password file. Default scripts/out.

.EXAMPLE
    ./New-CourseScope.ps1 -UserDomain <domain> -ClientId <app-id> -Tenant <tenant-id> -Thumbprint <thumbprint> -WhatIf
    Shows which groups, users and memberships would be created.

.EXAMPLE
    ./New-CourseScope.ps1 -UserDomain <domain> -ClientId <app-id> -Tenant <tenant-id> -Thumbprint <thumbprint> -LicenseSkuPartNumber <sku>
    Creates the scope for all students and licenses the test users.

.EXAMPLE
    ./New-CourseScope.ps1 -Initials pm,jn -UserDomain <domain> -ClientId <app-id> -Tenant <tenant-id> -Interactive
    Creates the scope only for two late-registered students, signing in interactively.
#>
[CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'AppOnly')]
param(
    [string]$CsvPath = (Join-Path $PSScriptRoot 'students.local.csv'),
    [string[]]$Initials,
    [Parameter(Mandatory)][ValidatePattern('^[a-z0-9.-]+\.[a-z]{2,}$')][string]$UserDomain,
    [ValidatePattern('^[A-Z]{2}$')][string]$UsageLocation = 'CZ',
    [string]$LicenseSkuPartNumber,
    [Parameter(Mandatory)][ValidatePattern('^[0-9a-fA-F-]{36}$')][string]$ClientId,
    [Parameter(Mandatory)][string]$Tenant,
    [Parameter(Mandatory, ParameterSetName = 'AppOnly')][string]$Thumbprint,
    [Parameter(Mandatory, ParameterSetName = 'Interactive')][switch]$Interactive,
    [string]$OutputPath = (Join-Path $PSScriptRoot 'out')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib/CourseHelpers.ps1')

Assert-CourseModule -Name 'Microsoft.Graph.Authentication', 'Microsoft.Graph.Users', 'Microsoft.Graph.Groups',
    'Microsoft.Graph.Users.Actions', 'Microsoft.Graph.Identity.DirectoryManagement'

$students = Import-StudentCsv -Path $CsvPath -Initials $Initials

# ---- Connect -------------------------------------------------------------------------------
if ($Interactive) {
    $scopes = 'User.ReadWrite.All', 'Group.ReadWrite.All', 'GroupMember.ReadWrite.All',
        'LicenseAssignment.ReadWrite.All', 'Organization.Read.All'
    Connect-MgGraph -ClientId $ClientId -TenantId $Tenant -Scopes $scopes -NoWelcome
}
else {
    Connect-MgGraph -ClientId $ClientId -TenantId $Tenant -CertificateThumbprint $Thumbprint -NoWelcome
}
$ctx = Get-MgContext
Write-Host "Connected to tenant $($ctx.TenantId) as $(if ($ctx.Account) { $ctx.Account } else { "app $($ctx.ClientId)" })" -ForegroundColor Cyan

# ---- Helpers -------------------------------------------------------------------------------
function ConvertTo-ODataLiteral { param([string]$Value) $Value.Replace("'", "''") }

function Get-UserByUpn {
    param([string]$Upn)
    $u = Get-MgUser -Filter "userPrincipalName eq '$(ConvertTo-ODataLiteral $Upn)'" -Property 'id,userPrincipalName,usageLocation,assignedLicenses'
    return @($u) | Select-Object -First 1
}

function New-TemporaryPassword {
    # 20 characters, at least one of each class; RNG-based.
    $sets = @('ABCDEFGHJKLMNPQRSTUVWXYZ', 'abcdefghijkmnopqrstuvwxyz', '23456789', '!#$%*+-=?')
    $all = -join $sets
    $chars = foreach ($s in $sets) { $s[[System.Security.Cryptography.RandomNumberGenerator]::GetInt32(0, $s.Length)] }
    $chars += 1..16 | ForEach-Object { $all[[System.Security.Cryptography.RandomNumberGenerator]::GetInt32(0, $all.Length)] }
    return -join ($chars | Sort-Object { [System.Security.Cryptography.RandomNumberGenerator]::GetInt32(0, 1000000) })
}

$sku = $null
if ($LicenseSkuPartNumber) {
    $sku = Get-MgSubscribedSku -All | Where-Object SkuPartNumber -eq $LicenseSkuPartNumber
    if (-not $sku) { throw "SKU '$LicenseSkuPartNumber' not found in the tenant." }
    $free = $sku.PrepaidUnits.Enabled - $sku.ConsumedUnits
    Write-Host "Licence $LicenseSkuPartNumber : $free free unit(s)" -ForegroundColor Cyan
}

$newPasswords = New-Object System.Collections.Generic.List[object]
$summary = New-Object System.Collections.Generic.List[object]

foreach ($s in $students) {
    $ini = $s.Initials
    $groupName = "isms-$ini-users"
    $testUpn = "test-$ini@$UserDomain"
    Write-Host ''
    Write-Host "== $ini ==" -ForegroundColor Cyan

    # ---- Group ---------------------------------------------------------------------------
    $group = @(Get-MgGroup -Filter "displayName eq '$(ConvertTo-ODataLiteral $groupName)'" -Property 'id,displayName,securityEnabled,groupTypes')
    if ($group.Count -gt 1) { throw "More than one group named $groupName -- resolve by hand." }
    $group = $group | Select-Object -First 1
    if ($group) {
        Write-Host "Group exists: $groupName" -ForegroundColor DarkGray
        if (-not $group.SecurityEnabled -or $group.GroupTypes -contains 'Unified') {
            Write-Warning "$groupName is not a plain security group -- check by hand."
        }
    }
    elseif ($PSCmdlet.ShouldProcess($groupName, 'Create security group')) {
        $group = New-MgGroup -DisplayName $groupName -MailEnabled:$false -MailNickname $groupName -SecurityEnabled `
            -Description "GOC248 course scope of student $ini (New-CourseScope.ps1)"
        Write-Host "Created group: $groupName" -ForegroundColor Green
    }

    # ---- Test user -----------------------------------------------------------------------
    $testUser = Get-UserByUpn $testUpn
    if ($testUser) {
        Write-Host "User exists: $testUpn" -ForegroundColor DarkGray
    }
    elseif ($PSCmdlet.ShouldProcess($testUpn, 'Create test user')) {
        $password = New-TemporaryPassword
        $testUser = New-MgUser -AccountEnabled -DisplayName "test-$ini" -MailNickname "test-$ini" `
            -UserPrincipalName $testUpn -UsageLocation $UsageLocation `
            -PasswordProfile @{ Password = $password; ForceChangePasswordNextSignIn = $true }
        $newPasswords.Add([pscustomobject]@{ Initials = $ini; UserPrincipalName = $testUpn; TemporaryPassword = $password })
        Write-Host "Created user: $testUpn" -ForegroundColor Green
    }

    # ---- Student account -----------------------------------------------------------------
    $student = Get-UserByUpn $s.UserPrincipalName
    if (-not $student) { Write-Warning "Student account $($s.UserPrincipalName) not found -- not added to $groupName." }

    # ---- Membership ----------------------------------------------------------------------
    if ($group) {
        $memberIds = @(Get-MgGroupMember -GroupId $group.Id -All | ForEach-Object { $_.Id })
        foreach ($m in @($student, $testUser)) {
            if (-not $m) { continue }
            if ($memberIds -contains $m.Id) {
                Write-Host "Member exists: $($m.UserPrincipalName) in $groupName" -ForegroundColor DarkGray
            }
            elseif ($PSCmdlet.ShouldProcess("$groupName <- $($m.UserPrincipalName)", 'Add group member')) {
                New-MgGroupMember -GroupId $group.Id -DirectoryObjectId $m.Id
                Write-Host "Added member: $($m.UserPrincipalName) -> $groupName" -ForegroundColor Green
            }
        }
    }

    # ---- Licence -------------------------------------------------------------------------
    $licensed = 'n/a'
    if ($sku -and $testUser) {
        $fresh = Get-UserByUpn $testUpn
        $has = $fresh -and @($fresh.AssignedLicenses | Where-Object SkuId -eq $sku.SkuId).Count -gt 0
        if ($has) { $licensed = 'yes (existing)' }
        else {
            if ($fresh -and -not $fresh.UsageLocation -and $PSCmdlet.ShouldProcess($testUpn, "Set usage location $UsageLocation")) {
                Update-MgUser -UserId $fresh.Id -UsageLocation $UsageLocation
            }
            if ($PSCmdlet.ShouldProcess($testUpn, "Assign licence $LicenseSkuPartNumber")) {
                Set-MgUserLicense -UserId $testUser.Id -AddLicenses @(@{ SkuId = $sku.SkuId }) -RemoveLicenses @() | Out-Null
                $licensed = 'yes (assigned)'
                Write-Host "Licensed: $testUpn ($LicenseSkuPartNumber)" -ForegroundColor Green
            }
        }
    }

    $summary.Add([pscustomobject]@{
            Initials = $ini
            Group    = if ($group) { 'ok' } else { 'missing' }
            TestUser = if ($testUser) { 'ok' } else { 'missing' }
            Student  = if ($student) { 'ok' } else { 'NOT FOUND' }
            Licence  = $licensed
        })
}

# ---- Passwords -----------------------------------------------------------------------------
if ($newPasswords.Count -gt 0) {
    New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
    $file = Join-Path $OutputPath ("test-users-{0:yyyyMMdd-HHmmss}.local.csv" -f (Get-Date))
    $newPasswords | Export-Csv -LiteralPath $file -NoTypeInformation -Encoding UTF8
    Write-Host ''
    Write-Host "Temporary passwords of $($newPasswords.Count) new user(s): $file" -ForegroundColor Yellow
    Write-Host 'Print the tickets, then delete the file. Never copy it into the repo.' -ForegroundColor Yellow
}

Write-Host ''
$summary | Format-Table -AutoSize
Write-Host 'Next: MFA for test-<ini> is registered by the student (onboarding step 4); label policy depends on group membership -- run this at least T-2 days before day 3.' -ForegroundColor DarkGray
