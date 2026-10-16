# Řešení · Typy obsahu z hubu a Autofill columns

> Modul: `content-type-hub` · K labu: [`lab-typy-obsahu-autofill.md`](lab-typy-obsahu-autofill.md)
> Zdůvodnění v SoA je vždy **vlastní text studenta**; níže jen vzor.

## Typy obsahu (Tenant A)

| Typ obsahu | Kategorie | Rodič | Sloupce (`VS ISMS`) | Povinné |
|---|---|---|---|---|
| `<ini>-Politika` | `<ini>-ISMS` | Document | DocOwner, EffectiveDate, DocNextReview, DocClassification | DocOwner, DocNextReview, DocClassification |
| `<ini>-Směrnice` | `<ini>-ISMS` | Document | DocOwner, EffectiveDate, DocNextReview, DocClassification, ParentPolicy | DocOwner, DocNextReview, DocClassification |
| `<ini>-Záznam` | `<ini>-ISMS` | Document | DocOwner, RecordDate, DocClassification | DocOwner, RecordDate, DocClassification |

Fallback (publikace nedorazila): `L-Politika`, `L-Směrnice`, `L-Záznam` jako typy obsahu webu
`isms-<ini>` se stejnými sloupci vytvořenými na webu.

## Autofill (Tenant B) — očekávané správné hodnoty

Tabulka říká, **co je napsané v dokumentu** (podle zadání vzorových dokumentů v repu), ne co
Autofill vrátí — to zjistí každý student sám v kroku 9. Výsledek Autofill se sem nepíše.

| Dokument | Typ dokumentu | Vlastník dokumentu (v textu) | Datum příští revize (v textu) | Proč je dokument v sadě |
|---|---|---|---|---|
| POL-01 Politika bezpečnosti informací | Politika | ředitel společnosti, Ing. Tomáš Bureš | 2027-02-01 | kontrolní případ, vše explicitně |
| POL-02 Politika řízení přístupu | Politika | vedoucí IT, Lenka Horáková | „1. března 2027" (slovy) | datum v českém formátu |
| POL-03 Klasifikace informací | Politika | manažer kybernetické bezpečnosti, Martin Sýkora | 2027-04-15 | taxonomie klasifikace pro D3 |
| POL-04 Zvládání kybernetických incidentů | Politika | manažer kybernetické bezpečnosti (jen funkce, bez jména) | 2027-03-01 | vlastník jako role |
| SME-01 Zálohování a obnova | Směrnice | vedoucí IT, Lenka Horáková | 2027-06-30 | kontrolní případ pro směrnici |
| SME-02 Používání AI nástrojů | Směrnice | manažer kybernetické bezpečnosti, Martin Sýkora | **není uvedeno přímo** — „nejpozději 12 měsíců od data účinnosti", účinnost 2026-09-01 | odvozené datum; správně je prázdno nebo 2027-09-01 s ověřením |
| ZAZ-01 Zápis z přezkoumání vedením 2026 | Záznam | zapisovatel: asistentka vedení, Eva Malá | **není** — záznam se nereviduje | AI nemá co najít; vymyšlené datum = chyba |

Všechna jména jsou fiktivní (Vltava Servis s.r.o.).

## Řádky SoA

Sloupec **Požadavek** z mapovací matice D1.

| Opatření | Aplikovatelné | Zdůvodnění (vzor) | Capability M365 | Důkaz | Modul | Tenant |
|---|---|---|---|---|---|---|
| kap. 7.5 | ano | Každý ISMS dokument musí nést vlastníka, datum revize a klasifikaci; typ obsahu to vynutí formulářem pro všechny weby stejně. | typy obsahu `<ini>-Politika` / `-Směrnice` / `-Záznam` z Content Type Hubu, povinná metadata | odkaz na nastavení typů obsahu knihovny `ControlledDocs` | `content-type-hub` | A |
| kap. 7.5 | ano | Autofill zrychlí vyplnění metadat, ale u ZAZ-01 / SME-02 ukázal, že návrh musí ověřit člověk; schvalování zůstává. | Autofill columns (Document processing PAYG) nad kopií dokumentace | odkaz na knihovnu `Dokumentace` na Tenant B; screenshot v příloze položky | `content-type-hub` | B |
