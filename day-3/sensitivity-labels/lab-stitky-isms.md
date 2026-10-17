# Lab · Taxonomie štítků a štítky na ISMS knihovně

> Modul: `sensitivity-labels` · Odhad: 70 min · Režim: hands-on, vlastní scope; kroky 4, 5 a 9 vytvářejí **tenantové objekty**
> Tenant: A `cloudedu.cz` · Scénář: [`../../scenario-isms-vltava.md`](../../scenario-isms-vltava.md)

## Cíl

Knihovna „Řízená dokumentace" ve webu `isms-<ini>` má výchozí sensitivity label, dokument typu
Politika nese štítek se záhlavím, web má kontejnerový štítek a v SoA jsou řádky A.5.12 a A.5.13.

**Jak lab číst:** každý krok končí **Checkpointem** — nesedí-li, nepokračuj.

> [!WARNING] Tenantové objekty — pravidla pro celou třídu
> Štítky a label policies jsou **objekty celého tenantu** a jejich pořadí je jedno sdílené pro
> všechny. Proto:
>
> - Vytváříš **jeden** štítek `<ini>-ISMS důvěrné`, a to **uvnitř skupiny Důvěrné**.
> - **Nikdy nepoužívej Move up / Move down** ani přímé zadání priority. Ani u svého štítku.
> - Label policy má v uživatelích **jen** `isms-<ini>-users`. Nikdy *All users*.
> - Kurzovní štítky (`GOC248-*`) a cizí štítky neupravuj, nepřesouvej, nemaž.

## Předpoklady

- Profil prohlížeče pro Tenant A, přihlášený tvým kurzovním účtem (Global Administrator).
- Komunikační web `isms-<ini>` s knihovnou „Řízená dokumentace" (`/ControlledDocs`: hlavní
  a vedlejší verze, schvalování obsahu, typy obsahu Politika a Záznam, schválené `POL-01`
  a `ZAZ-01`) z [`../../day-2/document-libraries-governance/`](../../day-2/document-libraries-governance/)
  a [`../../day-2/content-type-hub/`](../../day-2/content-type-hub/).
- Skupina `isms-<ini>-users` (ty + `test-<ini>`) a uživatel `test-<ini>` — založil lektor.
- Kurzovní taxonomie a policy `GOC248 - kurzovni stitky` — publikoval lektor předem.
- Lektor ti řekl, jestli tenant používá **modern** nebo **classic** schéma štítků.

## Kroky

### 1. Ověř účet a profil

Otevři profil prohlížeče pro Tenant A a v něm Microsoft Purview portál
(`https://purview.microsoft.com`). Vpravo nahoře klikni na ikonu účtu.

**Checkpoint:** přihlášený účet je `jmeno.prijmeni@cloudedu.cz` v profilu Tenant A — ne účet
z Tenant B ani soukromý účet.

### 2. Navrhni taxonomii na papíře

Než otevřeš konfiguraci, navrhni taxonomii pro Vltava Servis (10 min, ve dvojici). Pro každou
úroveň vyplň řádek:

| Úroveň | Příklad dokumentu z ISMS | Kdo smí otevřít | Značení | Šifrování | Kontejner (web): externí sdílení |
|---|---|---|---|---|---|
| … | … | … | … | ano / ne a proč | … |

Odpověz jednou větou: proč **ne** šifrovat úroveň, kterou budou mít jako výchozí všechny politiky
ISMS?

**Checkpoint:** návrh má 3–5 úrovní, ke každé konkrétní dokument z ISMS (např. Politika řízení
přístupu, Záznam o incidentu) a odpověď na otázku o šifrování zmiňuje sdílení s externími
nebo dostupnost dokumentu (srovnej s [`reseni-stitky-isms.md`](reseni-stitky-isms.md), část B).

### 3. Prohlédni kurzovní taxonomii

Purview → **Solutions** → **Information Protection** → **Sensitivity labels**. Otevři štítek
**Důvěrné \ Vltava** a projdi stránky průvodce **bez uložení** (na konci **Cancel**).

**Checkpoint:** v seznamu vidíš Veřejné, Interní, skupinu Důvěrné se štítkem Vltava a Přísně
důvěrné v tomto pořadí; u Důvěrné \ Vltava je scope *Files & other data assets*, *Emails* a
*Groups & sites* a záhlaví `VLTAVA SERVIS - DUVERNE`.

### 4. [TENANT] Vytvoř vlastní štítek ve skupině Důvěrné

**4a — modern schéma:** u skupiny **Důvěrné** → **…** (Actions) → **Create label in group**.
**4b — classic schéma:** u nadřazeného štítku **Důvěrné** → **…** → **Create sublabel**.

| Nastavení | Hodnota |
|---|---|
| Name | `<ini>-ISMS-duverne` |
| Display name | `<ini>-ISMS důvěrné` |
| Description for users | „Řízená ISMS dokumentace Vltava Servis — tvé iniciály. Jen pro interní použití." |
| Scope | jen **Files & other data assets** |
| Protection settings | jen **Add content marking** → záhlaví `VLTAVA SERVIS - DUVERNE - ISMS <INI>` (velkými písmeny bez diakritiky) |
| Encryption | **ne** |
| Auto-labeling for files and emails | **ne** |

Na konci průvodce **nevolej** nabízené *Publish label* — policy vytvoříš v kroku 5.

**Checkpoint:** v seznamu štítků je `<ini>-ISMS důvěrné` **uvnitř** skupiny / pod štítkem
Důvěrné a skupina Důvěrné je pořád mezi Interní a Přísně důvěrné.

### 5. [TENANT] Publikuj label policy jen pro svou skupinu

**Information Protection** → **Publishing policies** → **Publish label**:

| Nastavení | Hodnota |
|---|---|
| Labels | `<ini>-ISMS důvěrné` (v classic schématu **i** nadřazený Důvěrné) |
| Admin units | Full directory |
| Users and groups | **jen** `isms-<ini>-users` |
| Users must provide a justification to remove a label or lower its classification | **zapnuto** |
| Default label pro dokumenty, e-maily, schůzky, kontejnery | **None** |
| Require users to apply a label | **vypnuto** |
| Name | `<ini>-ISMS label policy` |

**Checkpoint (negativní):** v seznamu **Label policies** otevři svou policy — v **Users and
groups** je jediná položka `isms-<ini>-users`, ne *All* a ne skupina kolegy. Kurzovní policy
`GOC248 - kurzovni stitky` je beze změny.

### 6. Nastav výchozí štítek knihovny

Na webu `isms-<ini>` otevři knihovnu „Řízená dokumentace" → ozubené kolo → **Library
settings** → **Default sensitivity labels**.

- Když je v nabídce `<ini>-ISMS důvěrné`, zvol ho.
- Když ještě není (policy se nepropsala), zvol **Důvěrné \ Vltava** a zapiš si to — vrátíš se
  k tomu ráno dne 4 (Fallback).
- Volbu **Extend protection on download, copy, or move** **nezaškrtávej** (preview, jiný scénář).

**Checkpoint:** nastavení knihovny ukazuje zvolený výchozí štítek a v poznámce máš, který to je.

### 7. Ověř označení dokumentu — výchozí i ruční

1. Nahraj do knihovny nový neprázdný dokument Word (např. `POL-05 Politika klasifikace.docx`),
   nastav typ obsahu Politika a vyplň povinná metadata (Klasifikace = Důvěrné). Počkej několik
   minut a obnov stránku; v případě potřeby přidej do zobrazení sloupec **Sensitivity**.
2. Otevři v Word for the web politiku `POL-01` (z dne 2). **Sensitivity** → zvol
   `<ini>-ISMS důvěrné` (nebo Důvěrné \ Vltava podle kroku 6). Změna vytvoří novou vedlejší verzi
   (koncept).
3. U obou dokumentů **publikuj hlavní verzi a schval ji** (schvalování obsahu z dne 2). Koncepty
   vidí jen autor a schvalovatelé — bez schválení by `test-<ini>` ve stopě v `retention-lifecycle`
   viděl starou verzi `POL-01` bez štítku.

Sloupec **Klasifikace** z dne 2 je metadata, sensitivity label je jiná věc: sloupec nic nechrání
a se štítkem se sám nesynchronizuje. Hodnoty drž ručně ve shodě.

**Checkpoint:** nahraný dokument má ve sloupci Sensitivity výchozí štítek s nápovědou *This file
has been automatically labeled*; `POL-01` má v Word for the web záhlaví ze štítku; oba dokumenty
mají hlavní verzi se stavem schválení **Approved**.

### 8. Nastav kontejnerový štítek webu

Na webu `isms-<ini>`: ozubené kolo → **Site information** → **Sensitivity** → **Důvěrné \
Vltava** → **Save**. Pracuj **jen ze svého webu**, ne ze SharePoint admin centra — tam jsou
nabízené všechny kontejnerové štítky pro všechny weby tenantu.

**Checkpoint:** v záhlaví webu `isms-<ini>` je vidět název štítku. **Negativní:** web kolegy
(lektor ukáže na projektoru jeden cizí `isms-*` web) štítek od tebe nemá.

### 9. [TENANT] Auto-labeling policy v simulaci (kompresní ventil 1)

**Information Protection** → **Policies** → **Auto-labeling policies** → **Create auto-labeling
policy** → **Custom**:

| Nastavení | Hodnota |
|---|---|
| Name | `<ini>-AUTO-rodne-cislo` |
| Locations | **jen SharePoint sites** → **Included sites** = jen `/sites/isms-<ini>`; Exchange, OneDrive a ostatní **vypnuté** |
| Rule | Content contains → Sensitive info types → **Czech personal identity number** |
| Label | `<ini>-ISMS důvěrné` (není-li nabízen, Důvěrné \ Vltava) |
| Mode | **Run policy in simulation mode** |
| Automatically turn on policy if not edited for 7 days | **NEZAŠKRTNUTO** |

Výsledek simulace může podle Learn trvat až 12 hodin — prohlédneš ho ráno dne 4.

**Checkpoint:** policy je ve stavu simulace, v **Locations** je jen tvůj web a volba
automatického zapnutí je vypnutá (lektor ověří v detailu policy).

### 10. Zapiš do SoA

Do seznamu SoA ve workspace `isms-<ini>` přidej řádky:

| Opatření | Aplikovatelné | Zdůvodnění | Capability M365 | Důkaz | Modul | Tenant |
|---|---|---|---|---|---|---|
| A.5.12 | ano | vlastní text | taxonomie sensitivity labels (Veřejné → Přísně důvěrné), label policy `<ini>-ISMS label policy` | snímek policy se scope `isms-<ini>-users` v knihovně důkazů | `sensitivity-labels` | A |
| A.5.13 | ano | vlastní text | výchozí štítek knihovny „Řízená dokumentace", záhlaví ze štítku, kontejnerový štítek webu | odkaz na označenou `POL-01` + snímek nastavení knihovny | `sensitivity-labels` | A |

Sloupec **Požadavek** doplň z mapovací matice z pondělí. Vyplň i Stav zavedení, Prioritu,
Termín a Odpovědnou osobu (u zavedených opatření Termín necháš prázdný).

**Checkpoint:** v SoA jsou dva nové řádky s vyplněným sloupcem Důkaz (funkční odkaz)
a Modul = `sensitivity-labels`.

## Ověření

- [ ] Papírová taxonomie má 3–5 úrovní s dokumenty z ISMS a zdůvodněním šifrování.
- [ ] Štítek `<ini>-ISMS důvěrné` je uvnitř skupiny Důvěrné, bez šifrování, se záhlavím.
- [ ] Policy `<ini>-ISMS label policy` má zdůvodnění zapnuté, žádný výchozí štítek.
- [ ] Knihovna „Řízená dokumentace" má výchozí štítek; nahraný dokument ho dostal.
- [ ] Ručně označená `POL-01` má schválenou hlavní verzi se záhlavím.
- [ ] Web `isms-<ini>` má kontejnerový štítek Důvěrné \ Vltava.
- [ ] **Negativní:** policy cílí jen na `isms-<ini>-users`; pořadí sdílených štítků se nezměnilo;
      cizí web kontejnerový štítek nedostal.
- [ ] (Ventil 1) Auto-labeling policy je v simulaci jen na `isms-<ini>`, bez automatického zapnutí.
- [ ] SoA: řádky A.5.12 a A.5.13.

## Fallback

- **Policy se nepropsala do konce labu** (štítek `<ini>-ISMS důvěrné` není v knihovně ani ve Word
  for the web): použij kurzovní **Důvěrné \ Vltava** pro kroky 6 a 7, poznač si to a ráno dne 4
  přepni výchozí štítek knihovny a štítek Politiky na vlastní. Do SoA jako důkaz A.5.12 dej snímek
  policy (její existence a scope se dokládá i bez propagace).
- **Výchozí štítek knihovny nejde nastavit** (nabídka chybí): ověř s lektorem tenantové nastavení
  štítků pro SharePoint a to, že knihovna nemá zapnuté IRM. Krok 7.1 pak nahraď jen ručním
  označením.
- **Nahraný dokument štítek nedostal:** soubor je prázdný, nebo je vyhrazený (checked out) —
  podle Learn se štítek ve sloupci ukáže až po check-in. Počkej, obnov, zkontroluj stav.
- **Kontejnerový štítek není v Site information:** štítky pro kontejnery se do Entra ID
  synchronizují až 24 h — krok 8 přeskoč a v SoA uveď jako otevřený bod.
- **Při časové tísni:** krok 9 vypadá (kompresní ventil 1), krok 2 jen ústně ve dvojici; řádky SoA
  převezmi z [`reseni-stitky-isms.md`](reseni-stitky-isms.md). **Kroky 4–7 se nekrátí.**

## Zdroje

- [Create and publish sensitivity labels](https://learn.microsoft.com/en-us/purview/create-sensitivity-labels)
- [Configure a default sensitivity label for a SharePoint document library](https://learn.microsoft.com/en-us/purview/sensitivity-labels-sharepoint-default-label)
- [Use sensitivity labels to protect collaborative workspaces](https://learn.microsoft.com/en-us/purview/sensitivity-labels-teams-groups-sites)
- [Automatically apply a sensitivity label to Microsoft 365 data](https://learn.microsoft.com/en-us/purview/apply-sensitivity-label-automatically)
