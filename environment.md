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
> Každá interakce s Copilotem a každá stránka zpracovaná Autofill columns se účtuje. Před
> během nastavit rozpočtový alert na Azure subscription a odhadnout spotřebu na skupinu.

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
| 2 | `content-type-hub` | A + B | S + **T** | Content Type Hub (publikace typu obsahu je tenantová); na B Autofill (Document processing PAYG) |
| 2 | `lists-registers-workflow` | A + B | S | na B Skills (Copilot PAYG) |
| 3 | `sensitivity-labels` | A | S + **T** | štítky jsou tenantové objekty; label policy scopovaná na vlastní skupinu |
| 3 | `dlp` | A | S | DLP politika v simulaci na vlastní web |
| 3 | `retention-lifecycle` | A | S | retenční politika na vlastní web; SAM jen demo |
| 4 | `conditional-access` | A | S | `test-<ini>`, report-only, vyloučené nouzové účty; Entra ID P2 pro risk-based |
| 4 | `privileged-access-pim` | A | S | PIM for Groups na `isms-<ini>-users`; Entra ID P2 |
| 4 | `audit-incident-response` | A | S | Audit zapnutý; připravená událost z dne 3 |
| 5 | `ai-agents-tenant` | B | S | vytvoření agenta uživatelem povoleno (viz go/no-go) |
| 5 | `normiqa-navigator-demo` | B | D | agent dostupný na Marketplace, admin consent lektora |
| 5 | `copilot-governance-dspm` | A + B | S + D | na A umístění Copilot v DLP; na B demo Copilota |
| 5 | `compliance-manager-capstone` | A | S | assessment ISO/IEC 27001:2022 nebo NIS2 dostupný |

## Go/no-go před během — otevřené položky

**Tenant A**

- [ ] **Licence na Developer tenantu.** Ověřit, že studentské účty mají E5 (vč. Purview)
      a Entra ID P2 — bez P2 nejsou risk-based CA ani PIM.
- [ ] **Platnost Developer tenantu** nepadá do týdne kurzu.
- [ ] **Security defaults vypnuté** (jinak nelze Conditional Access).
- [ ] **Nouzové (break-glass) účty** existují a lektor je má v lektorském souboru.
- [ ] **Skupiny `isms-<ini>-users` a uživatelé `test-<ini>`** založené skriptem.
- [ ] **Audit zapnutý** a události z předchozího dne v něm dohledatelné (latence ingestu
      ověřit a zapsat s datem).
- [ ] **Compliance Manager**: dostupnost šablon ISO/IEC 27001:2022 a NIS2 na tenantu.
- [ ] **DLP umístění pro Microsoft 365 Copilot** je v Purview na tenantu bez Copilota
      dostupné ke konfiguraci (`copilot-governance-dspm`).
- [ ] **Úklid po předchozím běhu**: weby `isms-*`, politiky s prefixem studentů, štítky,
      CA politiky, PIM přiřazení.

**Tenant B**

- [ ] **Termín nekoliduje** s jiným kurzem na stejném tenantu (GOC224) a rozsah účtů
      `user.NN` je pro tento běh volný.
- [ ] **Copilot PAYG** a **Document processing PAYG** zapnuté, rozpočtový alert nastavený.
- [ ] **Autofill columns** dostupné na webech `isms-<ini>`.
- [ ] **Skills v Copilot in SharePoint** dostupné uživateli bez admin role.
- [ ] **Vytvoření a sdílení declarative agenta** běžným uživatelem povoleno — jinak
      `ai-agents-tenant` skončí agentem jen pro autora (přijatelné, ale říct předem).
- [ ] **Normiqa Navigator** dostupný na Microsoft Marketplace a nainstalovatelný.
- [ ] **Weby `isms-<ini>` s kopií vzorové dokumentace** založené skriptem.

**Ověřovací kolo (prosinec 2026)**

- [ ] Licenční tabulka v [`GLOSSARY.md`](./GLOSSARY.md) ověřená proti service descriptions.
- [ ] Vyřazení DSPM (classic) a aktuální podoba DSPM.
- [ ] Cena Autofill columns a Copilot PAYG.
- [ ] Aktuální znění vyhlášky č. 410/2025 Sb. a metodik NÚKIB k hlášení a významnosti.
- [ ] **Zkušební průchod labů na čistém účtu** — každý `instructor-notes.md` označuje kroky
      „neověřeno na tenantu".

## Úklid po běhu

Po kurzu zůstane na Tenant A: web `isms-<ini>` na studenta, štítky a label policies, DLP
a retenční politiky, CA politiky a PIM nastavení s prefixy studentů, assessmenty v Compliance
Manageru. Na Tenant B: weby `isms-<ini>` a agenti studentů. Úklidový skript je otevřená
položka (plán: `scripts/Remove-CourseArtifacts.ps1`).
