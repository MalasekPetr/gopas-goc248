# Skripty

Provozní skripty lektora pro přípravu a úklid prostředí GOC248. **Studenti tyto skripty
nikdy nespouštějí** — kurz je portálový (viz [`../GLOSSARY.md`](../GLOSSARY.md), Portály
a nástroje). Spouští je lektor ve svém profilu, proti správnému tenantu.

> [!IMPORTANT] Žádné identifikátory v repu
> Tenant ID, ClientId aplikací, thumbprinty certifikátů, adresy SharePointu tenantů, hesla
> a seznam studentů se předávají **parametry** nebo leží v lokálních souborech `*.local.*`
> a ve složce `scripts/out/` — obojí je v `.gitignore`. Registrace aplikací a certifikáty
> popisuje lektorský soubor mimo repo.

## Přehled

| Skript | Tenant | Kdy | Co dělá | Nástroj |
|---|---|---|---|---|
| [`Build-SampleDocs.ps1`](Build-SampleDocs.ps1) | žádný (lokálně) | před `New-SampleDocsSite` | `.docx` ze [`../sample-docs/`](../sample-docs/) bez Wordu a pandocu, ověření obsahu; volitelně kanárek `KAN-<ini>` | .NET (`System.IO.Compression`) |
| [`New-CourseScope.ps1`](New-CourseScope.ps1) | A | T−10 dní | skupina `isms-<ini>-users`, uživatel `test-<ini>`, členství studenta a `test-<ini>`, volitelně licence | Microsoft Graph PowerShell SDK |
| [`New-IsmsHubColumns.ps1`](New-IsmsHubColumns.ps1) | A | T−10 dní, kontrola po dni 2 | šest sdílených sloupců kategorie `VS ISMS` v `/sites/ContentTypeHub` | PnP PowerShell |
| [`New-IsmsWorkspace.ps1`](New-IsmsWorkspace.ps1) | A | při skluzu studenta | web `isms-<ini>` ve stavu po dni 1 nebo 2 (SoA, ControlledDocs, registry) | PnP PowerShell |
| [`New-SampleDocsSite.ps1`](New-SampleDocsSite.ps1) | B | T−3 dny | web `isms-<ini>`, knihovna `Dokumentace`, 7 dokumentů, student vlastníkem | PnP PowerShell |
| [`Remove-CourseArtifacts.ps1`](Remove-CourseArtifacts.ps1) | A, B | po kurzu | smaže weby, skupiny a testovací uživatele z CSV; vypíše ruční checklist | PnP PowerShell + Graph SDK |
| [`Test-RepoIntegrity.ps1`](Test-RepoIntegrity.ps1) | žádný | po každé úpravě repa | odkazy, agenda, povinné sekce, uniklé identifikátory | PowerShell |

Sdílené části: [`lib/CourseHelpers.ps1`](lib/CourseHelpers.ps1) (připojení, CSV, XML sloupců)
a [`schema/isms-schema.json`](schema/isms-schema.json) — **jediný strojový zdroj schémat**
seznamů a sloupců, přepsaný z referenčních řešení labů. Česká jména jsou v JSON jako `\u`
escapy, aby kód zůstal ASCII. Pravidla obsahu vzorových dokumentů:
[`schema/sample-docs-rules.json`](schema/sample-docs-rules.json).

Při změně schématu v labu (`reseni-*.md`) se mění i `schema/isms-schema.json` — jinak
dohánějící student dostane jiný seznam, než má třída.

## Přihlášení

Všechny skripty proti tenantu mají dvě sady parametrů:

| Režim | Parametry | Kdy |
|---|---|---|
| App-only s certifikátem | `-ClientId <app-id> -Tenant <tenant-id> -Thumbprint <thumbprint>` | výchozí; hromadná příprava |
| Interaktivní | `-Interactive -ClientId <app-id>` (u Graph skriptů i `-Tenant`) | ad-hoc oprava jednoho studenta |

- `Connect-PnPOnline` vždy s `-ClientId` (pravidlo z [`../CONVENTIONS.md`](../CONVENTIONS.md));
  názvy parametrů podle [PnP PowerShell: Connect-PnPOnline](https://pnp.github.io/powershell/cmdlets/Connect-PnPOnline.html).
- Graph skripty (`New-CourseScope`, `Remove-CourseArtifacts -TenantLabel A`) mapují stejné
  parametry na `Connect-MgGraph -ClientId -TenantId -CertificateThumbprint`
  ([Learn: Connect-MgGraph](https://learn.microsoft.com/en-us/powershell/module/microsoft.graph.authentication/connect-mggraph)).
- Každý skript vypíše, kam se připojil. Před prvním zápisem to zkontroluj — Tenant A a B
  mají jiné aplikace a jiné certifikáty.

Potřebná oprávnění aplikací (app-only):

| Tenant | Oprávnění |
|---|---|
| A | SharePoint `Sites.FullControl.All`; Microsoft Graph `User.ReadWrite.All`, `Group.ReadWrite.All`, `GroupMember.ReadWrite.All`, `LicenseAssignment.ReadWrite.All`, `Organization.Read.All` |
| B | SharePoint `Sites.FullControl.All` |

## Vstupní soubor studentů

`scripts/students.local.csv` (gitignored), vzor [`students.sample.csv`](students.sample.csv):

| Sloupec | Obsah | Potřebuje |
|---|---|---|
| `Initials` | iniciály malými písmeny, 2–4 znaky ASCII | všechny skripty |
| `UserPrincipalName` | kurzovní účet studenta na Tenant A | `New-CourseScope`, `New-IsmsWorkspace`, `Remove-CourseArtifacts -TenantLabel A` |
| `TenantBUserPrincipalName` | účet `user.NN` studenta na Tenant B | `New-SampleDocsSite` |

Doménu testovacích uživatelů `test-<ini>` bere `New-CourseScope` z povinného parametru
`-UserDomain`. `New-IsmsWorkspace` a `Remove-CourseArtifacts` mají stejný parametr volitelný
(výchozí je doména účtu studenta) — při jiné doméně ho zadat všude stejně, jinak úklid
testovací uživatele nenajde.

## Pořadí před během (go/no-go)

1. `Build-SampleDocs.ps1` — musí skončit `Verify: OK (7 documents …)`.
2. **Tenant A, T−10 dní:** `New-CourseScope.ps1` (nejdřív `-WhatIf`), pak
   `New-IsmsHubColumns.ps1`. Skupiny musí existovat dřív, než lektor publikuje kurzovní
   label policy (štítky se propisují 24–48 h, viz
   [`guide-priprava-tenantu.md`](../day-3/sensitivity-labels/guide-priprava-tenantu.md)).
3. **Tenant A:** soubor s dočasnými hesly z `scripts/out/` vytisknout na lístky a smazat.
4. **Tenant B, T−3 dny:** `New-SampleDocsSite.ps1` (nejdřív `-WhatIf`). Kontrola: na
   jednom webu je 7 dokumentů a student je ve skupině vlastníků.
5. **Během kurzu:** `New-IsmsWorkspace.ps1 -Initials <ini> -AfterDay 1|2` jen pro toho, kdo
   ztratil den — po dohodě, ne preventivně pro všechny (vlastní stavba je cíl labu).
6. **Po kurzu, v tomto pořadí:**
   1. `Remove-CourseArtifacts.ps1 -WhatIf` pro A i B — vypíše cíle mazání a uloží ruční
      checklist do `scripts/out/`;
   2. ruční položky checklistu na Tenant A **před** mazáním webů: retenční politiky,
      záznamy, label policies (záznamy a retence mazání webu blokují, viz
      [`guide-priprava-tenantu.md`](../day-3/sensitivity-labels/guide-priprava-tenantu.md),
      Úklid po kurzu);
   3. `Remove-CourseArtifacts.ps1 -PurgeDeletedSites` pro A i B (ptá se u každého mazání);
   4. zbytek checklistu (CA, PIM, agenti na B, PAYG).

## Bezpečnost

- **Proti tenantu nespouštět nic, co neprošlo `-WhatIf`.** Všechny měnící skripty ho
  podporují; `Remove-CourseArtifacts` má `ConfirmImpact = High` a ptá se u každého mazání.
- **Mazání jen podle CSV.** Tenant A sdílí jiný kurz (SPO_DEV_1); objekty `isms-*`
  a `test-*`, které nejsou v CSV, úklid jen vypíše.
- **Adresy webů jsou na A i B stejné** (`/sites/isms-<ini>`). O tom, kde se maže, rozhoduje
  připojení, ne `-TenantLabel`. Skripty odmítnou `-SiteUrlBase`, který nepatří k tenantu
  `-TenantAdminUrl`; výpis „Connected: …" i tak zkontrolovat.
- **`New-IsmsWorkspace` vyžaduje `-Initials`.** Hromadné založení webů před dnem 1 by obsadilo
  adresy, které studenti zakládají sami (krok 2 labu `isms-design-m365`).
- **Tenantové politiky (štítky, DLP, retence, CA, PIM) skripty nezakládají ani nemažou.**
  Chybný výběr by zasáhl jiný kurz nebo tenant; úklid je ruční checklist.
- **Hesla jen do `scripts/out/`.** Soubor s hesly po vytištění smazat.
- **Žádná data mezi tenanty.** Na Tenant B jdou jen fiktivní dokumenty z repa.

## Co není ověřené

Stav k 2026-10-17: skripty jsou syntakticky zkontrolované a `Build-SampleDocs.ps1` je
spuštěný lokálně; **proti kurzovním tenantům neběžel žádný skript**. Ověřit ve zkušebním
průchodu (prosinec 2026):

- přidání skupiny Entra ID do skupiny Members webu a do oprávnění knihovny přes claim
  `c:0t.c|tenant|<objectId>` (PnP dokumentace uvádí jen přihlašovací jména uživatelů);
- vlastnosti objektů z `Get-PnPEntraIDGroup` a `Get-PnPTenantDeletedSite` (dokumentace je
  neuvádí);
- že počítaný sloupec `ReportDeadline` ukazuje +24 h v časové zóně webu;
- že vygenerované `.docx` otevře Word i Autofill (struktura podle OOXML, test v aplikaci
  neproběhl).
