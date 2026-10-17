# Lab · Typy obsahu z hubu a Autofill columns

> Modul: `content-type-hub` · Odhad: 60 min · Režim: hands-on, vlastní scope; kroky 3–5 jsou **[T] tenantové**
> Tenant: A `cloudedu.cz` -> B `spdemo.online` -> A · Scénář: [`../../scenario-isms-vltava.md`](../../scenario-isms-vltava.md)

## Cíl

Knihovna `ControlledDocs` na Tenant A nabízí typy obsahu Politika, Směrnice a Záznam
s povinnými metadaty a `POL-01` je typu Politika; na Tenant B má knihovna `Dokumentace` tři
Autofill sloupce, u kterých víš, kde AI trefila a kde ne.

**Jak lab číst:** každý krok končí **Checkpointem** — nesedí-li, nepokračuj. Lab dvakrát
přepíná tenant; přepnutí má vlastní checkpoint.

> [!WARNING] Tenantové kroky
> Kroky označené **[T]** zapisují do Content type gallery celého Tenant A. Pracuj **jen**
> s kategorií `<ini>-ISMS` a s typy obsahu s prefixem `<ini>-`. Sdílené sloupce v kategorii
> `VS ISMS` **neupravuj** — patří celé třídě.

## Předpoklady

- Hotový lab [`../document-libraries-governance/`](../document-libraries-governance/):
  knihovna `ControlledDocs` s dokumentem `POL-01`.
- Profily prohlížeče pro Tenant A i Tenant B, v obou přihlášení z `onboarding` (D1).
- Lektor potvrdil: sdílené sloupce `VS ISMS` v hubu existují; na Tenant B je web `isms-<ini>`
  s knihovnou `Dokumentace` a Autofill je pro něj zapnutý.

## Kroky

### 1. Ověř tenant a profil (A)

V profilu Tenant A otevři SharePoint admin centrum -> **Content services** ->
**Content type gallery**.

**Checkpoint:** jsi přihlášený `@cloudedu.cz` a v galerii vidíš kategorii `VS ISMS` se šesti
sloupci (Vlastník dokumentu, Datum účinnosti, Datum příští revize, Klasifikace, Nadřazená
politika, Datum vzniku záznamu).

### 2. [T] Vytvoř typ obsahu `<ini>-Politika`

**Create content type**: název `<ini>-Politika`, kategorie **Create a new category** ->
`<ini>-ISMS`, nadřazený typ obsahu **Document Content Types** -> **Document**. Pak **Add site
column** -> **Add from existing site columns** -> kategorie `VS ISMS` -> přidej
Vlastník dokumentu, Datum účinnosti, Datum příští revize, Klasifikace. U sloupců Vlastník
dokumentu, Datum příští revize a Klasifikace nastav **Required (must contain information)**.

**Checkpoint:** typ obsahu `<ini>-Politika` je v kategorii `<ini>-ISMS`, má čtyři přidané
sloupce a tři z nich jsou povinné.

### 3. [T] Vytvoř `<ini>-Směrnice` a `<ini>-Záznam`

Stejně jako v kroku 2, kategorie `<ini>-ISMS`, rodič **Document**:

| Typ obsahu | Sloupce z `VS ISMS` | Povinné |
|---|---|---|
| `<ini>-Směrnice` | Vlastník dokumentu, Datum účinnosti, Datum příští revize, Klasifikace, Nadřazená politika | Vlastník dokumentu, Datum příští revize, Klasifikace |
| `<ini>-Záznam` | Vlastník dokumentu, Datum vzniku záznamu, Klasifikace | Vlastník dokumentu, Datum vzniku záznamu, Klasifikace |

**Checkpoint:** v kategorii `<ini>-ISMS` jsou tři typy obsahu; `<ini>-Záznam` **nemá**
Datum příští revize.

### 4. [T] Publikuj všechny tři a zapiš čas

U každého typu obsahu **Publish** -> **Manage Publishing** -> **Publish** -> **Save**. Zapiš
si čas publikace (hh:mm) — použiješ ho v kroku 10 a lektor ho přenese do měření.

**Checkpoint:** všechny tři typy obsahu jsou publikované (panel publikování to ukazuje) a máš
zapsaný čas.

**Checkpoint (negativní):** v galerii jsi neupravil nic mimo kategorii `<ini>-ISMS` — sdílené
sloupce `VS ISMS` mají stejná nastavení jako v kroku 1 a typy obsahu ostatních studentů jsi
neotevíral k úpravě.

### 5. Přepni na Tenant B

Zavři okno profilu Tenant A (nech ho běžet). V profilu **Tenant B** otevři
`https://<tenant>.sharepoint.com/sites/isms-<ini>` (adresu Tenant B sdělí lektor) a knihovnu
`Dokumentace`.

**Checkpoint:** v profilu Tenant B je přihlášený `user.NN@spdemo.online`, adresa obsahuje
**tvoje** iniciály a knihovna `Dokumentace` obsahuje sedm dokumentů: POL-01 až POL-04,
SME-01, SME-02, ZAZ-01.

### 6. Přidej Autofill sloupec Typ dokumentu

V knihovně **+ Add column** -> **Choice** -> **Next**. Název `Typ dokumentu`, volby
`Politika`, `Směrnice`, `Záznam`. V sekci **Autofill** -> **Set up**, prompt:

> Urči typ dokumentu podle jeho obsahu a označení v názvu (POL = politika, SME = směrnice,
> ZAZ = záznam). Odpověz právě jednou z možností: Politika, Směrnice, Záznam. Pokud žádná
> nesedí, odpověz None of the above.

V **Test the prompt** vyber `SME-01 Zálohování a obnova`, zkontroluj **Result** a **Save**.

**Checkpoint:** sloupec `Typ dokumentu` je v knihovně a v jeho nastavení je sekce Autofill
zapnutá s tvým promptem. **Ještě nic nezpracovávej.**

### 7. Přidej Vlastník dokumentu a Datum příští revize

Nejdřív zkus **+ Add column** -> **Person** a podívej se, zda formulář nabízí sekci Autofill.
Sloupec **nevytvářej** (Cancel). Pak vytvoř:

| Sloupec | Typ | Prompt |
|---|---|---|
| `Vlastník dokumentu` | Single line of text | Kdo je vlastníkem dokumentu? Uveď funkci a jméno, pokud jsou v dokumentu uvedené. Pokud dokument vlastníka neuvádí, ponech odpověď prázdnou. |
| `Datum příští revize` | Date and time | Jaké je datum příští revize dokumentu? Format the answer as a valid C# datetime. Pokud dokument datum příští revize neuvádí ani se z něj nedá jednoznačně určit, ponech odpověď prázdnou. |

U každého otestuj prompt na jiném dokumentu než v kroku 6.

**Checkpoint (negativní):** sloupec typu Person **nenabízí** Autofill — proto je vlastník na
Tenant B text, zatímco v typu obsahu na Tenant A je to osoba.

**Checkpoint:** knihovna má tři Autofill sloupce: Typ dokumentu, Vlastník dokumentu, Datum
příští revize.

### 8. Zpracuj existující dokumenty

Vyber všech sedm dokumentů -> na příkazovém řádku **More options (...)** -> **Autofill**.
Průběh sleduj v panelu **Autofill activity**.

**Checkpoint:** hlášení o zahájení zpracování se objevilo a u dokumentů se postupně plní
hodnoty ve všech třech sloupcích. Zapiš, za jak dlouho byly hotové všechny (pro lektora).

### 9. Ověř výsledky proti textu dokumentů

Pro každý dokument porovnej tři hodnoty s textem dokumentu (otevři ho). Výsledek zapiš do
tabulky v poznámce: dokument / sloupec / hodnota Autofill / co je v dokumentu / sedí ano-ne.
Aspoň jednu nesprávnou nebo spornou hodnotu **ručně oprav** ve sloupci.

**Checkpoint:** tabulka má 21 řádků (7 × 3) a aspoň jeden řádek se „sedí: ne" nebo s prázdnou
hodnotou, kterou umíš vysvětlit (typicky `ZAZ-01` bez data revize nebo `SME-02`, kde je datum
revize napsané slovy). Jedna hodnota je ručně opravená.

Spočítej náklad: součet stránek sedmi dokumentů × $0.005 (cena za transakci podle README).

**Checkpoint:** máš číslo v USD a víš, že každé další **Autofill** na stejné dokumenty se
platí znovu.

### 10. Přepni zpět na Tenant A a připoj typy obsahu ke knihovně

V profilu **Tenant A** otevři `isms-<ini>` -> `ControlledDocs` -> **Settings** -> **Library
settings** -> **Advanced settings** -> **Allow management of content types** -> **Yes**. Pak
v nastavení knihovny **Add from existing site content types** -> kategorie `<ini>-ISMS` ->
přidej všechny tři. `<ini>-Politika` nastav jako výchozí typ obsahu.

**Checkpoint:** v profilu Tenant A je přihlášený tvůj účet `@cloudedu.cz` (ne
`user.NN@spdemo.online`).

**Checkpoint:** knihovna `ControlledDocs` má typy obsahu `<ini>-Politika` (výchozí),
`<ini>-Směrnice`, `<ini>-Záznam`. Zapiš, kolik minut uplynulo od publikace v kroku 4.

Kategorie `<ini>-ISMS` v nabídce **není**? Pokračuj podle Fallbacku „publikace nedorazila".

### 11. Převeď `POL-01` na typ Politika

U `POL-01` otevři **Details** (vlastnosti), změň typ obsahu na `<ini>-Politika` a vyplň
Vlastník dokumentu (sebe), Datum účinnosti 2026-02-01, Datum příští revize 2027-02-01,
Klasifikace `Interní`. Ulož.

**Checkpoint:** `POL-01` je typu `<ini>-Politika` s vyplněnými povinnými poli a v historii
verzí přibyla **nová vedlejší verze** se stavem *Draft* — změna metadat je změna dokumentu
a jde znovu přes schválení. Publikuj a schval (jako v dopoledním labu).

### 12. Založ záznam `ZAZ-01`

V `ControlledDocs` **New** -> `<ini>-Záznam` (Word dokument), název
`ZAZ-01 Zápis z přezkoumání vedením 2026`, obsah dvě věty (datum jednání, kdo byl přítomen,
že vedení schválilo revizi politik). Vyplň Vlastník dokumentu (sebe), Datum vzniku záznamu
(dnešní datum), Klasifikace `Interní`. Publikuj hlavní verzi a schval ji.

**Checkpoint:** `ZAZ-01` je typu `<ini>-Záznam`, verze 1.0, stav *Approved*, a formulář
po něm **nechtěl** datum příští revize. Na tento záznam navazuje retence v D3.

### 13. Zapiš do SoA

Na Tenant A přidej do `SoA` dva řádky. K řádku pro Tenant B přilož jako **přílohu položky**
screenshot knihovny `Dokumentace` se třemi vyplněnými sloupci. Před přiložením zkontroluj, co
obrázek ukazuje (adresy, jména) — na kurzovním tenantu to nevadí, v praxi je to únik informací.

| Opatření | Aplikovatelné | Zdůvodnění | Capability M365 | Důkaz | Modul | Tenant |
|---|---|---|---|---|---|---|
| kap. 7.5 | ano | vlastní věta | typy obsahu Politika / Směrnice / Záznam s povinnými metadaty (hub, nebo lokální `L-*`) | odkaz na typy obsahu knihovny `ControlledDocs` | `content-type-hub` | A |
| kap. 7.5 | ano | vlastní věta, včetně jedné chyby Autofill z kroku 9 | Autofill columns navrhují typ, vlastníka a datum revize; člověk ověřuje | odkaz na knihovnu `Dokumentace` na Tenant B + screenshot v příloze | `content-type-hub` | B |

Vyplň i Stav zavedení, Prioritu, Termín a Odpovědnou osobu (u zavedených opatření Termín
necháš prázdný).

**Checkpoint:** v `SoA` jsou dva nové řádky 7.5 s Modul = `content-type-hub`, jeden s Tenant A,
jeden s Tenant B a přílohou.

## Ověření

- [ ] V Content type gallery jsou tři typy obsahu `<ini>-*` v kategorii `<ini>-ISMS`,
      publikované; čas publikace zapsaný.
- [ ] **Negativní:** sdílené sloupce `VS ISMS` a typy obsahu ostatních jsou beze změny.
- [ ] Na Tenant B má `Dokumentace` tři Autofill sloupce a hodnoty u všech sedmi dokumentů.
- [ ] **Negativní:** sloupec Person Autofill nenabízí.
- [ ] Tabulka 21 ověření s aspoň jednou chybou nebo prázdnou hodnotou; jedna ruční oprava;
      náklad spočítaný.
- [ ] `ControlledDocs` má tři typy obsahu (hubové nebo `L-*`), `POL-01` je Politika,
      `ZAZ-01` je schválený Záznam.
- [ ] V `SoA` jsou dva řádky 7.5 (A a B).

## Fallback

- **Publikace nedorazila do kroku 10:** na webu `isms-<ini>` vytvoř lokální typy obsahu
  (**Site settings** -> **Site content types** -> **Create**) s názvy `L-Politika`,
  `L-Směrnice`, `L-Záznam`, rodič **Document**, a sloupce si vytvoř na webu podle tabulky
  sdílených sloupců v README (nejdřív s ASCII názvem, pak přejmenovat). Do Capability v SoA
  napiš „lokální typy obsahu; hubová publikace nedorazila do X min". Hubové typy, které
  dorazí později, ke knihovně **nepřidávej** — dva typy Politika v jedné knihovně jsou chyba.
- **Content type gallery nejde otevřít** (role): kroky 2–4 udělá lektor za tebe ve tvé
  kategorii, nebo rovnou fallback s lokálními typy.
- **Na Tenant B se Autofill nenabízí** (sekce Autofill v panelu sloupce chybí): web není
  v rozsahu Autofill nebo PAYG není aktivní — ohlas lektorovi a kroky 6–9 sleduj jako demo.
- **Zpracování v kroku 8 trvá déle než lab:** pokračuj krokem 10; kroky 9 dokonči na konci
  bloku nebo v pauze.
- **Typy obsahu nejsou v knihovně vůbec** (ani hubové, ani `L-*`): `ZAZ-01` v kroku 12
  přesto založ a schval — den 3 potřebuje schválený záznam; typ obsahu doplníš později.
- **Při časové tísni:** kroky 6–9 jako demo lektora (kompresní ventil dne č. 1); řádek 7.5
  pro Tenant B zapiš s odkazem na lektorovu knihovnu. Řádky SoA převezmi z
  [`reseni-typy-obsahu-autofill.md`](reseni-typy-obsahu-autofill.md).

## Zdroje

- [Create or customize a content type](https://learn.microsoft.com/en-us/sharepoint/create-customize-content-type)
- [Add columns to a content type](https://learn.microsoft.com/en-us/sharepoint/add-columns-content-type)
- [Publish a content type](https://learn.microsoft.com/en-us/sharepoint/publish-content-type)
- [Create an autofill column](https://learn.microsoft.com/en-us/microsoft-365/documentprocessing/autofill)
- [Pay-as-you-go pricing for document processing](https://learn.microsoft.com/en-us/microsoft-365/documentprocessing/syntex-pay-as-you-go-services)
