# Shared helpers for the GOC248 course scripts. Dot-sourced, not run directly:
#   . (Join-Path $PSScriptRoot 'lib/CourseHelpers.ps1')
#
# ASCII only. Czech display names, choices and list titles live in scripts/schema/*.json as
# \u escapes and are decoded by ConvertFrom-Json.

Set-StrictMode -Version Latest

function Get-CourseSchema {
    param([Parameter(Mandatory)][string]$ScriptRoot)
    $path = Join-Path $ScriptRoot 'schema/isms-schema.json'
    if (-not (Test-Path -LiteralPath $path)) { throw "Schema file not found: $path" }
    return (Get-Content -LiteralPath $path -Raw | ConvertFrom-Json)
}

function Assert-CourseModule {
    param([Parameter(Mandatory)][string[]]$Name)
    foreach ($m in $Name) {
        if (-not (Get-Module -ListAvailable -Name $m)) {
            throw "Module '$m' is not installed. Run: Install-Module $m -Scope CurrentUser"
        }
    }
}

function Import-StudentCsv {
    <#
        Reads the instructor's student list (scripts/students.local.csv, gitignored).
        Columns: Initials, UserPrincipalName (Tenant A account), TenantBUserPrincipalName
        (Tenant B account, optional unless a Tenant B script needs it).
        Returns the rows, optionally filtered to -Initials.
    #>
    param(
        [Parameter(Mandatory)][string]$Path,
        [string[]]$Initials,
        [string[]]$RequiredColumns = @('Initials', 'UserPrincipalName')
    )
    if (-not (Test-Path -LiteralPath $Path)) {
        throw "Student CSV not found: $Path. Copy scripts/students.sample.csv to scripts/students.local.csv and fill it in."
    }
    $rows = @(Import-Csv -LiteralPath $Path -Encoding UTF8)
    if ($rows.Count -eq 0) { throw "Student CSV is empty: $Path" }

    $columns = $rows[0].PSObject.Properties.Name
    foreach ($c in $RequiredColumns) {
        if ($columns -notcontains $c) { throw "Student CSV is missing column '$c' ($Path)" }
    }

    $seen = @{}
    foreach ($r in $rows) {
        $r.Initials = $r.Initials.Trim()
        if ($r.Initials -cnotmatch '^[a-z]{2,4}$') {
            throw "Invalid initials '$($r.Initials)' -- use 2-4 lowercase ASCII letters (course rule)."
        }
        if ($seen.ContainsKey($r.Initials)) { throw "Duplicate initials '$($r.Initials)' in $Path" }
        $seen[$r.Initials] = $true
        foreach ($c in $RequiredColumns) {
            if ([string]::IsNullOrWhiteSpace($r.$c)) { throw "Row '$($r.Initials)': column '$c' is empty" }
        }
    }

    if ($Initials) {
        foreach ($i in $Initials) {
            if (-not $seen.ContainsKey($i)) { throw "Initials '$i' are not in $Path" }
        }
        $rows = @($rows | Where-Object { $Initials -contains $_.Initials })
    }
    return $rows
}

function Assert-SameTenantHost {
    <#
        Guards against an admin URL of one tenant combined with a site base of the other:
        the site host must equal the admin host without its '-admin' label.
    #>
    param([Parameter(Mandatory)][string]$TenantAdminUrl, [Parameter(Mandatory)][string]$SiteUrlBase)
    $adminHost = ([uri]$TenantAdminUrl).Host.ToLowerInvariant()
    $siteHost = ([uri]$SiteUrlBase).Host.ToLowerInvariant()
    $firstLabel = $adminHost.Split('.')[0]
    if (-not $firstLabel.EndsWith('-admin')) {
        throw "TenantAdminUrl host '$adminHost' does not look like a SharePoint admin center host (<tenant>-admin...)."
    }
    $expected = $firstLabel.Substring(0, $firstLabel.Length - '-admin'.Length) + $adminHost.Substring($firstLabel.Length)
    if ($siteHost -ne $expected) {
        throw "SiteUrlBase host '$siteHost' does not belong to the admin center '$adminHost' (expected '$expected'). Wrong tenant?"
    }
}

function Connect-CoursePnP {
    <#
        Returns a PnP connection object. Every PnP call in the course scripts passes
        -Connection explicitly, so a loop over many sites never writes through a stale
        ambient connection.
    #>
    param(
        [Parameter(Mandatory)][string]$Url,
        [Parameter(Mandatory)][string]$ClientId,
        [string]$Tenant,
        [string]$Thumbprint,
        [switch]$Interactive
    )
    if ($Interactive) {
        $p = @{ Url = $Url; Interactive = $true; ClientId = $ClientId; ReturnConnection = $true }
        if ($Tenant) { $p.Tenant = $Tenant }
    }
    else {
        if (-not $Tenant -or -not $Thumbprint) { throw 'App-only connection needs -Tenant and -Thumbprint.' }
        $p = @{ Url = $Url; ClientId = $ClientId; Tenant = $Tenant; Thumbprint = $Thumbprint; ReturnConnection = $true }
    }
    $connection = Connect-PnPOnline @p
    Write-Host "Connected: $Url" -ForegroundColor Cyan
    return $connection
}

function ConvertTo-XmlAttribute {
    param([string]$Value)
    return [System.Security.SecurityElement]::Escape($Value)
}

function New-CourseFieldXml {
    <#
        Field XML for Add-PnPFieldFromXml. The field is created with DisplayName equal to the
        ASCII internal name; the Czech display name is set afterwards (Rename-CourseField).
        Same order as the labs: create ASCII, create calculated fields, rename last.
    #>
    param(
        [Parameter(Mandatory)]$Field,
        [string]$Group,
        [string]$LookupListId
    )
    $name = ConvertTo-XmlAttribute $Field.name
    $id = '{' + [guid]::NewGuid().ToString() + '}'
    $common = "Name=`"$name`" StaticName=`"$name`" DisplayName=`"$name`" ID=`"$id`" Required=`"FALSE`""
    if ($Group) { $common += " Group=`"$(ConvertTo-XmlAttribute $Group)`"" }

    switch ($Field.type) {
        'Text' { return "<Field Type=`"Text`" $common MaxLength=`"255`" />" }
        'Note' { return "<Field Type=`"Note`" $common NumLines=`"6`" RichText=`"FALSE`" />" }
        'URL' { return "<Field Type=`"URL`" $common Format=`"Hyperlink`" />" }
        'DateOnly' { return "<Field Type=`"DateTime`" $common Format=`"DateOnly`" />" }
        'DateTime' { return "<Field Type=`"DateTime`" $common Format=`"DateTime`" />" }
        'User' {
            return "<Field Type=`"User`" $common List=`"UserInfo`" ShowField=`"ImnName`" UserSelectionMode=`"PeopleOnly`" UserSelectionScope=`"0`" Mult=`"FALSE`" />"
        }
        'Number' {
            return "<Field Type=`"Number`" $common Min=`"$($Field.min)`" Max=`"$($Field.max)`" Decimals=`"$($Field.decimals)`" />"
        }
        'Choice' {
            $choices = ($Field.choices | ForEach-Object { "<CHOICE>$(ConvertTo-XmlAttribute $_)</CHOICE>" }) -join ''
            $default = ''
            if ($Field.PSObject.Properties.Name -contains 'default') {
                $default = "<Default>$(ConvertTo-XmlAttribute $Field.default)</Default>"
            }
            return "<Field Type=`"Choice`" $common Format=`"Dropdown`" FillInChoice=`"FALSE`"><CHOICES>$choices</CHOICES>$default</Field>"
        }
        'Lookup' {
            if (-not $LookupListId) { throw "Lookup field $($Field.name) needs the target list id" }
            return "<Field Type=`"Lookup`" $common List=`"{$LookupListId}`" ShowField=`"Title`" />"
        }
        'LookupMulti' {
            if (-not $LookupListId) { throw "Lookup field $($Field.name) needs the target list id" }
            return "<Field Type=`"LookupMulti`" $common List=`"{$LookupListId}`" ShowField=`"Title`" Mult=`"TRUE`" Sortable=`"FALSE`" />"
        }
        'Calculated' {
            $refs = ($Field.fieldRefs | ForEach-Object { "<FieldRef Name=`"$(ConvertTo-XmlAttribute $_)`" />" }) -join ''
            $formula = ConvertTo-XmlAttribute $Field.formula
            if ($Field.resultType -eq 'DateTime') {
                $result = 'ResultType="DateTime" Format="DateTime"'
            }
            else {
                $result = "ResultType=`"Number`" Decimals=`"$($Field.decimals)`""
            }
            return "<Field Type=`"Calculated`" $common $result ReadOnly=`"TRUE`"><Formula>$formula</Formula><FieldRefs>$refs</FieldRefs></Field>"
        }
        default { throw "Unknown field type '$($Field.type)' for $($Field.name)" }
    }
}

function Add-CourseField {
    <#
        Ensures one field (list column when -List is given, site column otherwise).
        Existing fields are never changed -- only reported when they differ from the schema.
        Returns $true when the field exists afterwards.
    #>
    param(
        [Parameter(Mandatory)]$Field,
        [Parameter(Mandatory)]$Connection,
        [Parameter(Mandatory)][System.Management.Automation.PSCmdlet]$Caller,
        [string]$List,
        [string]$Group,
        [string]$LookupListId
    )
    $label = if ($List) { "$List/$($Field.name)" } else { "site column $($Field.name)" }
    $get = @{ Identity = $Field.name; Connection = $Connection; ErrorAction = 'SilentlyContinue' }
    if ($List) { $get.List = $List }

    $existing = Get-PnPField @get
    if ($existing) {
        if ($existing.InternalName -cne $Field.name) {
            Write-Warning "$label resolves to a field with internal name '$($existing.InternalName)' -- check by hand, nothing changed."
        }
        else {
            Write-Host "Column exists: $label" -ForegroundColor DarkGray
        }
        return $true
    }

    if (-not $Caller.ShouldProcess($label, 'Add column')) { return $false }

    $xml = New-CourseFieldXml -Field $Field -Group $Group -LookupListId $LookupListId
    $add = @{ FieldXml = $xml; Connection = $Connection }
    if ($List) { $add.List = $List }
    Add-PnPFieldFromXml @add | Out-Null

    $created = Get-PnPField @get
    if (-not $created -or $created.InternalName -cne $Field.name -or $created.InternalName -match '_x00') {
        throw "$label was not created with internal name '$($Field.name)'. Delete it and investigate before continuing."
    }
    Write-Host "Added column: $label" -ForegroundColor Green
    return $true
}

function Rename-CourseField {
    param(
        [Parameter(Mandatory)][string]$InternalName,
        [Parameter(Mandatory)][string]$DisplayName,
        [Parameter(Mandatory)]$Connection,
        [Parameter(Mandatory)][System.Management.Automation.PSCmdlet]$Caller,
        [string]$List
    )
    $get = @{ Identity = $InternalName; Connection = $Connection; ErrorAction = 'SilentlyContinue' }
    if ($List) { $get.List = $List }
    $field = Get-PnPField @get
    if (-not $field) { return }
    if ($field.Title -ceq $DisplayName) { return }
    $label = if ($List) { "$List/$InternalName" } else { "site column $InternalName" }
    if ($Caller.ShouldProcess($label, "Set display name '$DisplayName'")) {
        $set = @{ Identity = $InternalName; Values = @{ Title = $DisplayName }; Connection = $Connection }
        if ($List) { $set.List = $List }
        Set-PnPField @set | Out-Null
        Write-Host "Renamed: $label -> $DisplayName" -ForegroundColor Green
    }
}
