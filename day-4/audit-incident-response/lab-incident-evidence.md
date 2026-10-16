# Lab · Dohledání události v auditu a podklad pro hlášení

> Modul: `audit-incident-response` · Odhad: 65 min · Režim: hands-on, vlastní scope (`test-<ini>`, `isms-<ini>`)
> Tenant: A `cloudedu.cz` · Scénář: [`../../scenario-isms-vltava.md`](../../scenario-isms-vltava.md)

## Cíl

Záznam v Incident logu workspace `isms-<ini>` s vyhodnocením, lhůtou prvotního hlášení,
posouzením významnosti, odkazem na export z Purview Audit a vyplněným podkladem pro prvotní
hlášení podle [`template-podklad-hlaseni.md`](template-podklad-hlaseni.md).

**Jak lab číst:** každý krok končí **Checkpointem** — nesedí-li, nepokračuj.

> [!IMPORTANT] Nic se neodesílá
> Na Portál NÚKIB se v kurzu nic neodesílá. Podklad je cvičný a Vltava Servis fiktivní.

## Předpoklady

- Profil prohlížeče **Tenant A**, vlastní kurzovní účet.
- Poznámka `stopa-<ini>` z kroku 9 labu
  [`../../day-3/retention-lifecycle/`](../../day-3/retention-lifecycle/): místní časy, kdy jsi
  jako `test-<ini>` v knihovně **Řízená dokumentace** (1) otevřel a stáhl Politiku `POL-…`,
  (2) snížil její štítek na **Veřejné** se zdůvodněním ve Word for the web, (3) vytvořil k ní
  odkaz ke sdílení (typ odkazu máš zapsaný), (4) zkusil smazat záznam `ZAZ-01 …`.
- Incident log a Asset Register z
  [`../../day-2/lists-registers-workflow/`](../../day-2/lists-registers-workflow/).

## Kroky

### 1. Převeď časy do UTC

Do kopie šablony (krok 7) si do tabulky A2 přepiš své čtyři časy z dne 3 a ke každému doplň UTC.
V lednu platí v Česku středoevropský čas, **UTC = místní čas − 1 h**.

**Checkpoint:** máš čtyři dvojice časů místní / UTC a víš, jaký rozsah (od–do, UTC) zadáš do
vyhledávání — s rezervou aspoň 1 h na obě strany.

### 2. Spusť vyhledávání v Purview Audit

Microsoft Purview portál → **Audit** → **Search**:

- **Date and time range (UTC):** rozsah z kroku 1
- **Users:** `test-<ini>`
- **File, folder, or site:** `https://<tenant>.sharepoint.com/sites/isms-<ini>*`
- **Search name:** `<ini>-incident-D3`
- Aktivity nevybírej (chceš vidět vše, co `test-<ini>` na webu dělal) → **Search**

Úloha běží i bez otevřeného okna. Mezitím udělej krok 3.

**Checkpoint:** v přehledu úloh je `<ini>-incident-D3` se stavem *Queued*, *In progress* nebo
*Completed*. Název obsahuje tvé iniciály.

### 3. Negativní kontrola rozsahu

Spusť druhé vyhledávání `<ini>-negative`: stejný rozsah a uživatel `test-<ini>`, ale **File,
folder, or site** = web souseda `.../sites/isms-<xy>*`.

**Checkpoint (negativní):** úloha `<ini>-negative` skončí s **0 výsledky** — `test-<ini>` na
sousedově webu nic nedělal. Pokud výsledky má, ukaž je lektorovi (cizí scope je nález).

### 4. Najdi čtyři akce z dne 3

Otevři výsledky `<ini>-incident-D3`. Pro každou akci najdi záznam podle tabulky operací
v [README](README.md#které-operace-hledat) a zapiš do tabulky A2 / A6 šablony: čas v UTC,
operaci, položku (dokument).

| Akce (řádek poznámky) | Hledej operaci |
|---|---|
| 1 otevření a stažení `POL-…` | `FileAccessed`, `FileDownloaded` |
| 2 snížení štítku na Veřejné (Word for the web) | `FileSensitivityLabelChanged`; kdyby šlo o desktop, `SensitivityLabelUpdated` |
| 3 odkaz ke sdílení | *People in your organization* → `CompanyLinkCreated`; *Specific people* → `SecureLinkCreated` / `AddedToSecureLink` / `SharingSet` |
| 4 pokus o smazání `ZAZ-01` | `RecordDelete` je jen pro **provedené** smazání; zablokovaný pokus nemusí mít záznam vůbec |

Otevři detail záznamu o štítku a podívej se, zda je v něm vidět původní a nový štítek a text
zdůvodnění. Zapiš, co tam **skutečně** je.

**Checkpoint:** máš záznam pro stažení, štítek a sdílení s časem v UTC, který sedí na tvé
poznámky (± minuty). U pokusu o smazání máš zapsáno buď nalezenou operaci, nebo „záznam
nenalezen" — obojí je výsledek.

### 5. Exportuj a ulož důkaz do tenantu

V detailu úlohy **Export** → stáhni CSV. Nahraj ho do knihovny ve workspace `isms-<ini>`
(složka nebo knihovna pro důkazy, kterou máš z dne 2; jinak vytvoř složku `Důkazy incidentů`
v **Řízené dokumentaci**). **Smaž lokální kopii** ze Stažených souborů — a s ní i dokument
`POL-…`, který `test-<ini>` včera stáhl: i to je kopie řízeného dokumentu mimo tenant.

**Checkpoint:** CSV je ve workspace a jeho odkaz máš zkopírovaný. Ve složce Stažené soubory
na učebním PC není ani CSV, ani `POL-…`. Soubor je v místě, kam `test-<ini>` nemá přístup (nebo je označený
štítkem z dne 3).

### 6. Rozhodni: událost, nebo incident — a zapiš do Incident logu

Vyplň v šabloně **A3**. Pokud je závěr „incident", zapiš si **teď** čas rozhodnutí — to je
`ClassifiedAt`. Pak v Incident logu ve workspace vytvoř položku:

| Pole | Hodnota |
|---|---|
| Název | `<ini>-INC-01 Snížení štítku a sdílení řízeného dokumentu` |
| Zjištěno | čas, kdy jsi v kroku 4 záznamy uviděl |
| Vyhodnoceno jako incident | čas rozhodnutí |
| Významný dopad | *posuzuje se* |
| Dotčená aktiva | aktivum z Asset Registeru odpovídající knihovně / dokumentu |
| Stav | *V řešení* |
| Důkazy | odkaz na CSV z kroku 5 |

**Checkpoint:** položka existuje a sloupec **Lhůta prvotního hlášení** ukazuje
`Vyhodnoceno jako incident` + 1 den. Dotčené aktivum je vybrané z Asset Registeru, ne napsané
textem.

### 7. Posuď významnost a povinnost hlásit

Zkopíruj [`template-podklad-hlaseni.md`](template-podklad-hlaseni.md) do workspace jako dokument
`<ini>-INC-01 Podklad pro hlášení`. Vyplň **A4** a **A5**: únosnou míru újmy použij z šablony
(fiktivní hodnoty Vltava Servis), oblasti ohodnoť 1–4 a napiš zdůvodnění. V Incident logu doplň
**Významný dopad** (*ano* / *ne*) a **Kritérium významnosti** (jedna až dvě věty).

**Checkpoint:** A4 má rozhodnutí u všech čtyř podmínek; A5 má šest oblastí se stupněm
a zdůvodněním. Hodnota *Významný dopad* v Incident logu odpovídá závěru A5.

### 8. Vyplň podklad pro prvotní hlášení

V dokumentu vyplň **část B** (povinná pole B2, typ incidentu v B1) — i když jsi v kroku 7
rozhodl, že se nehlásí: podklad má být hotový dřív, než padne rozhodnutí, a zítra se může
ukázat, že dopad je větší. V Incident logu vyplň **Podklad pro hlášení** odkazem na dokument.

**Checkpoint:** B2 má vyplněných všech 9 povinných polí; „Datum a čas zjištění" odpovídá poli
*Zjištěno* v Incident logu. Pole *Podklad pro hlášení* v Incident logu vede na dokument.
Stav záznamu **není** *Nahlášeno*.

### 9. Zapiš do SoA

Do seznamu SoA ve workspace `isms-<ini>` přidej řádky (Modul = `audit-incident-response`,
Tenant = A):

| Opatření | Aplikovatelné | Capability M365 | Důkaz |
|---|---|---|---|
| A.5.24 | ano | Incident log + šablona podkladu pro hlášení | odkaz na šablonu ve workspace |
| A.5.25 | ano | vyhodnocení v Incident logu (`ClassifiedAt`, významnost) | odkaz na položku `<ini>-INC-01` |
| A.5.26 | ano | podklad pro prvotní hlášení, stav záznamu | odkaz na podklad |
| A.5.28 | ano | export z Purview Audit uložený v tenantu | odkaz na CSV |
| A.8.15 | ano | Purview Audit (Standard / Premium) | odkaz na CSV |
| A.8.16 | ano | Purview Audit (zpětně); Defender XDR (přehled) | odkaz na podklad (A2: jak byla událost zjištěna) |

**Checkpoint:** v SoA je 6 nových řádků; sloupec Důkaz je u všech **klikatelný odkaz** do
workspace a Modul = `audit-incident-response`. U A.8.16 Zdůvodnění říká, co chybí (průběžné
sledování a výstrahy).

## Ověření

- [ ] Vyhledávání `<ini>-incident-D3` dokončené, rozsah v UTC.
- [ ] **Negativní:** `<ini>-negative` na webu souseda vrátilo 0 výsledků.
- [ ] Stažení, změna štítku a sdílení dohledané s časy v UTC; u pokusu o smazání zapsaný
      skutečný výsledek.
- [ ] CSV uložené ve workspace, lokální kopie smazaná.
- [ ] Položka `<ini>-INC-01` v Incident logu: Zjištěno, Vyhodnoceno, lhůta +1 den, Dotčená
      aktiva z lookupu, Důkazy, Podklad pro hlášení.
- [ ] Podklad: A3–A5 rozhodnuté a zdůvodněné, B2 všech 9 povinných polí.
- [ ] 6 řádků SoA s důkazem.

## Fallback

- **Události z dne 3 ve vyhledávání nejsou** (latence, student den 3 nestihl, špatný rozsah):
  1. zkontroluj UTC a rozšiř rozsah na celý včerejší den;
  2. zkontroluj filtr webu (končí `*`?) a uživatele;
  3. pak hledej **náhradní události lektora**: uživatel a web, které lektor napíše na tabuli
     (připravené den předem). Zbytek labu beze změny; v podkladu uveď, že jde o náhradní data.
- **Vyhledávání běží dlouho:** pokračuj kroky 6–7 s časy z poznámek a export doplň na konci.
- **Incident log nemá vypočtený sloupec lhůty:** spočítej ručně, zapiš do poznámky a nahlas
  lektorovi (chyba z dne 2).
- **Při časové tísni:** v kroku 4 stačí stažení a štítek; A5 jen tři oblasti (citlivost,
  aktiva, příčina); B jen povinná pole. Řádky SoA z
  [`reseni-incident-evidence.md`](reseni-incident-evidence.md). Krok 3 (negativní) se
  nevynechává — trvá minutu.

## Zdroje

- [Search the audit log](https://learn.microsoft.com/en-us/purview/audit-search)
- [Audit log activities](https://learn.microsoft.com/en-us/purview/audit-log-activities)
- NÚKIB: [Hlášení kybernetických bezpečnostních incidentů, v1.2](https://portal.nukib.gov.cz/storage/uploads/2026/06/08/podpurny-material-ke-hlaseni-incidentu_v1-2_uid_6a267e393778b.pdf)
- NÚKIB: [Stanovení významnosti incidentu v režimu nižších povinností](https://portal.nukib.gov.cz/storage/uploads/2026/02/24/vyznamnost-incidentu-nizsi-rezim_uid_699dada722caf.pdf)
- NÚKIB: [Návod k hlášení incidentů pro nižší režim](https://portal.nukib.gov.cz/informacni-servis/podpurne-materialy/6a1d9256fc2a7b93040173db)
