# Prostředí kurzu

Referenční údaje, na které se odkazují laby.

> [!IMPORTANT] Publikace
> Repo je **public** — tento soubor obsahuje jen student-facing část. Instructor-only údaje
> (tenant ID, adresy SharePointu tenantů, admin a break-glass účty, hesla, lifecycle účtů)
> jsou drženy mimo repo.

## Proč dva tenanty

Tenant A má Purview a Entra ID P2 pro dny 1–4 a capstone, ale **nemá Copilot ani Document
processing**. Tenant B má Copilot a Document processing, ale **nemá licence Purview ani E5**.
Kurz proto používá každý tenant na to, co skutečně umí.

| Tenant | Doména | K čemu | Role studenta |
|---|---|---|---|
| **A** | `cloudedu.cz` | ISMS workspace, SoA, registry, Purview, Entra, Compliance Manager | **Global Administrator** + tenantová disciplína |
| **B** | `spdemo.online` | Autofill columns, Skills, agenti, ukázky Copilota | **vlastník vlastního webu**, bez admin rolí |

## Tenant A — `cloudedu.cz`

| Položka | Hodnota |
|---|---|
| Typ tenantu | Microsoft 365 Developer tenant (stejný jako v kurzu SPO_DEV_1) |
| Účty studentů | `jmeno.prijmeni@cloudedu.cz` — přidělí lektor první ráno |
| Role studentů | **Global Administrator** (celý týden) |
| MFA | **povinné** — registrace Microsoft Authenticatoru při prvním přihlášení |
| Adresa SharePointu | sdělí lektor; v labech jako `<tenant>.sharepoint.com` |
| Workspace studenta | `/sites/isms-<iniciály>` — zakládá student v `isms-design-m365` |
| Vlastní scope | skupina `isms-<ini>-users`, testovací uživatel `test-<ini>` — zakládá lektor skriptem |

> [!IMPORTANT] Všichni jsou Global Administrator na jednom tenantu
> V kurzu o řízení přístupu je to záměrný paradox — a v bloku `privileged-access-pim` se z něj
> stane nález („jaké role by stačily"). Do té doby tři pravidla:
>
> 1. **Každá politika jen na vlastní scope** (`isms-<ini>`, `isms-<ini>-users`, `test-<ini>`)
>    s prefixem `<ini>-` v názvu.
> 2. **Conditional Access jen report-only**, vynucení jen na `test-<ini>`; nouzové účty jsou
>    z každé politiky vyloučené. Chybná CA politika zamkne celou učebnu i lektora.
> 3. **Kurzovní účet jen v odděleném profilu prohlížeče** — pro každý tenant jiný profil.

## Tenant B — `spdemo.online`

| Položka | Hodnota |
|---|---|
| Typ tenantu | demo tenant Malach IS, vyhrazený pro školení |
| Účty studentů | `user.NN@spdemo.online` — přidělí lektor první ráno |
| Role studentů | **vlastník vlastního webu**, žádné admin role |
| Licence | Microsoft 365 Business Basic; Copilot a Document processing přes **pay-as-you-go** |
| Purview | **bez licencí Purview / E5** — politiky pro Copilot se konfigurují na Tenant A |
| Adresa SharePointu | sdělí lektor |
| Web studenta | `/sites/isms-<iniciály>` — zakládá lektor skriptem s kopií vzorové dokumentace |

> [!WARNING] Ověřit k datu běhu — PAYG nemá tvrdý strop.
> Každá interakce s Copilotem a každá stránka zpracovaná Autofill columns se účtuje. Rozpočet
> na billing policy jen posílá upozornění a čerpání nezastaví
> ([Learn: PAYG setup](https://learn.microsoft.com/en-us/microsoft-365/copilot/pay-as-you-go/setup)).
> Před během nastavit upozornění a změřit spotřebu na studenta při zkušebním průchodu.

> [!IMPORTANT] Mezi tenanty se nestěhují data
> Web na Tenant B obsahuje jen fiktivní vzorovou dokumentaci z repa. Výsledky z Tenant B se do
> SoA na Tenant A dokládají odkazem a screenshotem. Viz
> [`scenario-isms-vltava.md`](./scenario-isms-vltava.md).

## Matice požadavků per blok

`S` = student mění vlastní scope · `T` = zásah do celého tenantu (výslovný krok labu) ·
`D` = instruktorské demo · `—` = výklad nebo návrh

| Den | Blok | Tenant | Režim | Co je potřeba nad rámec základu |
|---|---|---|---|---|
| 1 | `onboarding` | A + B | S | MFA na obou tenantech, dva profily prohlížeče |
| 1 | `nis2-iso27001-fundamentals` | — | — | — |
| 1 | `requirements-mapping-m365` | A | — | přístup do admin center (prohlídka licencí) |
| 1 | `isms-design-m365` | A | S | založení webu `isms-<ini>` |
| 2 | `document-libraries-governance` | A | S | — |
| 2 | `content-type-hub` | A + B | S + **T** | Content Type Hub (publikace typu obsahu je tenantová) + sdílené sloupce `VS ISMS` (lektor); na B Autofill (Document processing PAYG) |
| 2 | `lists-registers-workflow` | A + B | S | na B Skills — jen pokud projde go/no-go, jinak demo lektora |
| 3 | `sensitivity-labels` | A | S + **T** | štítky jsou tenantové objekty; label policy scopovaná na vlastní skupinu |
| 3 | `dlp` | A | S | DLP politika v simulaci na vlastní web |
| 3 | `retention-lifecycle` | A | S + D | retenční politika na vlastní web; kurzovní záznamový štítek publikovaný lektorem ≥ 7 dní předem; SAM demo jen pokud je na tenantu (vyžaduje licenci Copilot / SAM Plan 1 / E7) |
| 4 | `conditional-access` | A | S | `test-<ini>`, report-only, vyloučené nouzové účty; Entra ID P2 pro risk-based |
| 4 | `privileged-access-pim` | A | S | PIM for Groups na `<ini>-isms-admins` (vlastník webu `isms-<ini>`); Entra ID P2 pro `test-<ini>` i schvalovatele |
| 4 | `audit-incident-response` | A | S | Audit zapnutý; připravená událost z dne 3 |
| 5 | `ai-agents-tenant` | B | S | vytvoření agenta uživatelem povoleno (viz go/no-go) |
| 5 | `normiqa-navigator-demo` | B | D | agent dostupný na Marketplace; nastavení externích vydavatelů a registr agentů na B; admin consent jen pokud agent žádá o oprávnění |
| 5 | `copilot-governance-dspm` | A + B | S + D | na A umístění Copilot v DLP; na B demo Copilota |
| 5 | `compliance-manager-capstone` | A | S | assessment ISO/IEC 27001:2022 nebo NIS2 dostupný |

## Go/no-go před během — otevřené položky

Podrobné kroky přípravy jsou v instruktorských poznámkách modulů a v
[`guide-priprava-tenantu.md`](./day-3/sensitivity-labels/guide-priprava-tenantu.md) (den 3).
Skripty a pořadí jejich spuštění: [`scripts/README.md`](./scripts/README.md).

### Tenant A — licence a identita

- [ ] **Licence na Developer tenantu.** Studentské účty i `test-*` mají E5 (vč. Purview)
      a Entra ID P2 — bez P2 nejsou risk-based CA ani PIM; P2 potřebují i **schvalovatelé**
      PIM (studentské účty).
- [ ] **Platnost Developer tenantu** nepadá do týdne kurzu.
- [ ] **Termín nekoliduje s SPO_DEV_1** — stejný tenant; kurzovní záznamový štítek je
      publikovaný do webů.
- [ ] **Security defaults vypnuté** (jinak nelze Conditional Access).
- [ ] **Microsoft-managed CA politiky** zkontrolované (Off, nebo vyloučené nouzové účty
      a lektor); termín jejich zapnutí ověřen v Message center.
- [ ] **Nouzové (break-glass) účty** a jejich skupina existují; lektor je má v lektorském
      souboru.
- [ ] **TAP politika** povolená pro `test-*` (max. platnost ≥ 4 h, vícenásobný TAP).
- [ ] **`New-CourseScope.ps1` proběhl** (T−10 dní, nejdřív `-WhatIf`): ve skupině
      `isms-<ini>-users` je student i `test-<ini>`; `test-<ini>` má licenci E5; soubor
      s dočasnými hesly ze `scripts/out/` je vytištěný na lístky a smazaný. MFA pro
      `test-<ini>` si registruje student v `onboarding`.
- [ ] **`New-IsmsWorkspace.ps1` vyzkoušený** na lektorském webu s `-AfterDay 2`: skupina
      `isms-<ini>-users` je v Members, `ControlledDocs` má přesně tři položky oprávnění,
      `ReportDeadline` ukazuje +24 h.
- [ ] **Adresy `isms-<ini>` jsou volné** — weby z minulého běhu odstraněné
      `Remove-CourseArtifacts.ps1 -PurgeDeletedSites` (smazaný web drží adresu v koši).
- [ ] **Přístup ne-adminů do Entra admin center** (PIM -> My roles pro `test-*`).

### Tenant A — SharePoint a Purview

- [ ] **Sdílené sloupce `VS ISMS`** v Content Type Hub (skript `New-IsmsHubColumns.ps1`).
- [ ] **Den 3 — příprava Purview** podle `guide-priprava-tenantu.md` (T−10 dní): štítky
      pro SharePoint a kontejnery zapnuté, kurzovní taxonomie a policy
      `GOC248 - kurzovni stitky` (jen `isms-<ini>-users`, zdůvodnění zapnuté), kurzovní
      záznamový štítek `GOC248 ISMS zaznam` publikovaný; úterý večer viditelný na webech
      `isms-<ini>`.
- [ ] **Schéma štítků** (modern / classic) zjištěné; **nemigrovat** — je to nevratné.
- [ ] **Audit zapnutý**; ráno dne 4 je stopa z dne 3 vyhledatelná, latence zapsaná s datem;
      lektorské náhradní události připravené odpoledne dne 3.
- [ ] **DLP umístění „Microsoft 365 Copilot and Copilot Chat"** je na tenantu bez Copilota
      dostupné ke konfiguraci (`copilot-governance-dspm`).
- [ ] **DSPM** — lektor předem projde první nastavení.
- [ ] **Compliance Manager** — šablona ISO/IEC 27001:2022 dostupná; čítač „Free regulation
      licenses used" (tenant sdílí SPO_DEV_1; E5 má 3 prémiové šablony); lektorský
      assessment `LEKTOR-ISO27001-2022` připravený.
- [ ] **Úklid po předchozím běhu** hotový (viz níž).

### Tenant B

- [ ] **Termín nekoliduje** s GOC224 na stejném tenantu a rozsah účtů `user.NN` je volný.
- [ ] **Copilot PAYG** — billing policy připojená ke službě „SharePoint agents", všichni
      `user.NN` ve skupině policy; upozornění na rozpočet nastavené.
- [ ] **Document processing PAYG** zapnuté; **Autofill columns** dostupné na webech `isms-<ini>`.
- [ ] **Skills / Copilot in SharePoint** pro účet bez licence Copilot — Learn uvádí licenci
      Microsoft 365 Copilot. Neprojde-li, Skills jsou demo lektora.
- [ ] **Restricted SharePoint Search vypnuté** (jinak agent nemá SharePoint jako zdroj).
- [ ] **Agent Builder** — vytvoření a sdílení agenta uživatelem s PAYG ověřené; zapsané
      hodnoty Agents -> Settings (Sharing, Agent and plugin access, User access).
- [ ] **Normiqa Navigator** dostupný na Microsoft Marketplace a nainstalovatelný; lektor má
      roli AI Administrator.
- [ ] **`Build-SampleDocs.ps1` skončil `Verify: OK`** a `New-SampleDocsSite.ps1` proběhl;
      namátkou jeden web: 7 dokumentů v `Dokumentace`, student ve skupině vlastníků, žádná
      skupina typu „Everyone"; demo web pro oversharing připravený.
- [ ] **Vygenerované `.docx` otevře Word pro web a zpracuje Autofill** — vznikly bez Wordu,
      neověřeno.
- [ ] **Spotřeba kreditů na studenta** změřená při zkušebním průchodu (zatím žádné číslo).

### Ověřovací kolo (prosinec 2026)

- [ ] Licenční tabulka v [`GLOSSARY.md`](./GLOSSARY.md) znovu proti service descriptions.
- [ ] Vyřazení DSPM (classic) a aktuální podoba DSPM.
- [ ] Ceny Autofill columns a Copilot PAYG.
- [ ] Znění vyhlášky č. 410/2025 Sb. na e-Sbírce (paragrafy jsou zatím ověřené jen přes
      materiály NÚKIB) a aktuální verze metodik NÚKIB k hlášení a významnosti.
- [ ] **Zkušební průchod labů na čistém účtu** — každý `instructor-notes.md` označuje kroky
      „neověřeno na tenantu".

## Úklid po běhu

Skript [`scripts/Remove-CourseArtifacts.ps1`](./scripts/Remove-CourseArtifacts.ps1) uklidí
weby, skupiny a testovací uživatele a vypíše kontrolní seznam toho, co se maže ručně.
Pořadí je závazné, protože záznamy a retence blokují mazání:

1. **Retence a záznamy** — odebrat retenční politiky studentů a kurzovní publikační politiku,
   zamknout odemčené záznamy, odebrat záznamové štítky jako správce webu (postup v
   `guide-priprava-tenantu.md`).
2. **Štítky** — label policies, pak štítky (nejdřív zrušit publikaci a počkat).
3. **DLP a auto-labeling** politiky `<ini>-*`, `LEKTOR-DLP-demo`.
4. **CA politiky `*-CA0*`** — smazat (limit 240 politik na tenant platí i pro report-only).
5. **Skupiny `*-isms-admins`** — smazat; ze správy PIM je vyjmout nelze.
6. **Compliance Manager** — smazat assessmenty `<ini>-*`; skupiny `<ini>-ISMS` smazat **nelze**.
7. **Weby `isms-*`, skupiny `isms-*-users`, uživatelé `test-*`** — skriptem.
8. **Tenant B** — weby `isms-*`, dokumenty `KAN-<ini>`, agenti studentů, agent Normiqa
   Navigator; vrátit nastavení agentů změněná pro demo (tenant sdílí GOC224).
