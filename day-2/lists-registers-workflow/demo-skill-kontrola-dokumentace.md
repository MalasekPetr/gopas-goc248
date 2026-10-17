# Demo · Skill pro kontrolu náležitostí řízené dokumentace

> Modul: `lists-registers-workflow` · Odhad: 15 min · Režim: **instruktorské demo** (studenti sledují a zapisují do SoA)
> Tenant: B `spdemo.online` (lektor) -> A `cloudedu.cz` (studenti) · Scénář: [`../../scenario-isms-vltava.md`](../../scenario-isms-vltava.md)

## Proč demo, ne lab

Copilot in SharePoint a Skills vyžadují **licenci Microsoft 365 Copilot**
([Learn: Get started with Copilot in SharePoint](https://learn.microsoft.com/en-us/sharepoint/copilot-in-sharepoint-get-started)).
Studentské účty na Tenant B mají Business Basic a Copilot PAYG — na Skills to nestačí
(potvrdil autor kurzu, 2026-10). Skill proto předvádí lektor účtem s licencí Copilot
na svém webu `isms-lektor` na Tenant B se stejnou vzorovou dokumentací.

To samo je teaching point licenční nitě: **Autofill columns jdou přes PAYG, Skills ne.**

## Cíl

Studenti vidí, jak Skill webu `Kontrola nalezitosti ISMS dokumentu` nad knihovnou
`Dokumentace` vrátí chybějící náležitosti a zapíše je do seznamu, a jak negativní test ukáže,
že Copilot na B nevidí registry z A. Každý student pak zapíše řádek do své SoA na A.

## Předpoklady (lektor)

- Účet s licencí Microsoft 365 Copilot na Tenant B (go/no-go v
  [`../../environment.md`](../../environment.md)).
- Web `isms-lektor` na B s knihovnou `Dokumentace` (7 dokumentů, skript
  `New-SampleDocsSite.ps1`) a s Autofill sloupci z [`../content-type-hub/`](../content-type-hub/).
- Na A hotový [`lab-registry-revize.md`](lab-registry-revize.md) — studenti mají Risk Register.

## Průběh dema

### 1. Co už Copilot umí

Lektor v knihovně `Dokumentace` otevře chat Copilot in SharePoint a zadá `/skills`.

**Checkpoint:** na projekci je seznam **Built-in skills** včetně schopnosti pro vytvoření
skillu (*Create skill*).

### 2. Vytvoření Skillu webu

Lektor zadá:

> Vytvoř site skill s názvem Kontrola nalezitosti ISMS dokumentu. Pro každý vybraný dokument
> v knihovně Dokumentace zkontroluj, zda text uvádí vlastníka dokumentu, datum účinnosti,
> datum příští revize a klasifikaci. U dokumentů, jejichž název začíná ZAZ (záznamy), datum
> příští revize nevyžaduj. Výsledek vrať jako tabulku dokument / chybějící náležitosti.
> Dokumenty, kterým něco chybí, zapiš do seznamu Nalezy kontroly dokumentace se sloupci
> Dokument a Chybi; pokud seznam neexistuje, vytvoř ho.

Studenti si zadání opíší — je to jejich návrh kontrolního postupu pro vlastní organizaci.

**Checkpoint:** Copilot potvrdil uložení jako **site skill** (ne osobní) a návrh obsahuje
výjimku pro dokumenty ZAZ.

### 3. Kde Skill žije

Lektor otevře obsah webu -> **Agent Assets** -> `Skills` -> složka skillu -> `SKILL.md`.

**Checkpoint:** `SKILL.md` je v `/Agent Assets/Skills/<název>/` a jeho kroky odpovídají zadání.

### 4. Běh nad dokumenty

Lektor vybere všech sedm dokumentů a zadá
`Run Kontrola nalezitosti ISMS dokumentu on the selected documents.`

**Checkpoint:** v chatu je karta načteného skillu a tabulka. Studenti ji porovnají se svou
tabulkou z Autofill (krok 9 labu `content-type-hub`): `SME-02` má nález u data revize,
`ZAZ-01` nález u data revize **nemá**. Seznam `Nalezy kontroly dokumentace` existuje.

### 5. Negativní test datové hranice

Lektor se v témže chatu zeptá: `Kolik rizik je v Risk Registeru a ktere maji miru rizika nad 12?`

**Checkpoint (negativní):** Copilot na Tenant B **nenajde** Risk Register ani rizika
z Tenant A. Kdyby je uvedl, je to nález — lektor ho zapíše.

### 6. Studenti: zapiš do SoA (Tenant A)

V profilu **Tenant A** otevři `isms-<ini>` -> `SoA` a přidej řádek:

| Opatření | Aplikovatelné | Zdůvodnění | Capability M365 | Důkaz | Modul | Tenant |
|---|---|---|---|---|---|---|
| kap. 7.5 | ano | vlastní věta: co Skill kontroluje, co nekontroluje a jakou licenci potřebuje | Skill webu (Copilot in SharePoint) kontroluje náležitosti řízených dokumentů; vyžaduje licenci Microsoft 365 Copilot | odkaz na lektorův `SKILL.md` na Tenant B + zadání skillu v poznámce | `lists-registers-workflow` | B |

Vyplň i Stav zavedení (u opatření, které ve vlastní organizaci bez licence Copilot nezavedeš,
**Plánováno**), Prioritu, Termín a Odpovědnou osobu.

**Checkpoint:** v profilu Tenant A je přihlášený tvůj účet `@cloudedu.cz`; v `SoA` je řádek
kap. 7.5 s Tenant = B a Modul = `lists-registers-workflow`.

## Ověření

- [ ] Na projekci proběhl běh skillu s tabulkou; nález u SME-02, žádný nález data revize u ZAZ-01.
- [ ] **Negativní:** Copilot na B nezná Risk Register z A.
- [ ] Každý student má řádek kap. 7.5 (Tenant B) v `SoA` na A.

## Fallback

- **Lektorský účet nemá licenci Copilot nebo Copilot in SharePoint nejde:** demo jen jako
  výklad nad `SKILL.md` ukázaným v README; studenti zapíší řádek SoA s Aplikovatelné = ano,
  Stav zavedení = Plánováno, a v Zdůvodnění uvedou licenční podmínku.
- **Copilot si vyžádá potvrzení čerpání Copilot Credits** (advanced work): zjednodušit na
  3 dokumenty.
- **Při časové tísni:** jen kroky 4 a 6 (−10 min).

## Zdroje

- [Extend Copilot in SharePoint with skills](https://learn.microsoft.com/en-us/sharepoint/copilot-in-sharepoint-skills)
- [Get started with Copilot in SharePoint](https://learn.microsoft.com/en-us/sharepoint/copilot-in-sharepoint-get-started)
