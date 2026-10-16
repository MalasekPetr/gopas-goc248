# Srovnání · Global Administrator vs. role, které by stačily

Podklad pro krok 10 labu [`lab-pim-for-groups.md`](lab-pim-for-groups.md) a pro dokument
**Návrh rolí** ve workspace. Rozhodovací osa: **nejmenší role, se kterou úkol jde udělat** — ne
„role, se kterou to určitě projde".

> [!IMPORTANT] Pravidlo tabulky
> Řádek s odkazem = role ověřená na Learn (stav 2026-10). Řádek s **ověřit** = role zatím
> neověřená; do Návrhu rolí se nesmí přepsat jako fakt. Na Tenant A nic z toho nebylo
> vyzkoušeno — kurz běží pod Global Administratorem.

## Entra role a role groups Purview — dva různé systémy

- **Role Microsoft Entra** (Conditional Access Administrator, Reports Reader, ...) se přiřazují
  v Entra admin center a jdou řídit přes PIM.
- **Role groups Purview** (Audit Reader, Information Protection Admins, ...) se přiřazují
  v Purview portálu → Settings → Roles and scopes. Některé role Entra se na role groups Purview
  mapují (např. Compliance Administrator) a přiřazení role Entra má přednost před omezeným
  přiřazením v Purview
  ([Permissions in the Microsoft Purview portal](https://learn.microsoft.com/en-us/purview/purview-permissions)).
- Purview umí u role groups **časově omezené přiřazení** (1 den až 2 roky, automatické
  odebrání) — není to PIM, ale je to stejná myšlenka (tamtéž).

## Tabulka po dnech kurzu

| Den | Co jsme dělali | Role, která by stačila | Zdroj / stav |
|---|---|---|---|
| 1 | prohlídka licencí a nastavení v admin centrech | **Global Reader** (jen čtení všeho, co vidí Global Administrator) | [Purview permissions](https://learn.microsoft.com/en-us/purview/purview-permissions) |
| 1 | založení webu `isms-<ini>` | bez role Entra, pokud je povolené samoobslužné zakládání webů; jinak SharePoint Administrator | **ověřit** (nastavení tenantu) |
| 2 | knihovny, schvalování, seznamy na vlastním webu | **vlastník webu** (oprávnění SharePointu, ne role Entra) | **ověřit** pro schvalovací tok |
| 2 | publikace typu obsahu z Content Type Hub | SharePoint Administrator? | **ověřit** |
| 3 | sensitivity labels a label policy | role group **Information Protection Admins** (nebo Compliance Administrator) | [Get started with sensitivity labels](https://learn.microsoft.com/en-us/purview/get-started-with-sensitivity-labels) |
| 3 | DLP politika v simulaci | **Information Protection Admin** / Compliance administrator / Compliance data administrator | [Create and deploy DLP policy](https://learn.microsoft.com/en-us/purview/dlp-create-deploy-policy) |
| 3 | retenční politika | **Compliance Administrator** (nebo vlastní role group s rolí Retention Management) | [Get started with DLM](https://learn.microsoft.com/en-us/purview/get-started-with-data-lifecycle-management) |
| 4 | Conditional Access politiky | **Conditional Access Administrator** | [Least privileged roles by task](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/delegate-by-task) |
| 4 | TAP pro `test-<ini>` | **Authentication Administrator** (pro adminy Privileged Authentication Administrator) | tamtéž |
| 4 | povolení TAP v Authentication methods policy | **Authentication Policy Administrator** | tamtéž |
| 4 | čtení sign-in a audit logů Entra | **Reports Reader** | tamtéž |
| 4 | založení skupiny `<ini>-isms-admins` | **Groups Administrator** | tamtéž |
| 4 | PIM for Groups na vlastní skupině | **vlastník skupiny** (pro skupinu, která není role-assignable), jinak Groups Administrator / Identity Governance Administrator | [Configure PIM for Groups settings](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/groups-role-settings) |
| 4 | PIM pro role Entra (demo lektora) | **Privileged Role Administrator** | [Least privileged roles by task](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/delegate-by-task) |
| 4 | vyhledávání v Purview Audit | role group **Audit Reader** (jen hledání a export) | [Get started with auditing](https://learn.microsoft.com/en-us/purview/audit-get-started) |
| 4 | prohlídka incidentů v Microsoft Defender | **ověřit** | — |
| 5 | Compliance Manager — assessment, důkazy | **Compliance Manager Contribution** (nebo role Entra Compliance Administrator) | [Compliance Manager setup](https://learn.microsoft.com/en-us/purview/compliance-manager-setup) |
| 5 | DLP pro Microsoft 365 Copilot | stejné jako DLP výše | [Create and deploy DLP policy](https://learn.microsoft.com/en-us/purview/dlp-create-deploy-policy) |
| 5 | DSPM | **ověřit** | — |

## Co z toho plyne

- **Žádný ověřený úkol kurzu nepotřebuje Global Administratora.** I přidělování rolí má
  užší roli: pro správu přiřazení rolí uvádí Learn jako nejmenší roli Privileged Role
  Administrator ([Least privileged roles by task](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/delegate-by-task)).
  Řádky „ověřit" mohou závěr ještě změnit.
- Stálí Global Administratoři ve Vltava Servis: **nouzové účty** (trvale aktivní, podle Learn)
  a nejvýš malý počet osob s **eligible** rolí přes PIM — viz
  [Manage emergency access accounts](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/security-emergency-access).
- Bez Entra ID P2 (Business Premium, E3) zbývá: méně stálých adminů, užší role a ruční revize —
  a v SoA to říct.
