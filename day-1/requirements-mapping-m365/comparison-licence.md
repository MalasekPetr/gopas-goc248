# Srovnání · Licenční realita napříč pilíři kurzu

Ověřená licenční tabulka pro funkce, se kterými kurz pracuje. Každý řádek má zdroj na
Microsoft Learn; datum ověření **2026-10-17**. Nahrazuje neověřenou tabulku v
[`../../GLOSSARY.md`](../../GLOSSARY.md) (sekce „Licenční realita napříč pilíři"), dokud ji
autor nepřevezme.

> [!WARNING] Ověřit k datu běhu — stav k 2026-10.
> Hlavní zdroj je [Microsoft Purview service description](https://learn.microsoft.com/en-us/office365/servicedescriptions/microsoft-365-service-descriptions/microsoft-365-tenantlevel-services-licensing-guidance/microsoft-purview-service-description)
> (ms.date 2026-08-03) a [Microsoft Entra licensing](https://learn.microsoft.com/en-us/entra/fundamentals/licensing)
> (ms.date 2026-06-18). Názvy add-onů se mění (např. „Microsoft Purview Suite",
> „Microsoft Defender Suite"); před během projít znovu.

## Jak tabulku číst

- **Ano / ne** jen podle toho, zda je plán **jmenovitě** uvedený ve sloupci nebo seznamu zdroje.
  „Ne" znamená „zdroj ho pro tuto funkci neuvádí", ne „nikdy a nijak".
- **Microsoft 365 E3, ne Office 365 E3.** Office 365 E3 neobsahuje Entra ID P1 — řádky
  Conditional Access a níže pro něj neplatí. U Purview funkcí uvádí zdroj Office 365 E3/E5
  často spolu s Microsoft 365 E3/E5; tabulka je nerozepisuje.
- **Add-on** = co zdroj jmenuje jako cestu k funkci bez E5. Kde zdroj žádný add-on pro Business
  Premium nejmenuje, je ve sloupci „—".
- `?` = otevřená otázka, ne „ne".

## Tabulka

| Funkce | Business Premium | Microsoft 365 E3 | Microsoft 365 E5 | Add-on bez E5 (jak ho jmenuje zdroj) | Zdroj — sekce |
|---|---|---|---|---|---|
| SharePoint Online jako služba (weby, knihovny, seznamy) | ano | ano | ano | — | [Plan options](https://learn.microsoft.com/en-us/office365/servicedescriptions/office-365-platform-service-description/office-365-plan-options) — *Service availability* |
| Sensitivity labels — ruční | ano | ano | ano | — | [Purview SD](https://learn.microsoft.com/en-us/office365/servicedescriptions/microsoft-365-service-descriptions/microsoft-365-tenantlevel-services-licensing-guidance/microsoft-purview-service-description) — *Information Protection sensitivity labeling* |
| Sensitivity labels — automatické (klient i služba) | ne | ne | ano | Microsoft 365 E5 Information Protection and Governance; Microsoft Purview Suite | Purview SD — *Information Protection sensitivity labeling* |
| Výchozí sensitivity label na knihovně SharePoint | ne | ne | ano | E5 Information Protection and Governance; Purview Suite | Purview SD — *Information Protection sensitivity labeling* |
| DLP — Exchange Online, SharePoint Online, OneDrive | ano | ano | ano | — | Purview SD — *DLP for Exchange Online, SharePoint Online, and OneDrive for Business* |
| DLP — Teams chat a kanály | ne | ne | ano | E5 Information Protection and Governance; Purview Suite | Purview SD — *DLP for Teams* |
| DLP — Endpoint | ne | ne | ano | E5 Information Protection and Governance; Purview Suite | Purview SD — *Endpoint Data Loss Protection* |
| DLP pro Copilot — zabránit zpracování souborů a e-mailů | ne | ne | ano | E5 Information Protection and Governance; Purview Suite | Purview SD — *DLP for Microsoft Copilot* |
| DLP pro Copilot — ochrana promptů | ano | ano | ano | — (všichni uživatelé Copilota a Copilot Chat) | Purview SD — *DLP for Microsoft Copilot* |
| Retenční politiky (celá organizace / umístění) | ano | ano | ano | — | Purview SD — *Licensing for retention policies* |
| Retenční štítky — vytvoření a publikace k ručnímu použití | ano | ano | ano | — | Purview SD — *Licensing for retention labels* / *label policies* |
| Retenční štítky — automatické použití, výchozí štítek na knihovně, adaptive scope | ne | ne | ano | E5 Information Protection and Governance; Purview Suite | Purview SD — *Licensing for retention label policies* |
| Records management — označit jako záznam, disposition review, file plan | ne | ne | ano | E5 Information Protection and Governance; Purview Suite | Purview SD — *Licensing for retention labels* / *other application methods* |
| Audit (Standard) | ano | ano | ano | — | Purview SD — *Audit (Standard)* |
| Audit (Premium) | ne | ne | ano | BP: Microsoft Purview Suite for Business Premium (max. 300 míst); E3: Microsoft 365 E5 eDiscovery & Audit, Purview Suite | Purview SD — *Audit (Premium)* |
| Conditional Access | ano (Entra ID P1) | ano (Entra ID P1) | ano | — | [Entra licensing](https://learn.microsoft.com/en-us/entra/fundamentals/licensing) — *Conditional Access*, *Licensing options* |
| Risk-based Conditional Access (ID Protection) | ne | ne | ano (Entra ID P2) | BP: Microsoft Defender Suite for Business Premium; obecně Entra ID P2, Defender Suite | Entra licensing — *ID Protection*, *Licensing options* |
| PIM vč. PIM for Groups | ne | ne | ano (Entra ID P2) | jako řádek výše; nebo Entra ID Governance | Entra licensing — *Privileged Identity Management* |
| Compliance Manager — nástroj a Microsoft Data Protection Baseline | ano | ano | ano | — | Purview SD — *Compliance Manager*; [Regulations list](https://learn.microsoft.com/en-us/purview/compliance-manager-regulations-list) |
| Compliance Manager — šablony ISO/IEC 27001:2022 a NIS2 Directive | koupě | koupě | 3 prémiové šablony zdarma, další koupě | prémiové šablony se kupují | [Regulations list](https://learn.microsoft.com/en-us/purview/compliance-manager-regulations-list) — *Included / Premium regulations* |
| Data Security Posture Management (DSPM) | ? | ? | ? | ? | Purview SD (2026-08-03) DSPM samostatně **neuvádí**; [DSPM considerations](https://learn.microsoft.com/en-us/purview/data-security-posture-management-considerations) odkazuje zpět na service description |
| Autofill columns | PAYG | PAYG | PAYG | Document processing pay-as-you-go | [Learn: Autofill overview](https://learn.microsoft.com/en-us/microsoft-365/documentprocessing/autofill-overview) |
| Copilot Chat s agenty, SharePoint agents | PAYG nebo licence Copilot | PAYG nebo licence Copilot | PAYG nebo licence Copilot | Copilot pay-as-you-go přes Azure subscription | [Learn: Copilot PAYG](https://learn.microsoft.com/en-us/microsoft-365/copilot/pay-as-you-go/overview) |

## Poznámky, které mění rozhodnutí

- **Kdo potřebuje licenci.** Podle Purview SD potřebuje licenci každý uživatel, který ze služby
  „těží". U sdílených umístění (weby SharePoint, skupiny Microsoft 365) to jsou **vlastníci
  a členové** webu, na který politika cílí; návštěvníci s právem jen ke čtení ne. Pro ISMS web
  s 10 editory a 240 čtenáři to je rozdíl.
- **Purview Suite for Business Premium** je add-on k Business Premium s limitem **300 míst
  celkem**. Purview SD ho jmenovitě uvádí jen v tabulce Audit (Premium) — pro ostatní řádky ho
  tabulka **nepředpokládá**, dokud to zdroj neřekne.
- **Compliance Manager a česká legislativa.** Seznam regulací obsahuje „Czech - On Cyber
  Security and Change of Related Acts (Act on Cyber Security) - Act No. 181" — tedy **starý**
  zákon č. 181/2014 Sb., ne zákon č. 264/2025 Sb. Pro kurz je relevantní šablona **NIS2 Directive
  (EU) 2022/2555** a **ISO/IEC 27001:2022**, obě prémiové.
- **Access reviews pro PIM for Groups** vyžadují podle Entra licensing **Microsoft Entra ID
  Governance**, ne jen P2 (tabulka *Access reviews*, stav preview).
- **DSPM pro Copilota** (classic DSPM for AI) vyžaduje u Microsoft Copilota a agentů licenci
  Copilot pro uživatele ([DSPM for AI considerations](https://learn.microsoft.com/en-us/purview/ai-microsoft-purview-considerations)) —
  to je podmínka funkce, ne licence samotného DSPM.

## Otevřené otázky

- **DSPM** — které plány DSPM (nová verze) zahrnují. Service description ho k 2026-08-03 nemá.
- **Funkce knihoven** (verzování, schvalování obsahu, Content Type Hub) — ověřeno jen na úrovni
  služby SharePoint Online; samostatný feature-level zdroj pro plány nebyl ověřen.
- **Cena Autofill columns a Copilot PAYG** — stránka Autofill overview cenu za stránku neuvádí.
