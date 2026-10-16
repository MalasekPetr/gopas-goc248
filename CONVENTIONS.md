# Konvence

Závazná pravidla pro psaní materiálů GOC248. Cíl: konzistence napříč moduly a snadná
údržba (malé soubory = malé diffy).

## Jazyk

- **Obsah**: čeština. Nikdy azbuka.
- **Cesty a názvy souborů/složek**: angličtina, `kebab-case`.
- **Skripty** (PowerShell): identifikátory a komentáře anglicky.
- **Názvy v UI** uvádět tak, jak je student uvidí (Purview a Entra jsou v kurzu v angličtině),
  při prvním výskytu s českým vysvětlením.

## Struktura modulu

Jeden modul = jedna složka. Slug složky, ne pořadové číslo. Volitelné moduly mají prefix `opt-`.

| Soubor | Účel | Publikum |
|---|---|---|
| `README.md` | výklad modulu | student |
| `lab-*.md` | zadání labu | student |
| `instructor-notes.md` | timing, go/no-go, tripwires | jen lektor |

Další soubory podle potřeby (bez šablony, konzistentní pojmenování):

| Prefix | Účel |
|---|---|
| `explainer-<téma>.md` | deep-dive na jeden mechanismus, odkazovaný z README |
| `comparison-<téma>.md` | srovnávací tabulka + rozhodovací osa |
| `guide-<téma>.md` | krok-za-krokem návod (referenční postup) |
| `demo-<téma>.md` | instruktorské demo bez studentského labu |
| `mereni-<téma>.md` | surová data ověření na tenantu + návod na reprodukci |
| `reseni-<lab>.md` | referenční řešení labu (řádky SoA, návrh taxonomie, podklad hlášení) |
| `template-<téma>.md` | šablona, kterou si student odnáší (např. podklad pro hlášení incidentu) |
| `troubleshooting-<téma>.md` | známé chyby a jejich řešení |

Pořadí modulů v běhu drží **`agenda.md`** — je to jediný zdroj pravdy o pořadí. Změna pořadí =
úprava `agenda.md`, ne přejmenování složek.

## Odkazování mezi moduly

- H1 nadpis modulu je jen `# <Název>` — **žádná pořadová čísla** v nadpisech ani v textu.
- Křížové odkazy mezi moduly vždy **slugem jako relativní odkaz na složku**:

  ```md
  jiný modul ve stejném dni:  [`../dlp/`](../dlp/)
  modul v jiném dni:          [`../../day-5/compliance-manager-capstone/`](../../day-5/compliance-manager-capstone/)
  soubor v kořeni:            [`../../environment.md`](../../environment.md)
  ```

- V instruktorských poznámkách (sekce Vazby) stačí backtick slug bez odkazu.
- Po každém hromadném zásahu ověřit odkazy **skriptem, ne odhadem**
  (`./scripts/Test-RepoIntegrity.ps1`).

## Zdroje — co smí být odkazem

Externí odkazy jsou **primárně Microsoft Learn** pro produktová fakta a **oficiální právní
zdroje** pro právní fakta. Stálé vyhlášené výjimky:

| Doména | Pro co |
|---|---|
| `learn.microsoft.com` | produktová fakta, licence, limity, postupy |
| `www.microsoft.com/licensing`, service descriptions na Learn | licenční realita |
| `nukib.gov.cz`, `portal.nukib.gov.cz` | metodiky, podpůrné materiály, hlášení incidentů |
| `e-sbirka.gov.cz` | znění zákona č. 264/2025 Sb. a prováděcích vyhlášek |
| `pnp.github.io` | PnP PowerShell — reference příkazů pro skripty |
| `support.microsoft.com` | uživatelská nápověda Microsoftu (nastavení verzí, Approvals v seznamech) — jen když Learn tvrzení nemá |

Blogy, roadmapy třetích stran a Message Center mirrory **nejsou zdrojem** — smí sloužit jen
jako stopa, kterou je třeba dohledat na Learn. Když Learn tvrzení nemá, je to otevřená otázka.

> [!IMPORTANT] Text normy ISO/IEC 27001 se necituje
> Norma je chráněná autorským právem. V materiálech jen **číslo opatření** (např. A.8.12)
> a **vlastní parafráze** jednou větou. Totéž platí pro texty šablon Compliance Manageru
> převzaté z normy.

## Nic netvrdit bez ověření

Nejdůležitější pravidlo repa. Každé netriviální tvrzení je buď **ověřitelné z dokumentace
s odkazem**, nebo **ověřené na kurzovním tenantu s datem**. Ne „štítek se objeví za pár
minut", ale „publikace label policy na Tenant A 2027-01-xx: N min do zobrazení v knihovně" —
s odkazem na soubor `mereni-*.md`.

```md
> [!IMPORTANT] <Pointa jako tvrzení, ne štítek> — ověřeno na tenantu (RRRR-MM-DD)
> <čísla / co se dělo / na kterém tenantu>
>
> **<Přenositelné pravidlo, jedna věta.>**
```

Tři pravidla:

1. **Latence bez data a bez tenantu neexistuje.** Propagace politik a ingest auditu se liší
   tenant od tenantu a měsíc od měsíce — vždy uvést, **kde a kdy**.
2. **Nedopisovat vzorové výstupy.** Když ověření neproběhlo, je v repu prázdné místo s datem
   a otevřenou otázkou — ne vymyšlený screenshot ani „typický" záznam auditu.
3. **Co nevíš, napiš jako otevřenou otázku.** V labu i v instructor notes.

## Currency-markery

Licence, ceny, preview stavy, retirement data a metodiky NÚKIB se mění po měsících:

```md
> [!WARNING] Ověřit k datu běhu — stav k <RRRR-MM>.
> Licence / cena / preview stav / retirement datum / název v UI / verze metodiky.
```

Přejmenování:

```md
> [!IMPORTANT] Názvosloví
> <starý název> -> <aktuální název>. V UI / dokumentaci se může objevit staré jméno.
```

## Povinné sekce README modulu

Kromě výkladu má každý modul tyto sekce (kontroluje `Test-RepoIntegrity.ps1`):

- `## Licence` — co z bloku zvládne Business Premium, E3 a co až E5 / add-on; s odkazem.
  Slib kurzu „co máte ve své licenci" se dodržuje modul po modulu, ne jednou tabulkou.
- `## Nosná linka` — co přibylo ve workspace a **které řádky SoA** blok zapsal.
- `## Stav produktu / delta` — co ověřit k datu běhu:

  ```md
  ## Stav produktu / delta

  > [!WARNING] Ověřit k datu běhu — stav k <RRRR-MM>.
  > <co ověřit: licence, název v UI, preview stav>
  ```

Modul bez těchto sekcí je nedokončený.

## Markdown styl

- Nadpisy `##` / `###`, žádné přeskoky úrovní.
- Krátké odstavce, odrážky pro výčty.
- Názvy produktů, nástrojů a pojmů vždy proti [`GLOSSARY.md`](./GLOSSARY.md).
- Číslované seznamy číslovat **skutečně** (`1.`, `2.`, `3.`).

## Mermaid

- Diagramy jako fenced bloky ` ```mermaid ` přímo v `.md`. GitHub je renderuje nativně.
- **Výchozí motiv** (bez `%%{init}%%`).
- V popiscích uzlů **jen ASCII** — diakritika v Mermaidu je nespolehlivá.

## Dva tenanty — tenantová disciplína

Kurz běží na **dvou** tenantech (viz [`environment.md`](./environment.md)). Na Tenant A je
**každý student Global Administrator** — pohodlné pro laby a zároveň nejdražší riziko kurzu:
jedna chybně zacílená politika mění prostředí všem, chybná CA politika zamkne celou učebnu.

- **Každý modul má v meta-bloku tenant a režim** (`hands-on, vlastní scope` / `hands-on,
  celý tenant` / `instruktorské demo`).
- **Vlastní scope studenta na Tenant A**: web `isms-<ini>`, skupina `isms-<ini>-users`,
  testovací uživatel `test-<ini>`. Každá politika, kterou student vytvoří, je **scopovaná jen
  na ně** a má v názvu prefix `<ini>-`.
- **Bezpečné režimy**: Conditional Access jen **report-only**, vynucení jen na vlastním
  testovacím uživateli; DLP jen v **simulaci**; nouzové (break-glass) účty jsou z každé CA
  politiky **vyloučené** — bez výjimky.
- **PIM jen přes PIM for Groups** na vlastní skupině. Nastavení PIM pro role Microsoft Entra
  platí pro celý tenant a 15 studentů by se v něm navzájem přepisovalo.
- **Každý lab, který vytváří politiku, má negativní checkpoint**: na cizím webu, skupině nebo
  uživateli se nic nezměnilo.
- **Na Tenant B je student jen vlastník svého webu**, bez admin rolí. Cokoli tenantového na B
  (nasazení agenta pro organizaci, admin consent) je instruktorské demo.
- **Oddělený profil prohlížeče pro každý tenant.** Global Administrator ve špatném okně
  prohlížeče je reálný dopad, ne zmatek.

## Normiqa Navigator — neutralita

Katalog jmenuje agenta **Normiqa Navigator** (produkt Malach IS) jako referenční hotový agent
z Microsoft Marketplace. Je to **jediná** jmenovitá zmínka produktu Malach IS v kurzu; jinde
se produkty Malach IS jako příklady nepoužívají.

- Blok `normiqa-navigator-demo` hodnotí agenta **stejnými kritérii jako jakéhokoli jiného**
  hotového agenta (vydavatel, oprávnění, kam tečou data, admin consent, cena, exit) —
  kritéria jsou v labu dřív, než se agent ukáže.
- Žádná marketingová tvrzení o produktu; jen to, co student na tenantu sám uvidí.

## Instructor notes

`instructor-notes.md` v každém modulu, **do 60 řádků**, tři povinné sekce:

- **Timing** — kolik minut, jak se to rozpadá, co se krátí první.
- **Go/no-go** — co ověřit *před* během. Konkrétně, ne „připravit prostředí".
- **Tripwires** — kde to studentům spolehlivě ujede a co s tím.

Volitelně `## Vazby` (Zpět / Dopředu). Nepatří sem navigace, dlouhá řešení ani historie
přestavby kurzu.

## Laby

- Meta-blok má vždy `Modul:` / `Odhad:` / `Režim:` / `Tenant:`.
- Každý krok končí **`**Checkpoint:**`** — konkrétní stav, který lektor ověří pohledem
  (co je vidět v portálu, výstup příkazu), ne dojem studenta. Aspoň jeden checkpoint v labu
  je **negativní**.
- Krok, který přepíná tenant, má vlastní checkpoint: **správný účet ve správném profilu**.
- Lab končí zápisem řádků do SoA (krok „Zapiš do SoA").
- Sekce `## Ověření` na konci je agregát checkpointů jako `- [ ]` checkboxy.
- Sekce `## Fallback` je povinná: co dělat, když krok selže (typicky propagace politiky trvá
  déle než lab), a varianta pro časovou tíseň.

## Skripty

- Příkazy v labech jsou **PowerShell 7**, ne bash. Line continuation je backtick (`` ` ``).
- Provozní skripty: `Verb-Noun.ps1`, idempotentní, comment-based help, min. 3 `.EXAMPLE`;
  skripty, které něco mění, podporují `-WhatIf`.
- `Connect-PnPOnline` vždy s `-ClientId`. **Žádné tenant ID, ClientId, adresy SharePointu
  tenantů ani hesla natvrdo** — parametry nebo lokální soubor `*.local.*` (gitignored).
- V kódových blocích a skriptech **jen ASCII**. V prozaickém textu je česká typografie v pořádku.
- Skripty psát **do souboru a spouštět**, ne inline do shellu.
- **Reálná data do labů nepatří.** Fiktivní firma Vltava Servis, fiktivní lidé a incidenty.
