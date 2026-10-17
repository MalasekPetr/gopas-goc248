# Samostudium a mapování na katalog

Co z katalogové osnovy se v běhu odučí kde, co se neodučí a kde to student najde.

## Mapování katalogových položek na moduly

Katalog GOC248 má 5 tematických celků a 19 položek bez časových dotací.

| Katalogová položka | Kde v kurzu | Poznámka |
|---|---|---|
| **Rámec a ISMS základy** | | |
| Onboarding a přístup do tenantu, kde se objeví AI | `onboarding` (D1) | přístup do **obou** tenantů |
| NIS2 (264/2025 Sb.) a ISO 27001:2022 prakticky — NÚKIB, lhůty, sankce | `nis2-iso27001-fundamentals` (D1) | **zkráceno na 60 min** — právní výklad je předpoklad (GOC240) |
| Mapovací matice požadavek -> capability M365, licenční realita | `requirements-mapping-m365` (D1) | |
| Návrh ISMS v M365, AI jako pomocník při návrhu | `isms-design-m365` (D1) | |
| Lab: struktura ISMS workspace | `isms-design-m365` (D1) | |
| **Řízená ISMS dokumentace v SPO a Lists** | | |
| Knihovny: verzování, schvalování, řízení přístupu | `document-libraries-governance` (D2) | základy knihoven jsou předpoklad (GOC222) |
| Lab: knihovna s verzováním a schvalováním | `document-libraries-governance` (D2) | |
| Content Type Hub, standardizace politik, Autofill columns | `content-type-hub` (D2) | Autofill na Tenant B |
| Lists: Asset Register, Risk Register, SoA, incident log | `lists-registers-workflow` (D2) | |
| Lab: Asset a Risk Register s revizním workflow, Copilot Skills | `lists-registers-workflow` (D2) | Skills jako demo lektora na Tenant B — vyžadují licenci Microsoft 365 Copilot, studentské PAYG účty ji nemají |
| **Klasifikace a Information Protection** | | |
| Sensitivity labels: taxonomie, ruční vs. automatické | `sensitivity-labels` (D3) | |
| Lab: taxonomie a aplikace na ISMS knihovnu | `sensitivity-labels` (D3) | |
| DLP napříč M365: politiky, simulace, incidenty | `dlp` (D3) | |
| Lab: DLP politika v simulačním režimu | `dlp` (D3) | |
| Retence, lifecycle, records management, srovnání se SAM | `retention-lifecycle` (D3) | |
| Lab: retenční politika pro ISMS záznamy | `retention-lifecycle` (D3) | |
| **Identita, detekce a incidenty** | | |
| Conditional Access: návrh, MFA, break-glass | `conditional-access` (D4) | **+ risk-based politiky** (přesunuto z PIM, viz níže) |
| Lab: sada CA politik vč. MFA pilotu | `conditional-access` (D4) | report-only, vlastní scope |
| PIM a Identity Protection | `privileged-access-pim` (D4) | ID Protection jako zdroj rizika; politiky v `conditional-access` |
| Lab: konfigurace PIM | `privileged-access-pim` (D4) | PIM for Groups |
| Unified Audit Log, hlášení do 24 h NÚKIB | `audit-incident-response` (D4) | |
| Lab: dohledání události a podklad pro hlášení | `audit-incident-response` (D4) | |
| **AI a důkazování souladu** | | |
| AI agenti v tenantu: datová hranice vs. shadow AI, declarative agents | `ai-agents-tenant` (D5) | |
| Lab: compliance agent nad ISMS knihovnou | `ai-agents-tenant` (D5) | Tenant B, nad kopií dokumentace |
| Hotový agent z Marketplace — Normiqa Navigator | `normiqa-navigator-demo` (D5) | demo lektora, 30 min |
| Governance Copilotu: DSPM, štítky a DLP pro Copilot, admin consent | `copilot-governance-dspm` (D5) | konfigurace na A, demo na B |
| Compliance Manager: assessments, improvement actions, score | `compliance-manager-capstone` (D5) | |
| Capstone: artefakty na kontroly, report stavu souladu | `compliance-manager-capstone` (D5) | |

## Posuny proti katalogu

| Co | Proč |
|---|---|
| NIS2 a ISO 27001 jen 60 min | katalog uvádí GOC240 jako předpoklad; opakovat právní výklad by vzalo čas labům |
| Risk-based politiky v `conditional-access`, ne v `privileged-access-pim` | legacy politiky ID Protection byly vyřazeny k 2026-10-01; risk-based přístup je dnes politika CA |
| PIM přes PIM for Groups | nastavení PIM pro role Entra je tenantové a 15 studentů by se přepisovalo |
| Governance Copilotu na dvou tenantech | Tenant B nemá licence Purview, Tenant A nemá Copilot |

## Co se v kurzu neodučí

| Téma | Proč ne | Kde dál |
|---|---|---|
| Zařazení do režimu povinností, právní výklad zákona | předpoklad kurzu | GOC240; [NÚKIB](https://nukib.gov.cz/) |
| Základy správy SharePoint Online | předpoklad kurzu | GOC222 |
| Insider Risk Management, Communication Compliance | nejsou v katalogu GOC248; v pracovní verzi kurzu byly | Microsoft Learn — Purview |
| Endpoint DLP | vyžaduje onboarding zařízení; učební stroje nejsou pod správou tenantu | Microsoft Learn — Endpoint DLP |
| Microsoft Defender XDR do hloubky, Microsoft Sentinel | detekce je v kurzu jen jako zdroj podkladů pro hlášení | samostatné bezpečnostní kurzy |
| Adaptive scopes v retenci | nad rámec času; v labu statický scope na vlastní web | Microsoft Learn — DLM |
