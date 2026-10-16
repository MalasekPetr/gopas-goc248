# Řešení · Knihovna řízené dokumentace

> Modul: `document-libraries-governance` · K labu: [`lab-rizena-dokumentace.md`](lab-rizena-dokumentace.md)
> Pro koho: kdo nestihl, nebo kdo chce porovnat. Zdůvodnění je vždy **vlastní text studenta** —
> níže je jen vzor, ne text k opsání.

## Cílový stav knihovny

| Nastavení | Hodnota |
|---|---|
| Zobrazovaný název / adresa | `Řízená dokumentace` / `/sites/isms-<ini>/ControlledDocs` |
| Schvalování obsahu | ano |
| Verze | hlavní a vedlejší |
| Limit verzí | zděděný z organizace (zapsat režim, neměnit) |
| Kdo vidí koncepty | jen autor a schvalovatelé |
| Rezervace (check-out) | ne |
| Oprávnění | dědění přerušené; vlastníci Full Control, `isms-<ini>-users` Read, `test-<ini>` Contribute |
| Dokumenty | `POL-01` verze 1.0 Approved (+ 1.1 Draft po kroku 9), `POL-02` verze 0.1 Draft |

## Řádky SoA

Sloupec **Požadavek** se doplňuje z mapovací matice `requirements-mapping-m365` (D1) — v tomto
souboru záměrně není, aby se neopisovalo ustanovení vyhlášky bez kontroly proti e-Sbírce.

| Opatření | Aplikovatelné | Zdůvodnění (vzor) | Capability M365 | Důkaz | Modul | Tenant |
|---|---|---|---|---|---|---|
| kap. 7.5 | ano | ISMS dokumenty musí mít historii, schválení před vydáním a kontrolu, kdo vidí rozpracované verze. Rezervaci nevyžadujeme: blokovala by revize a řízení změn drží vedlejší verze se schválením. | knihovna `ControlledDocs`: hlavní a vedlejší verze, schvalování obsahu, koncepty vidí jen autor a schvalovatel, limit verzí zděděný z organizace | `https://<tenant>.sharepoint.com/sites/isms-<ini>/_layouts/15/LstSetng.aspx?List=...` (Versioning settings knihovny) | `document-libraries-governance` | A |
| A.5.1 | ano | Politiku bezpečnosti informací schvaluje vedení a zaměstnanci dostávají jen schválenou verzi. | politika vydaná schválením; autor (`test-<ini>`) není schvalovatel | odkaz na `POL-01 Politika bezpečnosti informací` ve verzi 1.0 | `document-libraries-governance` | A |
| A.5.37 | ano | Postupy musí být dostupné těm, kdo je potřebují, a měnit je smí jen určený autor. | čtenáři `isms-<ini>-users` (Read), autor `test-<ini>` (Contribute), dědění přerušené | odkaz na stránku oprávnění knihovny | `document-libraries-governance` | A |

> [!NOTE] Proč A.5.37 a ne A.5.15
> Řízení přístupu jako opatření (A.5.15) se v kurzu dokládá Conditional Access a PIM v D4.
> Tady jde o dostupnost dokumentovaných postupů, proto A.5.37. Kdo chce oprávnění knihovny
> uvést i u A.5.15, napíše to do Zdůvodnění — řádek A.5.15 ale zakládá `conditional-access`.

## Typické odchylky

- **Autor = schvalovatel** (nepřihlásil se `test-<ini>`): řádek A.5.1 platí, ale do
  Zdůvodnění patří věta „oddělení autora a schvalovatele zatím není ověřené".
- **UI nenabídlo vedlejší verze**: řádek 7.5 platí s Capability „jen hlavní verze + schvalování"
  a odchylka patří do Zdůvodnění.
