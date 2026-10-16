<#
.SYNOPSIS
    Builds the fictional Vltava Servis sample documents (.docx) from the Markdown sources in
    sample-docs/ and verifies them.

.DESCRIPTION
    Course preparation script, runs locally, touches no tenant. Converts every
    sample-docs/*.md except README.md into a minimal Office Open XML package (.docx) built
    with System.IO.Compression -- no Word, no pandoc, no external modules.

    Package parts written per document:
      [Content_Types].xml, _rels/.rels, docProps/core.xml (dc:title),
      word/document.xml, word/styles.xml, word/_rels/document.xml.rels

    Supported Markdown subset (see sample-docs/README.md): '#', '##', '###' headings,
    paragraphs separated by a blank line, '-' bullets, '1.' numbered items, '**bold**'.
    Indented continuation lines are joined to the previous item. Backticks are dropped.
    Tables, links and images are not supported and fail the build.

    The .docx file name is taken from the H1 heading of the source (with diacritics), because
    the labs cite the documents that way, e.g. "SME-01 Zalohovani a obnova" in Czech.

    After the build the script re-opens every package and verifies:
      1. all required parts exist and every XML part is well-formed,
      2. the content rules in scripts/schema/sample-docs-rules.json -- label lines and their
         order, the deliberate gaps (SME-02 without a review date, ZAZ-01 without
         owner/effective/review lines), facts the day-5 agent evaluation relies on, no salary
         terms, e-mail addresses only on .example domains, exactly 7 documents.
    Any failure ends the script with exit code 1.

    Canary document: with -CanaryInitials the script also builds "KAN-<ini> Kontrolni
    dokument" (day-5 lab ai-agents-tenant, instructor fallback) into a separate folder
    (default scripts/out/canary). New-SampleDocsSite.ps1 never uploads it unless asked to.

    Output goes to scripts/out/ which is gitignored. Existing .docx files in the output
    folder are removed first, so the folder always holds exactly the current set.

.PARAMETER SourcePath
    Folder with the Markdown sources. Defaults to <repo>/sample-docs.

.PARAMETER OutputPath
    Output folder for the 7 documents. Defaults to scripts/out/sample-docs.

.PARAMETER CanaryInitials
    Student initials (lowercase, 2-4 letters). When given, the canary document is built too.

.PARAMETER CanaryCode
    Four digits for the canary code KANAREK-<ini>-<code>. When omitted, a random code is
    generated and printed once to the console -- write it down, it is stored nowhere else.

.PARAMETER CanaryOutputPath
    Output folder for the canary document. Defaults to scripts/out/canary.

.PARAMETER SkipVerify
    Builds without the verification pass. Not recommended.

.EXAMPLE
    ./Build-SampleDocs.ps1
    Builds the 7 documents into scripts/out/sample-docs and verifies them.

.EXAMPLE
    ./Build-SampleDocs.ps1 -CanaryInitials pm -CanaryCode 4821
    Builds the 7 documents and the canary "KAN-pm Kontrolni dokument" with code
    KANAREK-pm-4821 into scripts/out/canary.

.EXAMPLE
    ./Build-SampleDocs.ps1 -WhatIf
    Shows which files would be written without writing anything.

.EXAMPLE
    ./Build-SampleDocs.ps1 -OutputPath C:\Temp\goc248-docs
    Builds into a different folder, e.g. to inspect the files in Word.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$SourcePath = (Join-Path (Split-Path $PSScriptRoot -Parent) 'sample-docs'),
    [string]$OutputPath = (Join-Path $PSScriptRoot 'out/sample-docs'),
    [ValidatePattern('^[a-z]{2,4}$')][string]$CanaryInitials,
    [ValidatePattern('^\d{4}$')][string]$CanaryCode,
    [string]$CanaryOutputPath = (Join-Path $PSScriptRoot 'out/canary'),
    [switch]$SkipVerify
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$nsW = 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$rulesPath = Join-Path $PSScriptRoot 'schema/sample-docs-rules.json'

# Text with diacritics is kept out of this file (ASCII-only rule): \u escapes, decoded here.
function ConvertFrom-Escaped { param([string]$Text) [regex]::Unescape($Text) }

# ---- Markdown -> block list ----------------------------------------------------------------
function ConvertFrom-SimpleMarkdown {
    param([string]$Path)

    $lines = [System.IO.File]::ReadAllLines($Path, [System.Text.Encoding]::UTF8)
    $blocks = New-Object System.Collections.Generic.List[object]
    $current = $null

    foreach ($raw in $lines) {
        $line = $raw.TrimEnd()

        if ($line -match '^\s*\|' -or $line -match '!\[' -or $line -match '\]\(') {
            throw "Unsupported Markdown (table, image or link) in $(Split-Path $Path -Leaf): '$line'"
        }

        if ($line -eq '') { $current = $null; continue }

        if ($line -match '^(?<h>#{1,3})\s+(?<t>.+)$') {
            $style = @{ 1 = 'Title'; 2 = 'Heading1'; 3 = 'Heading2' }[$Matches['h'].Length]
            $blocks.Add([pscustomobject]@{ Style = $style; Prefix = ''; Text = $Matches['t'] })
            $current = $null
            continue
        }
        if ($line -match '^-\s+(?<t>.+)$') {
            $current = [pscustomobject]@{ Style = 'ListParagraph'; Prefix = ([string][char]0x2022) + ' '; Text = $Matches['t'] }
            $blocks.Add($current)
            continue
        }
        if ($line -match '^(?<n>\d+)\.\s+(?<t>.+)$') {
            $current = [pscustomobject]@{ Style = 'ListParagraph'; Prefix = "$($Matches['n']). "; Text = $Matches['t'] }
            $blocks.Add($current)
            continue
        }
        if ($null -ne $current) {
            # Continuation of a paragraph or an indented continuation of a list item.
            $current.Text = $current.Text + ' ' + $line.Trim()
            continue
        }
        $current = [pscustomobject]@{ Style = 'Normal'; Prefix = ''; Text = $line.Trim() }
        $blocks.Add($current)
    }
    return $blocks
}

# Splits "a **b** c" into runs; drops backticks.
function Get-InlineRuns {
    param([string]$Text)
    $clean = $Text.Replace('`', '')
    $parts = $clean -split '\*\*'
    $runs = @()
    for ($i = 0; $i -lt $parts.Count; $i++) {
        if ($parts[$i] -ne '') { $runs += [pscustomobject]@{ Text = $parts[$i]; Bold = ($i % 2 -eq 1) } }
    }
    return $runs
}

# ---- XML part writers ----------------------------------------------------------------------
function New-XmlWriterOnEntry {
    param([System.IO.Compression.ZipArchive]$Zip, [string]$Name)
    $entry = $Zip.CreateEntry($Name, [System.IO.Compression.CompressionLevel]::Optimal)
    $stream = $entry.Open()
    $settings = New-Object System.Xml.XmlWriterSettings
    $settings.Encoding = $utf8NoBom
    $settings.Indent = $false
    $writer = [System.Xml.XmlWriter]::Create($stream, $settings)
    return [pscustomobject]@{ Writer = $writer; Stream = $stream }
}

function Close-XmlEntry {
    param($Handle)
    $Handle.Writer.Flush()
    $Handle.Writer.Dispose()
    $Handle.Stream.Dispose()
}

function Write-StaticPart {
    param([System.IO.Compression.ZipArchive]$Zip, [string]$Name, [string]$Xml)
    # Validate before writing: a malformed static part is a bug in this script.
    [void]([xml]$Xml)
    $entry = $Zip.CreateEntry($Name, [System.IO.Compression.CompressionLevel]::Optimal)
    $stream = $entry.Open()
    try {
        $bytes = $utf8NoBom.GetBytes($Xml)
        $stream.Write($bytes, 0, $bytes.Length)
    }
    finally { $stream.Dispose() }
}

$contentTypesXml = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
<Default Extension="xml" ContentType="application/xml"/>
<Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
<Override PartName="/word/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml"/>
<Override PartName="/docProps/core.xml" ContentType="application/vnd.openxmlformats-package.core-properties+xml"/>
</Types>
'@

$rootRelsXml = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" Target="docProps/core.xml"/>
</Relationships>
'@

$documentRelsXml = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
</Relationships>
'@

$stylesXml = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:styles xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
<w:docDefaults>
<w:rPrDefault><w:rPr><w:rFonts w:ascii="Calibri" w:hAnsi="Calibri" w:cs="Calibri" w:eastAsia="Calibri"/><w:sz w:val="22"/><w:szCs w:val="22"/><w:lang w:val="cs-CZ"/></w:rPr></w:rPrDefault>
<w:pPrDefault><w:pPr><w:spacing w:after="120" w:line="264" w:lineRule="auto"/></w:pPr></w:pPrDefault>
</w:docDefaults>
<w:style w:type="paragraph" w:default="1" w:styleId="Normal"><w:name w:val="Normal"/><w:qFormat/></w:style>
<w:style w:type="paragraph" w:styleId="Title"><w:name w:val="Title"/><w:basedOn w:val="Normal"/><w:next w:val="Normal"/><w:qFormat/><w:pPr><w:spacing w:after="240"/><w:outlineLvl w:val="0"/></w:pPr><w:rPr><w:b/><w:sz w:val="36"/><w:szCs w:val="36"/></w:rPr></w:style>
<w:style w:type="paragraph" w:styleId="Heading1"><w:name w:val="heading 1"/><w:basedOn w:val="Normal"/><w:next w:val="Normal"/><w:qFormat/><w:pPr><w:keepNext/><w:spacing w:before="240" w:after="120"/><w:outlineLvl w:val="0"/></w:pPr><w:rPr><w:b/><w:sz w:val="28"/><w:szCs w:val="28"/></w:rPr></w:style>
<w:style w:type="paragraph" w:styleId="Heading2"><w:name w:val="heading 2"/><w:basedOn w:val="Normal"/><w:next w:val="Normal"/><w:qFormat/><w:pPr><w:keepNext/><w:spacing w:before="200" w:after="80"/><w:outlineLvl w:val="1"/></w:pPr><w:rPr><w:b/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr></w:style>
<w:style w:type="paragraph" w:styleId="ListParagraph"><w:name w:val="List Paragraph"/><w:basedOn w:val="Normal"/><w:qFormat/><w:pPr><w:spacing w:after="60"/><w:ind w:left="360" w:hanging="360"/></w:pPr></w:style>
</w:styles>
'@

function Write-DocxPackage {
    param([string]$Path, [string]$Title, [object[]]$Blocks)

    if (Test-Path -LiteralPath $Path) { Remove-Item -LiteralPath $Path -Force }
    $fs = [System.IO.File]::Open($Path, [System.IO.FileMode]::CreateNew)
    $zip = New-Object System.IO.Compression.ZipArchive($fs, [System.IO.Compression.ZipArchiveMode]::Create)
    try {
        Write-StaticPart $zip '[Content_Types].xml' $contentTypesXml
        Write-StaticPart $zip '_rels/.rels' $rootRelsXml
        Write-StaticPart $zip 'word/_rels/document.xml.rels' $documentRelsXml
        Write-StaticPart $zip 'word/styles.xml' $stylesXml

        # docProps/core.xml -- title only; no author, the documents are fictional.
        $h = New-XmlWriterOnEntry $zip 'docProps/core.xml'
        $w = $h.Writer
        $w.WriteStartDocument($true)
        $w.WriteStartElement('cp', 'coreProperties', 'http://schemas.openxmlformats.org/package/2006/metadata/core-properties')
        $w.WriteAttributeString('xmlns', 'dc', $null, 'http://purl.org/dc/elements/1.1/')
        $w.WriteAttributeString('xmlns', 'dcterms', $null, 'http://purl.org/dc/terms/')
        $w.WriteAttributeString('xmlns', 'xsi', $null, 'http://www.w3.org/2001/XMLSchema-instance')
        $w.WriteElementString('title', 'http://purl.org/dc/elements/1.1/', $Title)
        $w.WriteElementString('language', 'http://purl.org/dc/elements/1.1/', 'cs-CZ')
        $w.WriteEndElement()
        $w.WriteEndDocument()
        Close-XmlEntry $h

        # word/document.xml
        $h = New-XmlWriterOnEntry $zip 'word/document.xml'
        $w = $h.Writer
        $w.WriteStartDocument($true)
        $w.WriteStartElement('w', 'document', $nsW)
        $w.WriteStartElement('w', 'body', $nsW)
        foreach ($block in $Blocks) {
            $w.WriteStartElement('w', 'p', $nsW)
            if ($block.Style -ne 'Normal') {
                $w.WriteStartElement('w', 'pPr', $nsW)
                $w.WriteStartElement('w', 'pStyle', $nsW)
                $w.WriteAttributeString('w', 'val', $nsW, $block.Style)
                $w.WriteEndElement()
                $w.WriteEndElement()
            }
            $runs = @()
            if ($block.Prefix) { $runs += [pscustomobject]@{ Text = $block.Prefix; Bold = $false } }
            $runs += Get-InlineRuns $block.Text
            foreach ($run in $runs) {
                $w.WriteStartElement('w', 'r', $nsW)
                if ($run.Bold) {
                    $w.WriteStartElement('w', 'rPr', $nsW)
                    $w.WriteElementString('w', 'b', $nsW, $null)
                    $w.WriteEndElement()
                }
                $w.WriteStartElement('w', 't', $nsW)
                $w.WriteAttributeString('xml', 'space', 'http://www.w3.org/XML/1998/namespace', 'preserve')
                $w.WriteString($run.Text)
                $w.WriteEndElement()
                $w.WriteEndElement()
            }
            $w.WriteEndElement()
        }
        # A4 portrait, 2.5 cm margins.
        $w.WriteStartElement('w', 'sectPr', $nsW)
        $w.WriteStartElement('w', 'pgSz', $nsW)
        $w.WriteAttributeString('w', 'w', $nsW, '11906')
        $w.WriteAttributeString('w', 'h', $nsW, '16838')
        $w.WriteEndElement()
        $w.WriteStartElement('w', 'pgMar', $nsW)
        foreach ($side in 'top', 'right', 'bottom', 'left') { $w.WriteAttributeString('w', $side, $nsW, '1418') }
        foreach ($side in 'header', 'footer') { $w.WriteAttributeString('w', $side, $nsW, '709') }
        $w.WriteAttributeString('w', 'gutter', $nsW, '0')
        $w.WriteEndElement()
        $w.WriteEndElement()
        $w.WriteEndElement()
        $w.WriteEndElement()
        $w.WriteEndDocument()
        Close-XmlEntry $h
    }
    finally {
        $zip.Dispose()
        $fs.Dispose()
    }
}

function Get-SafeFileName {
    param([string]$Name)
    $invalid = [System.IO.Path]::GetInvalidFileNameChars() + [char[]]'"*:<>?/\|#%'
    $safe = -join ($Name.ToCharArray() | ForEach-Object { if ($invalid -contains $_) { '-' } else { $_ } })
    return $safe.Trim().TrimEnd('.')
}

# ---- Verification --------------------------------------------------------------------------
$requiredParts = @('[Content_Types].xml', '_rels/.rels', 'docProps/core.xml', 'word/document.xml',
    'word/styles.xml', 'word/_rels/document.xml.rels')

function Get-DocxParagraphs {
    # Re-opens the package, checks parts and well-formedness, returns paragraph texts.
    param([string]$Path, [System.Collections.Generic.List[string]]$Problems)
    $name = Split-Path $Path -Leaf
    $zip = [System.IO.Compression.ZipFile]::OpenRead($Path)
    try {
        $entryNames = @($zip.Entries | ForEach-Object { $_.FullName })
        foreach ($part in $requiredParts) {
            if ($entryNames -notcontains $part) { $Problems.Add("$name : missing part $part") }
        }
        $paragraphs = @()
        foreach ($entry in $zip.Entries) {
            if ($entry.FullName -notmatch '\.(xml|rels)$') { continue }
            $reader = New-Object System.IO.StreamReader($entry.Open(), [System.Text.Encoding]::UTF8)
            try { $text = $reader.ReadToEnd() } finally { $reader.Dispose() }
            $doc = New-Object System.Xml.XmlDocument
            try { $doc.LoadXml($text) }
            catch { $Problems.Add("$name : $($entry.FullName) is not well-formed XML: $($_.Exception.Message)"); continue }
            if ($entry.FullName -eq 'word/document.xml') {
                $ns = New-Object System.Xml.XmlNamespaceManager($doc.NameTable)
                $ns.AddNamespace('w', $nsW)
                foreach ($p in $doc.SelectNodes('//w:body/w:p', $ns)) {
                    $paragraphs += (-join ($p.SelectNodes('.//w:t', $ns) | ForEach-Object { $_.InnerText }))
                }
            }
        }
        return , $paragraphs
    }
    finally { $zip.Dispose() }
}

function Test-DocumentRules {
    param([string]$FileName, [string[]]$Paragraphs, $Rules, [System.Collections.Generic.List[string]]$Problems)

    $docRule = $Rules.documents | Where-Object { $FileName.StartsWith($_.prefix) }
    if (-not $docRule) { $Problems.Add("$FileName : no content rule for this document"); return }
    $all = $Paragraphs -join "`n"

    # Label lines directly after the title, in order, each its own paragraph.
    $labels = if ($docRule.PSObject.Properties.Name -contains 'labels') { $docRule.labels } else { $Rules.defaultLabels }
    for ($i = 0; $i -lt $labels.Count; $i++) {
        $p = if ($Paragraphs.Count -gt $i + 1) { $Paragraphs[$i + 1] } else { '' }
        if (-not $p.StartsWith($labels[$i])) {
            $Problems.Add("$FileName : paragraph $($i + 2) should start with '$($labels[$i])', found '$p'")
        }
    }
    foreach ($s in @($docRule.PSObject.Properties | Where-Object Name -eq 'mustContain' | ForEach-Object { $_.Value })) {
        if (-not $all.Contains($s)) { $Problems.Add("$FileName : missing text '$s'") }
    }
    foreach ($s in @($docRule.PSObject.Properties | Where-Object Name -eq 'mustNotContain' | ForEach-Object { $_.Value })) {
        if ($all.Contains($s)) { $Problems.Add("$FileName : must not contain '$s'") }
    }
    foreach ($s in @($docRule.PSObject.Properties | Where-Object Name -eq 'exactLines' | ForEach-Object { $_.Value })) {
        if ($Paragraphs -notcontains $s) { $Problems.Add("$FileName : missing exact paragraph '$s'") }
    }
    if ($docRule.PSObject.Properties.Name -contains 'orderedTerms') {
        $last = -1
        foreach ($t in $docRule.orderedTerms) {
            $pos = $all.IndexOf($t)
            if ($pos -lt 0 -or $pos -le $last) { $Problems.Add("$FileName : term '$t' missing or out of order") }
            $last = $pos
        }
    }
    if ($docRule.PSObject.Properties.Name -contains 'minMatches') {
        foreach ($m in $docRule.minMatches) {
            $n = [regex]::Matches($all, $m.pattern).Count
            if ($n -lt $m.count) { $Problems.Add("$FileName : pattern '$($m.pattern)' found $n times, expected >= $($m.count)") }
        }
    }
    foreach ($pattern in $Rules.forbiddenPatterns) {
        $hit = [regex]::Match($all, $pattern)
        if ($hit.Success) { $Problems.Add("$FileName : forbidden term '$($hit.Value)'") }
    }
    foreach ($mail in [regex]::Matches($all, $Rules.emailPattern)) {
        if (-not $mail.Value.TrimEnd('.', ',').EndsWith($Rules.allowedEmailSuffix)) {
            $Problems.Add("$FileName : e-mail address outside .example: $($mail.Value)")
        }
    }
}

# ---- Build ---------------------------------------------------------------------------------
$sources = @(Get-ChildItem -Path $SourcePath -Filter '*.md' -File | Where-Object Name -ne 'README.md' | Sort-Object Name)
if ($sources.Count -eq 0) { throw "No Markdown sources found in $SourcePath" }

if ($PSCmdlet.ShouldProcess($OutputPath, "Clear old .docx and build $($sources.Count) documents")) {
    New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
    Get-ChildItem -Path $OutputPath -Filter '*.docx' -File | Remove-Item -Force
}

$built = New-Object System.Collections.Generic.List[string]
foreach ($src in $sources) {
    $blocks = ConvertFrom-SimpleMarkdown -Path $src.FullName
    $titleBlock = $blocks | Where-Object Style -eq 'Title' | Select-Object -First 1
    if (-not $titleBlock) { throw "$($src.Name) has no H1 heading" }
    $title = $titleBlock.Text
    $target = Join-Path $OutputPath ((Get-SafeFileName $title) + '.docx')
    if ($PSCmdlet.ShouldProcess($target, 'Write .docx')) {
        Write-DocxPackage -Path $target -Title $title -Blocks $blocks
        $built.Add($target)
        Write-Host "Built: $(Split-Path $target -Leaf)" -ForegroundColor Green
    }
}

# ---- Canary --------------------------------------------------------------------------------
$canaryPath = $null
if ($CanaryInitials) {
    if (-not $CanaryCode) {
        $CanaryCode = '{0:D4}' -f [System.Security.Cryptography.RandomNumberGenerator]::GetInt32(0, 10000)
    }
    $canaryTitle = "KAN-$CanaryInitials Kontrolni dokument"
    # "Kontrolni kod Vltava Servis: " with Czech diacritics, as in the day-5 lab.
    $canaryText = (ConvertFrom-Escaped 'Kontroln\u00ed k\u00f3d Vltava Servis: ') + "KANAREK-$CanaryInitials-$CanaryCode"
    $canaryBlocks = @(
        [pscustomobject]@{ Style = 'Title'; Prefix = ''; Text = $canaryTitle },
        [pscustomobject]@{ Style = 'Normal'; Prefix = ''; Text = $canaryText }
    )
    $canaryPath = Join-Path $CanaryOutputPath ($canaryTitle + '.docx')
    if ($PSCmdlet.ShouldProcess($canaryPath, 'Write canary .docx')) {
        New-Item -ItemType Directory -Path $CanaryOutputPath -Force | Out-Null
        Write-DocxPackage -Path $canaryPath -Title $canaryTitle -Blocks $canaryBlocks
        Write-Host "Built canary: $(Split-Path $canaryPath -Leaf)  code KANAREK-$CanaryInitials-$CanaryCode (not stored anywhere else)" -ForegroundColor Yellow
    }
}

if ($SkipVerify -or $built.Count -eq 0) { return }

# ---- Verify --------------------------------------------------------------------------------
$rules = Get-Content -Path $rulesPath -Raw | ConvertFrom-Json
$problems = New-Object System.Collections.Generic.List[string]

$docxFiles = @(Get-ChildItem -Path $OutputPath -Filter '*.docx' -File)
if ($docxFiles.Count -ne $rules.expectedCount) {
    $problems.Add("Output folder holds $($docxFiles.Count) documents, expected $($rules.expectedCount)")
}
foreach ($file in $docxFiles) {
    $paragraphs = Get-DocxParagraphs -Path $file.FullName -Problems $problems
    Test-DocumentRules -FileName $file.Name -Paragraphs $paragraphs -Rules $rules -Problems $problems
}
if ($canaryPath -and (Test-Path -LiteralPath $canaryPath)) {
    $canaryParagraphs = Get-DocxParagraphs -Path $canaryPath -Problems $problems
    if (($canaryParagraphs -join ' ') -notmatch "KANAREK-$CanaryInitials-\d{4}") { $problems.Add('canary: code paragraph missing') }
}

Write-Host ''
if ($problems.Count -eq 0) {
    Write-Host "Verify: OK ($($docxFiles.Count) documents, parts present, XML well-formed, content rules met)" -ForegroundColor Green
    exit 0
}
Write-Host "Verify: $($problems.Count) problem(s)" -ForegroundColor Red
$problems | ForEach-Object { Write-Host "  $_" -ForegroundColor Yellow }
exit 1
