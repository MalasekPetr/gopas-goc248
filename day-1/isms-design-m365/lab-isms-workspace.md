# Lab · ISMS workspace a seznam SoA

> Modul: `isms-design-m365` · Odhad: 80 min · Režim: hands-on, vlastní scope
> Tenant: A `cloudedu.cz` · Scénář: [`../../scenario-isms-vltava.md`](../../scenario-isms-vltava.md)

## Cíl

Komunikační web `/sites/isms-<ini>` na Tenant A se seznamem **SoA** v pevném schématu, stránkou
Mapa ISMS, mapovací maticí v knihovně a dvěma prvními řádky SoA s funkčním odkazem na důkaz.

**Jak lab číst:** každý krok končí **Checkpointem** — nesedí-li, nepokračuj. Schéma SoA je
pevné: interní názvy přesně podle tabulky, jinak se rozbijí laby dalších dnů.

## Předpoklady

- Hotový [`../onboarding/`](../onboarding/) (profil `GOC248 A`, MFA) a
  [`../requirements-mapping-m365/`](../requirements-mapping-m365/) (sešit `<ini>-mapovaci-matice`
  v OneDrive).
- Skupina `isms-<ini>-users` existuje (ověřeno v onboardingu, krok 4).

## Kroky

### 1. Ověř profil

**Checkpoint (správný účet ve správném profilu):** okno `GOC248 A`, vpravo nahoře účet
`@cloudedu.cz`.

### 2. Založ komunikační web

Microsoft 365 admin center -> **Admin centers** -> **SharePoint** -> **Sites** -> **Active
sites** -> **Create** -> **Communication site**. Vyber šablonu bez ukázkového obsahu (název
šablony se v čase mění — lektor ukáže aktuální). Vyplň:

| Pole | Hodnota |
|---|---|
| Site name | `ISMS <ini>` |
| Site address | přesně `isms-<ini>` (adresu navržená z názvu přepiš) |
| Site owner | ty |
| Language | English |
| Time zone | `(UTC+01:00) Belgrade, Bratislava, Budapest, Ljubljana, Prague` |

Časová zóna není kosmetika: v úterý z ní počítá sloupec **Lhůta prvotního hlášení** v Incident
logu (24 h od zjištění incidentu). Pole a jeho popisek v průvodci jsou neověřené na
tenantu — když ho průvodce nenabídne nebo ho přehlédneš, nastav zónu po založení v nastavení
webu -> **Regional settings**.

**Checkpoint:** v Active sites je web `isms-<ini>` s adresou končící přesně `/sites/isms-<ini>`.
**Negativní:** adresa **nemá** číselnou příponu (např. `isms-<ini>2`) — pokud ano, web nepoužívej
a zavolej lektora (pozůstatek předchozího běhu).

### 3. Ověř, že nevznikla skupina

Microsoft Entra admin center -> **Groups** -> vyhledej `isms-<ini>`.

**Checkpoint (negativní):** ve výsledcích je jen `isms-<ini>-users`; žádná nová skupina
Microsoft 365 jménem `isms-<ini>` nevznikla — to je důvod volby komunikačního webu.

### 4. Pusť do webu jen skupinu `isms-<ini>-users`

Na webu `isms-<ini>`: ozubené kolo -> **Site permissions** -> **Advanced permissions settings** ->
skupina **isms-<ini> Members** -> **New** -> **Add users to this group** -> `isms-<ini>-users`.
Zrušit zaškrtnutí odeslání e-mailu, **Share**.

**Checkpoint:** ve skupině *isms-<ini> Members* je `isms-<ini>-users`. **Negativní:** do skupiny
*Owners* jsi nikoho nepřidal a cizí skupiny `isms-<jiné ini>-users` tam nejsou.

### 5. Založ seznam SoA

Na webu: **Site contents** -> **New** -> **List** -> **Blank list**. Name: `SoA`. Description:
`Prohlaseni o aplikovatelnosti a prehled opatreni - Vltava Servis`. Zrušit zobrazení
v navigaci, pokud je nabídnuto — odkaz dáme na stránku Mapa ISMS.

**Checkpoint:** seznam se otevře na adrese končící `/Lists/SoA`.

### 6. Přejmenuj sloupec Title

V seznamu SoA: záhlaví sloupce **Title** -> **Column settings** -> **Rename** -> `Opatření`.

**Checkpoint:** záhlaví zní **Opatření**. V **List settings** (ozubené kolo) -> klik na sloupec
Opatření: adresa stránky obsahuje `Field=Title`.

### 7. Založ jedenáct sloupců s ASCII názvy

V seznamu **+ Add column** -> typ -> do pole **Name** napiš přesně interní název (bez mezer,
bez diakritiky). Pořadí a typy:

| Name (při založení) | Typ | Nastavení |
|---|---|---|
| `Requirement` | Single line of text | — |
| `Applicable` | Choice | volby `ano`, `ne`; bez výchozí hodnoty |
| `Justification` | Multiple lines of text | — |
| `Capability` | Single line of text | — |
| `Evidence` | Hyperlink | — |
| `Module` | Single line of text | — |
| `Tenant` | Choice | volby `A`, `B`; výchozí `A` |
| `ImplementationStatus` | Choice | volby `Zavedeno`, `Částečně zavedeno`, `Plánováno`, `Nezavedeno`; bez výchozí hodnoty |
| `Priority` | Choice | volby `Vysoká`, `Střední`, `Nízká`; bez výchozí hodnoty |
| `DueDate` | Date and time | Include time: **No** |
| `ResponsiblePerson` | Person | jedna osoba (bez více hodnot) |

Volby u choice sloupců smí mít diakritiku — ASCII musí být jen pole **Name**.

**Checkpoint:** v List settings -> Columns je dvanáct sloupců (Opatření + jedenáct). Klik na
`Requirement` -> adresa obsahuje `Field=Requirement`.

### 8. Přejmenuj sloupce na české zobrazované názvy

Pro každý sloupec **Column settings** -> **Edit** -> Name:

| Interní | Nový zobrazovaný název |
|---|---|
| `Requirement` | Požadavek |
| `Applicable` | Aplikovatelné |
| `Justification` | Zdůvodnění |
| `Capability` | Capability M365 |
| `Evidence` | Důkaz |
| `Module` | Modul |
| `Tenant` | Tenant (beze změny) |
| `ImplementationStatus` | Stav zavedení |
| `Priority` | Priorita |
| `DueDate` | Termín |
| `ResponsiblePerson` | Odpovědná osoba |

**Checkpoint:** záhlaví jsou česky. V List settings klik na **Požadavek** -> adresa pořád
obsahuje `Field=Requirement`; totéž **Důkaz** -> `Field=Evidence`. **Negativní:** u žádného
sloupce adresa neobsahuje kódované znaky `_x00` — jinak byl sloupec založen s diakritikou;
smaž ho a založ znovu podle kroku 7.

### 9. Přesuň mapovací matici na web

V OneDrive (profil A) vyber sešit `<ini>-mapovaci-matice` -> **Copy to** -> web `isms-<ini>` ->
knihovna **Documents**. (Kdo jel podle Fallbacku z `requirements-mapping-m365`: na webu
v Documents **New** -> **Excel workbook** `<ini>-mapovaci-matice` a vlož matici.)

Otevři sešit v knihovně webu a zkopíruj jeho adresu z adresního řádku.

**Checkpoint:** v knihovně Documents webu `isms-<ini>` je sešit `<ini>-mapovaci-matice` a máš
zkopírovanou adresu, která vede na **web**, ne do OneDrive (obsahuje `/sites/isms-<ini>/`).

### 10. Stránka Mapa ISMS

Na webu **New** -> **Page** -> prázdná. Název `Mapa ISMS`. Do textové webové části vlož tabulku
plánovaných kontejnerů z [`reseni-isms-workspace.md`](reseni-isms-workspace.md) (sekce
„Informační architektura") a odkazy na seznam SoA a sešit matice. **Publish** a přidej stránku
do navigace webu.

**Checkpoint:** stránka Mapa ISMS je publikovaná, je v navigaci webu a odkazy na SoA a sešit
fungují.

### 11. Zapiš do SoA

Do seznamu SoA přidej dva řádky:

| Opatření | Požadavek | Aplikovatelné | Zdůvodnění | Capability M365 | Důkaz | Modul | Tenant |
|---|---|---|---|---|---|---|---|
| A.5.31 | vyhl. 410/2025 Sb. § 3 odst. 2, příloha č. 1 | ano | Požadavky zákona a vyhlášky pro režim nižších povinností jsou identifikované a namapované na opatření a capabilities. | mapovací matice v knihovně webu | adresa sešitu z kroku 9 | `requirements-mapping-m365` | A |
| kap. 6.1.3 | vyhl. 410/2025 Sb. § 3 odst. 2, příloha č. 1 | ano | Jeden seznam slouží jako SoA i jako přehled bezpečnostních opatření; stav, priorita, termín a odpovědná osoba podle přílohy č. 1 jsou samostatné sloupce. | seznam SoA na webu `isms-<ini>` | adresa seznamu SoA | `isms-design-m365` | A |

Zdůvodnění piš vlastními slovy; tabulka je vzor. Vyplň i Stav zavedení, Prioritu, Termín
a Odpovědnou osobu: u obou řádků Stav zavedení `Zavedeno`, Odpovědná osoba ty, Termín
prázdný (u zavedených opatření se nevyplňuje).

**Checkpoint:** v SoA jsou dva řádky, oba s vyplněným sloupcem Důkaz (odkaz se po kliknutí
otevře), Modul = slug bloku a Stav zavedení `Zavedeno`.

## Ověření

- [ ] Web `/sites/isms-<ini>` (komunikační, English), vlastník ty, adresa bez číselné přípony.
- [ ] **Negativní:** nevznikla skupina Microsoft 365 `isms-<ini>`.
- [ ] `isms-<ini>-users` je ve skupině Members; Owners beze změny.
- [ ] Seznam `/Lists/SoA` s dvanácti sloupci; interní názvy `Title`, `Requirement`, `Applicable`,
      `Justification`, `Capability`, `Evidence`, `Module`, `Tenant`, `ImplementationStatus`,
      `Priority`, `DueDate`, `ResponsiblePerson`.
- [ ] **Negativní:** žádný interní název neobsahuje `_x00`.
- [ ] Sešit `<ini>-mapovaci-matice` v knihovně Documents webu.
- [ ] Stránka Mapa ISMS publikovaná a v navigaci.
- [ ] Dva řádky SoA (A.5.31, kap. 6.1.3) s funkčním odkazem v Důkaz a Stav zavedení `Zavedeno`.

## Fallback

- **Create v SharePoint admin center nenabízí komunikační web nebo selže:** založ web ze
  SharePoint start page (**+ Create site** -> Communication site) se stejnou adresou; když ani
  to, lektor založí web skriptem a ty pokračuješ krokem 3.
- **Adresa `isms-<ini>` je obsazená:** nepokračovat s jinou adresou — lektor odstraní starý web
  nebo přesměrování a ty založíš znovu.
- **Sloupec založen se špatným interním názvem:** smazat a založit znovu (krok 7); přejmenování
  interní název neopraví.
- **Copy to z OneDrive nefunguje:** stáhnout sešit a nahrát ho do Documents na webu.
- **Při časové tísni:** krok 10 (Mapa ISMS) vypadne — plán IA zůstane v
  [`reseni-isms-workspace.md`](reseni-isms-workspace.md); řádky SoA převzít z řešení, ale
  **Důkaz musí odkazovat na tvůj vlastní sešit a seznam**. Kroky 2–8 a 11 se nekrátí.

## Zdroje

- [Create a site — SharePoint admin center](https://learn.microsoft.com/en-us/sharepoint/create-site-collection)
- [Introduction to SharePoint information architecture](https://learn.microsoft.com/en-us/sharepoint/information-architecture-modern-experience)
- [SharePoint naming guidelines — PnP community docs](https://pnp.github.io/community-docs/articles/sharepoint-naming-guidelines.html)
