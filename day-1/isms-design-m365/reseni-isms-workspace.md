# Řešení · ISMS workspace a seznam SoA

Referenční stav po [`lab-isms-workspace.md`](lab-isms-workspace.md). Kdo nestihne, doplní podle
něj a pokračuje; kdo ztratí den, dostane workspace ze skriptu (plán: `scripts/New-IsmsWorkspace.ps1`).

## Web

| Vlastnost | Hodnota |
|---|---|
| Typ | Communication site (bez skupiny Microsoft 365) |
| Adresa | `https://<tenant>.sharepoint.com/sites/isms-<ini>` |
| Jazyk | English |
| Vlastník | student |
| Members | `isms-<ini>-users` |

## Seznam SoA — kontrola schématu

Ověř v **List settings** klikem na sloupec — adresa stránky obsahuje `Field=<interní název>`.

| Zobrazovaný název | Interní název | Typ | Volby |
|---|---|---|---|
| Opatření | `Title` | Single line of text | — |
| Požadavek | `Requirement` | Single line of text | — |
| Aplikovatelné | `Applicable` | Choice | `ano`, `ne` |
| Zdůvodnění | `Justification` | Multiple lines of text | — |
| Capability M365 | `Capability` | Single line of text | — |
| Důkaz | `Evidence` | Hyperlink | — |
| Modul | `Module` | Single line of text | — |
| Tenant | `Tenant` | Choice | `A`, `B` (výchozí `A`) |
| Stav zavedení | `ImplementationStatus` | Choice | `Zavedeno`, `Částečně zavedeno`, `Plánováno`, `Nezavedeno` |
| Priorita | `Priority` | Choice | `Vysoká`, `Střední`, `Nízká` |
| Termín | `DueDate` | Date and time (jen datum) | — |
| Odpovědná osoba | `ResponsiblePerson` | Person | jedna osoba |

## Informační architektura — obsah stránky Mapa ISMS

| Kontejner | Typ | Vzniká v bloku | Účel |
|---|---|---|---|
| SoA | seznam | `isms-design-m365` | opatření Annex A, § vyhlášky, aplikovatelnost, capability, důkaz, stav zavedení |
| Documents | knihovna (výchozí) | — | pracovní podklady návrhu (mapovací matice) |
| Mapa ISMS | stránka | `isms-design-m365` | tento plán a odkazy |
| Knihovna řízené dokumentace | knihovna | `document-libraries-governance` | politiky a směrnice — verzování, schvalování |
| Typy obsahu Politika a Záznam | Content Type Hub | `content-type-hub` | jednotná metadata dokumentace |
| Asset Register | seznam | `lists-registers-workflow` | evidence aktiv |
| Risk Register | seznam | `lists-registers-workflow` | evidence rizik a jejich revize |
| Incident log | seznam | `lists-registers-workflow` | evidence incidentů, podklad hlášení (D4) |

## Řádky SoA po dni 1

| Opatření | Požadavek | Aplikovatelné | Zdůvodnění (vzor) | Capability M365 | Důkaz | Modul | Tenant |
|---|---|---|---|---|---|---|---|
| A.5.31 | vyhl. 410/2025 Sb. § 3 odst. 2, příloha č. 1 | ano | Požadavky zákona a vyhlášky pro režim nižších povinností jsou identifikované a namapované na opatření a capabilities. | mapovací matice v knihovně webu | odkaz na `<ini>-mapovaci-matice` v Documents | `requirements-mapping-m365` | A |
| kap. 6.1.3 | vyhl. 410/2025 Sb. § 3 odst. 2, příloha č. 1 | ano | Jeden seznam slouží jako SoA i jako přehled bezpečnostních opatření; stav, priorita, termín a odpovědná osoba podle přílohy č. 1 jsou samostatné sloupce. | seznam SoA na webu `isms-<ini>` | odkaz na seznam SoA | `isms-design-m365` | A |

U obou řádků: Stav zavedení `Zavedeno`, Odpovědná osoba student, Termín prázdný.

Odkaz v Důkaz musí vést na **tvůj** sešit a **tvůj** seznam, ne na řešení.
