# Měření · Publikace typu obsahu a Autofill

> Modul: `content-type-hub` · Stav: **prázdné — měření dosud neproběhlo** (2026-10-17)

Microsoft Learn neuvádí, za jak dlouho je publikovaný typ obsahu z hubu dostupný na webech,
ani jak dlouho trvá zpracování Autofill. Lab je kvůli tomu postavený tak, aby na číslo
nečekal. Tento soubor drží naměřená čísla — s datem a tenantem, jinak neplatí
(viz [`../../CONVENTIONS.md`](../../CONVENTIONS.md)).

## Jak měřit

1. **Publikace (Tenant A):** v Content type gallery publikuj testovací typ obsahu, zapiš čas.
   Na webu, kde typ obsahu ještě nikdy nebyl, opakuj v knihovně **Add from existing site
   content types** a zapiš čas, kdy se kategorie objeví.
2. **Republikace (Tenant A):** přidej do publikovaného typu sloupec, **Republish**, sleduj,
   kdy se sloupec objeví v knihovně, která typ už používá.
3. **Autofill (Tenant B):** 7 vzorových dokumentů, tři Autofill sloupce, **More options (...)**
   -> **Autofill**; čas do vyplnění posledního dokumentu podle **Autofill activity**.
4. **Náklad Autofill (Tenant B):** Azure Cost Management, metr Autofill, den po labu.

## Naměřené hodnoty

| Datum | Tenant | Co | Výsledek | Kdo měřil | Poznámka |
|---|---|---|---|---|---|
| — | A | publikace -> dostupné v knihovně | — | — | zkušební průchod 2026-12 |
| — | A | republikace -> sloupec v knihovně | — | — | |
| — | B | Autofill 7 dokumentů × 3 sloupce | — | — | |
| — | B | náklad za skupinu (USD) | — | — | |

## Otevřené otázky

- Účtuje se **Test the prompt** v panelu Autofill jako transakce?
- Dorazí hubový typ obsahu na web, kde už existuje lokální typ obsahu se stejným názvem?
  (Lab tomu předchází jinými názvy `L-*`.)
