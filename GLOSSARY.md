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
| Národní úřad pro kybernetickou a informační bezpečnost | NÚKIB | dozorový orgán; v režimu nižších povinností se incident hlásí Národnímu CERT (důvodová zpráva k vyhl. č. 410/2025 Sb.), prakticky přes Portál NÚKIB |
| Režim povinností | vyšší / nižší | rozsah opatření a hlášení; zařazení je látka GOC240 |
| Prvotní hlášení incidentu | — | bez zbytečného odkladu, **nejpozději do 24 h od zjištění incidentu** (pravidlo kurzu podle [návodu NÚKIB pro nižší režim, 2026-08](https://portal.nukib.gov.cz/informacni-servis/podpurne-materialy/6a1d9256fc2a7b93040173db)); v režimu nižších povinností jen incidenty s významným dopadem ([NÚKIB, Hlášení kybernetických bezpečnostních incidentů, v1.2](https://portal.nukib.gov.cz/storage/uploads/2026/06/08/podpurny-material-ke-hlaseni-incidentu_v1-2_uid_6a267e393778b.pdf) — tam starší formulace „od vyhodnocení události jako incidentu"; viz `audit-incident-response`). Závěrečná zpráva do 30 dnů od vyřešení |
| ISO/IEC 27001:2022 | ISO 27001 | norma pro ISMS; kap. 4–10 = požadavky na systém řízení, Annex A = katalog opatření |
| Annex A — témata | A.5–A.8 | A.5 organizační, A.6 lidská, A.7 fyzická, A.8 technologická opatření |
| Prohlášení o aplikovatelnosti | SoA | které opatření Annex A se aplikují a proč (kap. 6.1.3); **páteř nosné linky kurzu** |
| Přehled bezpečnostních opatření | — | vyhl. č. 410/2025 Sb., § 3 odst. 2 a příloha č. 1 — u nezavedených opatření stav, termín, priorita, odpovědná osoba; v kurzu tvoří jeden seznam se SoA |
| Systém řízení bezpečnosti informací | ISMS | aktiva, rizika, opatření, dokumentace, přezkoumání |
| Dokumentované informace | — | ISO kap. 7.5 — dokumenty a záznamy pod řízením (verze, schválení, přístup, uchování) |

> [!NOTE] Režim vyšších povinností
> Bezpečnostní opatření pro režim vyšších povinností stanoví vyhláška č. 409/2025 Sb.
> (NÚKIB, Manuál pro režim nižších povinností v1.1, kap. 3.2). Kurz s ní nepracuje.

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
| **Purview Compliance Manager** | — | assessments, improvement actions, compliance score; šablony ISO/IEC 27001:2022 a NIS2 jsou prémiové (A5/E5/G5: 3 prémiové šablony zdarma); šablona „Act No. 181" je k předchozímu zákonu, ne k 264/2025 Sb. | `compliance-manager-capstone` |
| **SharePoint Advanced Management (SAM)** | dříve součást SharePoint Premium; dnes s licencí Copilot, add-onem SAM Plan 1 nebo E7 | governance webů, oversharing, site lifecycle | `document-libraries-governance`, `retention-lifecycle` |
| **Microsoft Entra Conditional Access** | Azure AD Conditional Access | politiky podmíněného přístupu vč. risk-based | `conditional-access` |
| **Microsoft Entra ID Protection** | Azure AD Identity Protection | detekce rizika uživatele a přihlášení | `conditional-access` |
| **Microsoft Entra Privileged Identity Management (PIM)** | Azure AD PIM | just-in-time přístup k rolím a skupinám (PIM for Groups) | `privileged-access-pim` |
| **Microsoft Defender XDR** | Microsoft 365 Defender | sjednocená detekce a incidenty | `audit-incident-response` (přehled) |
| **Microsoft 365 Copilot** | — | AI asistent nad daty tenantu, respektuje oprávnění | D5 |
| **Declarative agent** | — | agent nad Copilotem: instrukce + zdroje znalostí | `ai-agents-tenant` |
| **Autofill columns** | součást Syntex / SharePoint Premium | AI vyplní metadata sloupce z obsahu dokumentu | `content-type-hub` (Tenant B) |
| **Skills (Copilot in SharePoint)** | — | rozšíření Copilota v SharePointu; vyžaduje licenci Microsoft 365 Copilot | `lists-registers-workflow` (demo lektora, Tenant B) |

> [!IMPORTANT] Názvosloví
> **DSPM for AI a DSPM -> Data Security Posture Management (DSPM).** Předchozí verze jsou
> v portálu označené „DSPM for AI (classic)" a „Data Security Posture Management (classic)"
> ([Learn](https://learn.microsoft.com/en-us/purview/dspm-task-mapping)). Learn k 2026-10-17
> datum vyřazení classic verzí neuvádí; Message Center uvádí okno 2026-11-30 až 2026-12-31 —
> ověřit na Learn v ověřovacím kole 2026-12.

> [!IMPORTANT] Názvosloví
> **Microsoft 365 Copilot -> Microsoft Copilot, Microsoft 365 Copilot Chat -> Microsoft Copilot
> Chat** ([Learn: enterprise data protection](https://learn.microsoft.com/en-us/microsoft-365/copilot/enterprise-data-protection),
> ms.date 2026-05-29). V UI, licencích a starší dokumentaci se drží i staré názvy.

> [!IMPORTANT] Názvosloví
> **Legacy risk politiky ID Protection -> risk-based Conditional Access.** Původní user risk
> a sign-in risk politiky v ID Protection byly vyřazeny k 2026-10-01; risk se vyhodnocuje dál,
> ale reaguje na něj jen politika Conditional Access
> ([Learn: risk policies](https://learn.microsoft.com/en-us/entra/id-protection/howto-identity-protection-configure-risk-policies)).

> [!IMPORTANT] Názvosloví
> **Parent label / sublabels -> label groups (modern label scheme).** Tenanty založené od
> 2025-10-01 ho mají automaticky; migrace staršího tenantu je nevratná
> ([Learn](https://learn.microsoft.com/en-us/purview/migrate-sensitivity-label-scheme)).

> [!IMPORTANT] Nezaměňovat — tři pilíře Purview
> **Information Protection** (jak je to klasifikované) ≠ **DLP** (co nesmí odejít) ≠
> **Data Lifecycle Management** (jak dlouho se to drží). Proto tři samostatné bloky v D3.

> [!IMPORTANT] Nezaměňovat — dvakrát „lifecycle"
> **SAM site lifecycle** (weby: neaktivní weby, atestace vlastníků) ≠ **Purview Data Lifecycle
> Management** (obsah: retence, záznamy, likvidace). Stejné slovo, jiný objekt správy.

## Normiqa Navigator

**Normiqa Navigator** — agent produktu **Normiqa** (Malach IS), nabízený přes
[Microsoft Marketplace](https://marketplace.microsoft.com/en-us/product/wa200011233?tab=overview)
(dostupnost ověřit před každým během). V kurzu jediný jmenovitý produkt Malach IS, a to jako referenční příklad hotového
agenta v bloku `normiqa-navigator-demo`. Pravidla neutrality v
[`CONVENTIONS.md`](./CONVENTIONS.md).

## Licenční realita napříč pilíři

> [!WARNING] Ověřit k datu běhu — stav k 2026-10. Ověřeno 2026-10-17.
> Zdroje a podrobnosti po řádcích:
> [`day-1/requirements-mapping-m365/comparison-licence.md`](./day-1/requirements-mapping-m365/comparison-licence.md).

| Pilíř | Business Premium | Microsoft 365 E3 | E5 / add-on |
|---|---|---|---|
| SharePoint Online (weby, knihovny, seznamy) | ano | ano | ano |
| Sensitivity labels — ruční | ano | ano | ano |
| Sensitivity labels — automatické (klient i služba), výchozí štítek knihovny | ne | ne | E5 / E5 Information Protection and Governance / Purview Suite |
| DLP — Exchange, SharePoint, OneDrive | ano | ano | ano |
| DLP — Teams | ne | ne | E5 / E5 IP&G / Purview Suite |
| DLP — Endpoint | ne | ne | E5 / E5 IP&G / Purview Suite |
| DLP pro Copilot — blokace zpracování souborů | ne | ne | E5 / E5 IP&G / Purview Suite |
| Retenční politiky; retenční štítky ruční | ano | ano | ano |
| Retenční štítky automatické / výchozí, adaptive scopes, records management | ne | ne | E5 / E5 IP&G / Purview Suite |
| Audit Standard / Premium | ano / add-on¹ | ano / add-on² | ano / ano |
| Conditional Access | ano (Entra ID P1) | ano (Entra ID P1)³ | ano |
| Risk-based CA, PIM vč. PIM for Groups | ne (add-on Defender Suite for BP) | ne (Entra ID P2) | ano (Entra ID P2) |
| Access reviews pro PIM for Groups | ne | ne | Microsoft Entra ID Governance |
| Compliance Manager — Data Protection Baseline | ano | ano | ano |
| Compliance Manager — šablony ISO/IEC 27001:2022, NIS2 | koupě | koupě | 3 prémiové zdarma |
| Activity explorer / Content explorer (UI) | ne | ne (data se sbírají) | E5 |
| SAM site lifecycle | ne | jen s Copilot / SAM Plan 1 | jen s Copilot / SAM Plan 1 / E7 |
| DSPM | ? | ? | ? ⁴ |
| Autofill columns | PAYG; s licencí Copilot součást Copilot in SharePoint | PAYG; dtto | PAYG; dtto |
| Copilot in SharePoint, Skills | licence Microsoft 365 Copilot | licence Microsoft 365 Copilot | licence Microsoft 365 Copilot |
| Copilot Chat s agenty, SharePoint agents | licence Copilot nebo PAYG | licence Copilot nebo PAYG | licence Copilot nebo PAYG |

¹ Microsoft Purview Suite for Business Premium (max. 300 míst). ² Microsoft 365 E5 eDiscovery
& Audit nebo Purview Suite. ³ Platí pro Microsoft 365 E3, ne Office 365 E3 (ta Entra ID P1
nemá). ⁴ Purview service description (2026-08-03) DSPM samostatně neuvádí.
`?` = otevřená otázka k ověření, ne „ne".

### Dva PAYG modely — nezaměňovat

| Model | Co platí | Kde v kurzu |
|---|---|---|
| **Document processing PAYG** | Autofill columns a další zpracování dokumentů ([Learn: Autofill](https://learn.microsoft.com/en-us/microsoft-365/documentprocessing/autofill-overview)); $0,005 za transakci = stránka Word/PDF/TIFF, list, snímek nebo soubor ([Learn: PAYG pricing](https://learn.microsoft.com/en-us/microsoft-365/documentprocessing/syntex-pay-as-you-go-services)) | `content-type-hub` (Tenant B) |
| **Copilot PAYG** | Copilot Chat s agenty, SharePoint agents, Retrieval API. **Ne Skills** — Copilot in SharePoint vyžaduje licenci Microsoft 365 Copilot | D5 (Tenant B) |

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
