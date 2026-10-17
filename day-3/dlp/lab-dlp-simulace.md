# Lab · DLP politika v simulaci nad ISMS webem

> Modul: `dlp` · Odhad: 55 min · Režim: hands-on, vlastní scope; politika jen v simulaci
> Tenant: A `cloudedu.cz` · Scénář: [`../../scenario-isms-vltava.md`](../../scenario-isms-vltava.md)

## Cíl

Web `isms-<ini>` je pod DLP politikou `<ini>-DLP-ISMS-osobni-udaje` v simulaci, která hlídá
dokumenty se studentovým štítkem nebo s rodným číslem, a v SoA je řádek A.8.12.

**Jak lab číst:** každý krok končí **Checkpointem** — nesedí-li, nepokračuj.

> [!WARNING] Bezpečný režim
> DLP politika na kurzovním tenantu je **jen v simulaci**, **jen** v lokaci *SharePoint sites*
> a **jen** pro web `isms-<ini>`. Volbu automatického zapnutí po 15 dnech **nikdy** nezaškrtávej.

## Předpoklady

- Hotový lab [`../sensitivity-labels/`](../sensitivity-labels/): štítek `<ini>-ISMS důvěrné`
  (nebo poznámka, že zatím používáš Důvěrné \ Vltava).
- Testovací rodné číslo napsané lektorem na tabuli (fiktivní, ověřené testem SIT).
- Profil prohlížeče pro Tenant A, kurzovní účet.

## Kroky

### 1. Ověř účet a profil

**Checkpoint:** v Purview portálu je vpravo nahoře `jmeno.prijmeni@cloudedu.cz` v profilu
Tenant A.

### 2. Připrav testovací dokument

Na webu `isms-<ini>` v knihovně **Documents** (ne v Řízené dokumentaci) vytvoř dokument Word
`TEST-DLP-osobni-udaje.docx` s textem:

```text
Vltava Servis s.r.o. - TEST DLP - fiktivni data
Zamestnanec: Jan Testovaci
Rodne cislo: <testovaci hodnota z tabule>
```

V Word for the web mu dej štítek `<ini>-ISMS důvěrné` (případně Důvěrné \ Vltava).

**Checkpoint:** dokument je v knihovně Documents, ve sloupci Sensitivity má štítek a obsahuje
hodnotu z tabule — žádné skutečné rodné číslo.

### 3. Vytvoř DLP politiku v simulaci

Purview → **Solutions** → **Data Loss Prevention** → **Policies** → **Create policy** →
kategorie pro aplikace a zařízení → šablona **Custom** → **Custom policy**.

| Nastavení | Hodnota |
|---|---|
| Name | `<ini>-DLP-ISMS-osobni-udaje` |
| Admin units | Full directory |
| Locations | **jen SharePoint sites** → **Edit** → *Included*: `https://<tenant>.sharepoint.com/sites/isms-<ini>`; Exchange, OneDrive, Teams, Devices, Instances, On-premises, Fabric, Copilot **vypnuté** |
| Rule name | `<ini>-DLP-RC-nebo-stitek` |
| Conditions | **Content contains** → skupina s operátorem **Any of these**: *Sensitivity labels* = `<ini>-ISMS důvěrné` a Důvěrné \ Vltava; *Sensitive info types* = **Czech personal identity number** (instance count od 1) |
| Actions | **Restrict access or encrypt the content in Microsoft 365 locations** → **Block only people outside your organization** |
| User notifications | **On** — policy tips uživatelům |
| Incident reports | závažnost **Low**; upozornění poslat **sobě**; při každé shodě |
| Mode | **Run the policy in simulation mode** + **Show policy tips while in simulation mode** |
| Turn the policy on if it's not edited within fifteen days | **NEZAŠKRTNUTO** |

**Checkpoint:** politika je v seznamu se stavem **In simulation with notifications** (nebo
obdobným „In simulation") a na kartě shrnutí je jediná lokace SharePoint sites.

### 4. Ověř scope politiky (negativní checkpoint)

Otevři detail své politiky a lokaci SharePoint sites.

**Checkpoint (negativní):** v *Included* je jen `/sites/isms-<ini>` — ne *All sites* a ne web
kolegy; ostatní lokace jsou **Off**. Lektor namátkou otevře detail dvou politik.

### 5. Vyvolej vyhodnocení

V dokumentu `TEST-DLP-osobni-udaje.docx` dopiš řádek (např. „Kontrola DLP <čas>") a ulož — změna
obsahu na SharePointu spustí vyhodnocení. Pak nahraj do knihovny Documents ještě kopii
dokumentu bez štítku (obsahuje jen rodné číslo).

**Checkpoint:** obě verze jsou uložené, čas úpravy máš v poznámce. (Výsledek se může objevit
s odstupem — viz krok 6.)

### 6. Najdi výsledek simulace (kompresní ventil 2)

**Data Loss Prevention** → **Policies** → vyber svou politiku → **View simulation**. Projdi
karty **Simulation overview**, **Items for review**, **Alerts**.

**Checkpoint:** na Simulation overview je stav skenování SharePointu (*In progress* nebo
*Completed*) a počet prohledaných položek. Když už jsou shody, v Items for review je aspoň jeden
z testovacích dokumentů. Když ne, zapiš si čas a pokračuj krokem 7 na lektorské politice.

### 7. Activity explorer a upozornění (kompresní ventil 2)

**Data Loss Prevention** → **Activity explorer** (nebo **Explorers** → **Activity explorer**).
Filtr **Activity** = *DLP rule matched*, filtr **Policy mode** = `TestWithNotifyUser`.

**Checkpoint:** v Activity exploreru je událost *DLP rule matched* pro tvou politiku, nebo — dokud
nedorazí — pro lektorskou `LEKTOR-DLP-demo`; umíš u ní ukázat pravidlo, soubor a uživatele.

### 8. Rozhodni o vynucení

Ve dvojici napište tři věty: (1) co by politika v ostrém režimu udělala s dokumentem z kroku 2,
(2) jaké falešné shody čekáte ve skutečné firmě (číslo smlouvy, číslo zakázky…), (3) podle čeho
a kdo rozhodne o přepnutí do vynucení.

**Checkpoint:** odpověď (1) zní „lidé mimo organizaci by k dokumentu neměli přístup" — ne
„dokument by se smazal" ani „blokuje sdílení uvnitř firmy".

### 9. Zapiš do SoA

Do seznamu SoA ve workspace `isms-<ini>` přidej řádek:

| Opatření | Aplikovatelné | Zdůvodnění | Capability M365 | Důkaz | Modul | Tenant |
|---|---|---|---|---|---|---|
| A.8.12 | ano | vlastní text (vč. „v simulaci, plán vynucení") | Purview DLP, politika `<ini>-DLP-ISMS-osobni-udaje` (SharePoint, podmínka štítek nebo rodné číslo) | snímek nastavení politiky + snímek Simulation overview v knihovně důkazů | `dlp` | A |

Sloupec **Požadavek** doplň z mapovací matice z pondělí. Vyplň i Stav zavedení, Prioritu,
Termín a Odpovědnou osobu (u zavedených opatření Termín necháš prázdný). Politika
v simulaci nic neblokuje — poctivý stav je `Částečně zavedeno` s Termínem přepnutí do vynucení.

**Checkpoint:** v SoA je řádek A.8.12 s funkčním odkazem v Důkazu a Modul = `dlp`.

## Ověření

- [ ] Testovací dokument obsahuje jen fiktivní data a má štítek.
- [ ] Politika `<ini>-DLP-ISMS-osobni-udaje` je v simulaci s policy tips.
- [ ] **Negativní:** lokace jen SharePoint sites, *Included* jen `isms-<ini>`; ostatní lokace Off.
- [ ] **Negativní:** volba automatického zapnutí po 15 dnech není zaškrtnutá.
- [ ] Student umí ukázat Simulation overview a událost *DLP rule matched* (vlastní nebo lektorskou).
- [ ] Tři věty o vynucení.
- [ ] SoA: řádek A.8.12.

## Fallback

- **Politika se nepropsala / simulace nemá výsledky do konce labu:** běžné — upozornění podle
  Learn až do 3 hodin, simulace SharePointu skenuje průběžně. Kroky 6–7 udělej na lektorské
  `LEKTOR-DLP-demo`; vlastní výsledek zkontroluj ráno dne 4 a doplň snímek do SoA. Důkazem do SoA
  je zatím snímek nastavení politiky.
- **V podmínkách nejde kombinovat štítek a SIT v jedné skupině:** vytvoř dvě pravidla
  (`<ini>-DLP-stitek`, `<ini>-DLP-RC`) se stejnou akcí.
- **Štítek `<ini>-ISMS důvěrné` není v nabídce podmínky:** použij jen Důvěrné \ Vltava a SIT.
- **Testovací rodné číslo SIT nerozpozná:** podmínka štítku zajistí shodu; poznač si to jako
  zjištění pro lektora.
- **Při časové tísni:** kroky 6 a 7 jako demo lektora (kompresní ventil 2), krok 8 jako diskuse
  s celou třídou; řádek SoA převezmi z [`reseni-dlp-simulace.md`](reseni-dlp-simulace.md).

## Zdroje

- [Learn about data loss prevention](https://learn.microsoft.com/en-us/purview/dlp-learn-about-dlp)
- [Get started with DLP simulation mode](https://learn.microsoft.com/en-us/purview/dlp-simulation-mode-get-started)
- [Get started with DLP alerts](https://learn.microsoft.com/en-us/purview/dlp-alerts-get-started)
- [Czech personal identity number entity definition](https://learn.microsoft.com/en-us/purview/sit-defn-czech-personal-identity-number)
