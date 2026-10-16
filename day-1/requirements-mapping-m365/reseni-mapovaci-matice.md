# Řešení · Mapovací matice Vltava Servis

Referenční řešení k [`lab-mapovaci-matice.md`](lab-mapovaci-matice.md). Kdo nestihne, přepíše
řádky do sešitu `<ini>-mapovaci-matice` a pokračuje. Licence = Business Premium / Microsoft 365
E3 / Microsoft 365 E5 podle [`comparison-licence.md`](comparison-licence.md) (ověřeno
2026-10-17).

## Krok 4 — šest řádků

| Oblast | Vyhlaska | Neopominutelne | Opatreni ISO | Capability M365 | Licence BP / E3 / E5 | Blok kurzu |
|---|---|---|---|---|---|---|
| a) přehled bezpečnostních opatření | § 3 odst. 2, příloha č. 1 | ano | kap. 6.1.3, A.5.31 | seznam SoA (SharePoint) | ano / ano / ano | `isms-design-m365` |
| c) řízení aktiv | zákon; § 3 odst. 4 (technická aktiva) | ano (v rámci § 3) | A.5.9, A.5.10 | Asset Register (SharePoint seznam) | ano / ano / ano | `lists-registers-workflow` |
| d) řízení rizik | vyhláškou neupraveno (zákon § 14 odst. 2 písm. d) | — | kap. 6.1.2, 8.2 | Risk Register (SharePoint seznam) | ano / ano / ano | `lists-registers-workflow` |
| g) řízení přístupu | § 7 | ne (vyhodnotitelné) | A.5.15, A.5.18, A.8.2 | Conditional Access; PIM for Groups | ne / ne / ano (PIM, Entra ID P2) | `conditional-access`, `privileged-access-pim` |
| i) detekce a zaznamenávání | § 9 | ne (vyhodnotitelné) | A.8.15, A.8.16 | Purview Audit (Standard / Premium) | ano / ano / ano (Standard); ne / ne / ano (Premium) | `audit-incident-response` |
| j) řešení incidentů | § 10; § 14 | ano | A.5.24, A.5.25, A.5.26, A.5.28 | Incident log (SharePoint seznam); audit jako podklad | ano / ano / ano | `lists-registers-workflow`, `audit-incident-response` |

U řádku i) je nejnáročnější capability Audit (Premium) — pokud ho organizace pro podklad hlášení
potřebuje, je to v Business Premium add-on.

## Krok 5 — co Business Premium nezvládne

Tři z těchto (každá podle [`comparison-licence.md`](comparison-licence.md)):

| Funkce | Cesta podle zdroje |
|---|---|
| PIM for Groups, risk-based Conditional Access | Entra ID P2 — např. Microsoft Defender Suite for Business Premium |
| Audit (Premium) | Microsoft Purview Suite for Business Premium (max. 300 míst) |
| Automatické a výchozí sensitivity labels | E5 / E5 Information Protection and Governance / Purview Suite |
| Výchozí a automatické retenční štítky, records management | E5 / E5 Information Protection and Governance / Purview Suite |
| DLP pro Teams a Endpoint | E5 / E5 Information Protection and Governance / Purview Suite |
| Prémiové šablony Compliance Manageru (ISO/IEC 27001:2022, NIS2) | koupě šablony |

Conditional Access (Entra ID P1) a DLP pro Exchange, SharePoint a OneDrive Business Premium **má**.

## Krok 6 — otevřená otázka

DSPM: Purview service description (ms.date 2026-08-03) ho jako samostatnou položku neuvádí
a stránka DSPM considerations odkazuje zpět na service description. Proto „?" — chybí zdroj.
