# Glosář — závazné názvosloví

Jediný zdroj pravdy pro právní a normativní pojmy, produktové názvy a licenční realitu.
Všechny moduly se odkazují sem.

> [!WARNING] Ověřit k datu běhu — stav k 2026-10.
> Licenční balíčky a názvy Microsoftu se mění po měsících, metodiky NÚKIB se verzují. Před
> každým během projet položky s tímto markerem.

## Právní a normativní pojmy

| Pojem | Zkratka / číslo | Poznámka |
|---|---|---|
| Zákon o kybernetické bezpečnosti | zákon č. 264/2025 Sb. | český zákon transponující směrnici NIS2; účinný od 2025-11-01 |
| Vyhláška o bezpečnostních opatřeních pro režim nižších povinností | vyhláška č. 410/2025 Sb. | obsah a zavádění opatření, významnost dopadu incidentu (§ 14); **režim scénáře Vltava Servis** |
| Vyhláška o Portálu NÚKIB | vyhláška č. 334/2025 Sb. | forma a způsob hlášení přes Portál NÚKIB |
| Národní úřad pro kybernetickou a informační bezpečnost | NÚKIB | dozorový orgán, příjemce hlášení incidentů |
| Režim povinností | vyšší / nižší | rozsah opatření a hlášení; zařazení je látka GOC240 |
| Prvotní hlášení incidentu | — | bez zbytečného odkladu, **nejpozději do 24 h** od vyhodnocení události jako incidentu ([NÚKIB, podpůrný materiál k hlášení](https://portal.nukib.gov.cz/storage/uploads/2025/10/20/podpurny-material-hlaseni-incidentu_uid_68f623d0afd51.pdf)) |
| ISO/IEC 27001:2022 | ISO 27001 | norma pro ISMS; kap. 4–10 = požadavky na systém řízení, Annex A = katalog opatření |
| Annex A — témata | A.5–A.8 | A.5 organizační, A.6 lidská, A.7 fyzická, A.8 technologická opatření |
| Prohlášení o aplikovatelnosti | SoA | které opatření Annex A se aplikují a proč (kap. 6.1.3); **páteř nosné linky kurzu** |
| Systém řízení bezpečnosti informací | ISMS | aktiva, rizika, opatření, dokumentace, přezkoumání |
| Dokumentované informace | — | ISO kap. 7.5 — dokumenty a záznamy pod řízením (verze, schválení, přístup, uchování) |

> [!WARNING] Ověřit k datu běhu — stav k 2026-10.
> Číslo vyhlášky pro režim **vyšších** povinností doplnit z e-Sbírky; kurz s ní nepracuje,
> ale studenti z regulovaných subjektů v režimu vyšších povinností se na ni zeptají.

> [!IMPORTANT] Nezaměňovat — právní vs. normativní
> Zákon č. 264/2025 Sb. je **právní povinnost** (dozoruje a sankcionuje NÚKIB). ISO/IEC 27001
> je **dobrovolná norma** a certifikace. Kurz je učí společně, protože ISO 27001 je běžná cesta,
> jak opatření systematicky zavést a doložit — ale „soulad s NIS2" ≠ „certifikace ISO 27001".

## Produktové názvy (Microsoft)

| Používat | Dřívější názvy | Rozsah | V kurzu |
|---|---|---|---|
| **Microsoft Purview portál** | Microsoft 365 compliance center | portál pro Information Protection, DLP, DLM, Audit, Compliance Manager, DSPM | D3–D5 |
| **Purview Information Protection** | Azure Information Protection, MIP | klasifikace, sensitivity labels, šifrování, štítky kontejnerů | `sensitivity-labels` |
| **Purview Data Loss Prevention (DLP)** | — | politiky proti úniku dat | `dlp`, `copilot-governance-dspm` |
| **Purview Data Lifecycle Management (DLM)** | retention, records management | retenční politiky a štítky, records, holds | `retention-lifecycle` |
| **Purview Records Management** | — | prohlášení záznamu, disposition review | `retention-lifecycle` |
| **Purview Audit (Standard / Premium)** | Unified Audit Log | auditní záznamy jako zdroj důkazů | `audit-incident-response` |
| **Purview Data Security Posture Management (DSPM)** | DSPM for AI, Microsoft Purview AI Hub | viditelnost a řízení rizik dat vč. AI | `copilot-governance-dspm` |
| **Purview Compliance Manager** | — | assessments, improvement actions, compliance score; šablony ISO/IEC 27001:2022 a NIS2 | `compliance-manager-capstone` |
| **SharePoint Advanced Management (SAM)** | součást SharePoint Premium | governance webů, oversharing, site lifecycle | `document-libraries-governance`, `retention-lifecycle` |
| **Microsoft Entra Conditional Access** | Azure AD Conditional Access | politiky podmíněného přístupu vč. risk-based | `conditional-access` |
| **Microsoft Entra ID Protection** | Azure AD Identity Protection | detekce rizika uživatele a přihlášení | `conditional-access` |
| **Microsoft Entra Privileged Identity Management (PIM)** | Azure AD PIM | just-in-time přístup k rolím a skupinám (PIM for Groups) | `privileged-access-pim` |
| **Microsoft Defender XDR** | Microsoft 365 Defender | sjednocená detekce a incidenty | `audit-incident-response` (přehled) |
| **Microsoft 365 Copilot** | — | AI asistent nad daty tenantu, respektuje oprávnění | D5 |
| **Declarative agent** | — | agent nad Copilotem: instrukce + zdroje znalostí | `ai-agents-tenant` |
| **Autofill columns** | součást Syntex / SharePoint Premium | AI vyplní metadata sloupce z obsahu dokumentu | `content-type-hub` (Tenant B) |
| **Skills (Copilot in SharePoint)** | — | rozšíření Copilota v SharePointu | `lists-registers-workflow` (Tenant B) |

> [!IMPORTANT] Názvosloví
> **DSPM for AI -> Data Security Posture Management.** Purview sloučil DSPM a DSPM for AI do
> jednoho prostředí; původní verze jsou v UI označené „(classic)". Datum vyřazení classic verzí
> uvádějí zdroje rozporně — ověřit na Learn (ověřovací kolo 2026-12).

> [!IMPORTANT] Názvosloví
> **Legacy risk politiky ID Protection -> risk-based Conditional Access.** Původní user risk
> a sign-in risk politiky v ID Protection byly vyřazeny k 2026-10-01; risk se vyhodnocuje dál,
> ale reaguje na něj jen politika Conditional Access
> ([Learn: risk policies](https://learn.microsoft.com/en-us/entra/id-protection/howto-identity-protection-configure-risk-policies)).

> [!IMPORTANT] Nezaměňovat — tři pilíře Purview
> **Information Protection** (jak je to klasifikované) ≠ **DLP** (co nesmí odejít) ≠
> **Data Lifecycle Management** (jak dlouho se to drží). Proto tři samostatné bloky v D3.

> [!IMPORTANT] Nezaměňovat — dvakrát „lifecycle"
> **SAM site lifecycle** (weby: neaktivní weby, atestace vlastníků) ≠ **Purview Data Lifecycle
> Management** (obsah: retence, záznamy, likvidace). Stejné slovo, jiný objekt správy.

## Normiqa Navigator

**Normiqa Navigator** — agent produktu **Normiqa** (Malach IS), dostupný z Microsoft
Marketplace. V kurzu jediný jmenovitý produkt Malach IS, a to jako referenční příklad hotového
agenta v bloku `normiqa-navigator-demo`. Pravidla neutrality v
[`CONVENTIONS.md`](./CONVENTIONS.md).

## Licenční realita napříč pilíři

> [!WARNING] Ověřit k datu běhu — stav k 2026-10. Tabulka je NEOVĚŘENÁ.
> Převzatá z pracovní verze kurzu (2026-07) a dosud neprošla ověřením proti
> [Microsoft Purview service description](https://learn.microsoft.com/en-us/office365/servicedescriptions/microsoft-365-service-descriptions/microsoft-365-tenantlevel-services-licensing-guidance/microsoft-purview-service-description).
> Každý řádek dostane odkaz v `requirements-mapping-m365`; do té doby se z ní nesmí učit.

| Pilíř | Business Premium | E3 | E5 / add-on |
|---|---|---|---|
| Knihovny, verzování, schvalování, Content Type Hub | ano | ano | ano |
| Sensitivity labels — ruční | ano | ano | ano |
| Sensitivity labels — automatické (služba) | ? | ? | E5 / add-on |
| DLP — SharePoint, OneDrive, Exchange, Teams | ? | ano | ano |
| DLP — Endpoint | ? | ? | E5 / add-on |
| Retenční politiky a štítky | ? | ano | ano |
| Records management, adaptive scopes | ? | ? | E5 / add-on |
| Audit Standard / Premium | ano / ? | ano / ? | ano / ano |
| Conditional Access | ano (Entra ID P1) | ano (Entra ID P1) | ano |
| Risk-based CA, PIM | ne | ne | Entra ID P2 |
| Compliance Manager — šablony mimo základní | ? | ? | E5 Compliance / add-on |
| DSPM | ? | ? | ? |
| Autofill columns | PAYG | PAYG | PAYG |
| Copilot, Skills, agenti | licence Copilot nebo PAYG | licence Copilot nebo PAYG | licence Copilot nebo PAYG |

`?` = otevřená otázka k ověření, ne „ne".

### Dva PAYG modely — nezaměňovat

| Model | Co platí | Kde v kurzu |
|---|---|---|
| **Document processing PAYG** | Autofill columns a další zpracování dokumentů; $0,005 za stránku ([Learn: Autofill](https://learn.microsoft.com/microsoft-365/syntex/autofill-overview)) | `content-type-hub` (Tenant B) |
| **Copilot PAYG** | Copilot Chat s agenty, Skills | `lists-registers-workflow`, D5 (Tenant B) |

Obě metriky jdou přes připojenou Azure subscription, ale jsou to dvě různá nastavení
a dva různé účty v rozpočtu. Cenu ověřit k datu běhu.

## Portály a nástroje

| Nástroj | Role v kurzu |
|---|---|
| **SharePoint admin center** | Content Type Hub, SAM, nastavení webů |
| **Microsoft Purview portál** | Information Protection, DLP, DLM, Audit, Compliance Manager, DSPM |
| **Microsoft Entra admin center** | Conditional Access, PIM, ID Protection |
| **Microsoft 365 admin center** | licence, PAYG (Tenant B), nasazení agentů |
| **PnP PowerShell** | jen skripty kurzu (zakládání workspace); studenti s ním nepracují |

Kurz je **portálový**. PowerShell je nástroj lektora pro přípravu prostředí, ne obsah kurzu.
