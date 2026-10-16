# Řešení · Retence a záznamy pro ISMS workspace + stopa pro audit

Referenční řešení k [`lab-retence-zaznamy.md`](lab-retence-zaznamy.md).

## A. Retenční schéma (krok 3)

| Obsah | Politika / štítek | Doba a počátek | Na konci | Record |
|---|---|---|---|---|
| Schválená Politika | štítek (ručně nebo výchozí štítek knihovny — E5) | po dobu platnosti + 5 let; počátek od označení nebo od události „zrušení politiky" | disposition review | ano — chrání schválené znění; nová verze přes record versioning |
| Záznam o přezkoumání přístupů | štítek | 5 let od označení | disposition review | ano |
| Položka Incident logu | **štítek** (retenční politika položky seznamů nepokrývá), až na uzavřený incident | 5 let od označení | disposition review | ano |
| Pracovní koncept v Documents | politika na web | 3 roky od vytvoření | nic / smazat | ne |

Doby jsou ilustrační. Skutečné lhůty určuje organizace (vnitřní předpisy, smlouvy, zákonné
lhůty). Mapovací matice z pondělí (`requirements-mapping-m365`) uvádí u této oblasti „uchování
přehledů 4 roky" — navržených 5 let od označení je s tím v souladu; ověř proti matici své
organizace.

## B. Kontrolní body pro lektora (kroky 4–8)

- Štítek `<ini>-ISMS záznam`: record ano, regulatory record ne, 5 let od označení, disposition
  review s recenzentem = student. Recenzent nemá roli Disposition Management — v kurzu se to
  neprovádí, jen se o tom mluví.
- Label policy a retenční politika: **Static**, jediná lokace odpovídající typu webu, jediný web.
- `ZAZ-01`: *Item is a Record* = Yes, *Record status* = Locked; pokus o smazání selže.

## C. Stopa pro den 4 — očekávané auditní operace

Zdroj názvů operací: [Learn: audit log activities](https://learn.microsoft.com/en-us/purview/audit-log-activities)
(stav stránky 2026-10-13). Konkrétní záznamy na kurzovním tenantu **nejsou ověřené** — první
dry-run je doplní do `mereni-audit-stopa.md` v `audit-incident-response`.

| # | Akce `test-<ini>` | Očekávaná operace (friendly name / Operation) | Poznámka |
|---|---|---|---|
| 1a | otevření Politiky ve Word for the web | *Accessed file* / `FileAccessed` | stejný uživatel + soubor se podle Learn znovu nezaloguje do 5 minut |
| 1b | stažení Politiky | *Downloaded file* / `FileDownloaded` | |
| 2 | snížení štítku na Veřejné ve Word for the web | *Changed sensitivity label applied to file* / `FileSensitivityLabelChanged` | desktopové Office aplikace by logovaly `SensitivityLabelUpdated`; zdůvodnění ukazuje Activity explorer ([Learn](https://learn.microsoft.com/en-us/purview/sensitivity-labels)); zda je text zdůvodnění i v auditním záznamu, je **otevřená otázka** |
| 3a | odkaz „People in your organization" | *Created a company shareable link* / `CompanyLinkCreated` | |
| 3b | odkaz „Specific people" (fallback) | *Created secure link* / `SecureLinkCreated` a *User added to secure link* / `AddedToSecureLink` | proto si student zapisuje typ odkazu |
| 4 | neúspěšný pokus o smazání záznamu | **žádná dokumentovaná operace** | Learn uvádí jen *Deleted file* / `FileDeleted` a *Deleted file marked as a record* / `RecordDelete` pro **provedené** smazání. Den 4 má čekat, že neúspěšný pokus v auditu **nemusí být**; důkazem je snímek hlášky. Otevřená otázka pro dry-run. |

Související operace, které se ve stejném okně mohou objevit (od studenta, ne od `test-<ini>`):

| Akce | Operace |
|---|---|
| aplikace retenčního štítku na dokument (krok 7) | *Changed retention label for a file* / `ComplianceSettingChanged` |
| zamčení / odemčení záznamu | `LockRecord` / `UnlockRecord` |
| ruční štítek ve Word for the web (`sensitivity-labels`, krok 7) | `FileSensitivityLabelApplied` |
| výchozí štítek knihovny na nahraném souboru | `FileSensitivityLabelApplied`, v detailu `ActionScourceDetails` (pravopis podle Learn) = 6 ([Learn](https://learn.microsoft.com/en-us/purview/sensitivity-labels-sharepoint-default-label)) |

Pro den 4: Audit pracuje v UTC; student má místní čas (leden = UTC+1).

## D. Řádky SoA

| Opatření | Požadavek | Aplikovatelné | Zdůvodnění (vzor) | Capability M365 | Důkaz | Modul | Tenant |
|---|---|---|---|---|---|---|---|
| A.5.33 | vyhl. 410/2025 Sb. § 3 odst. 2 a 4 (podle mapovací matice `requirements-mapping-m365`) | ano | Záznamy ISMS jsou po schválení prohlášené za record: obsah nejde měnit ani mazat, nová verze vzniká jen přes record versioning a původní znění zůstává v Preservation Hold library. | retenční štítek označující záznam, record versioning | odkaz na `ZAZ-01` + snímek hlášky o neúspěšném smazání | `retention-lifecycle` | A |
| A.8.10 | vyhl. 410/2025 Sb. § 3 odst. 4 (podle mapovací matice) | ano | Obsah workspace má stanovené doby uchování; záznamy po uplynutí doby prochází kontrolou likvidace, kterou schvaluje určený recenzent. | retenční politika `<ini>-ISMS retence web`, štítek `<ini>-ISMS záznam` s disposition review | snímek nastavení politiky a štítku | `retention-lifecycle` | A |

Organizace bez E5: A.5.33 doloží verzováním, schvalováním a oprávněními (den 2) a běžnou retencí;
record a disposition review uvede jako nedostupné — nález pro capstone.
