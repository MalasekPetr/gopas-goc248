# Lab · Retence a záznamy pro ISMS workspace + stopa pro audit

> Modul: `retention-lifecycle` · Odhad: 60 min · Režim: hands-on, vlastní scope; kroky 4–6 vytvářejí **tenantové objekty** scopované na vlastní web
> Tenant: A `cloudedu.cz` · Scénář: [`../../scenario-isms-vltava.md`](../../scenario-isms-vltava.md)

## Cíl

Web `isms-<ini>` je pod retenční politikou, záznam `ZAZ-01` je prohlášený za record, v poznámce
máš časy čtyř akcí `test-<ini>` pro čtvrteční audit a v SoA řádky A.5.33 a A.8.10.

**Jak lab číst:** každý krok končí **Checkpointem** — nesedí-li, nepokračuj.

> [!WARNING] Na kurzovním tenantu nikdy
>
> - **Regulatory record** — nevratný, nikdo ho neodstraní.
> - **Preservation Lock** — zamčenou politiku nikdo nevypne ani nesmaže.
> - **Odebrání posledního zahrnutého webu** z politiky — lokace se vrátí na **All** a politika
>   platí pro celý tenant. Když se spleteš, lokaci **vypni** a přidej web znovu.

## Předpoklady

- Hotové laby [`../sensitivity-labels/`](../sensitivity-labels/) (`POL-01` se sensitivity
  labelem, publikovaná hlavní verze schválená) a [`../dlp/`](../dlp/).
- V knihovně „Řízená dokumentace" je schválený záznam `ZAZ-01 Zápis z přezkoumání vedením 2026`
  typu Záznam a existuje (prázdný) seznam Incident log — z dne 2.
- Heslo účtu `test-<ini>` a jeho MFA v tvém Authenticatoru (nastavené v pondělí v
  `onboarding`; účet je člen `isms-<ini>-users` a člen webu).
- Lektor potvrdil, že kurzovní štítek `GOC248 ISMS zaznam` je na webech vidět (go/no-go úterý).

## Kroky

### 1. Ověř účet a profil

**Checkpoint:** v Purview portálu je vpravo nahoře `jmeno.prijmeni@cloudedu.cz` v profilu
Tenant A.

### 2. Ověř typ svého webu

Web `isms-<ini>` jsi v pondělí zakládal jako **komunikační web bez skupiny Microsoft 365**
([`../../day-1/isms-design-m365/`](../../day-1/isms-design-m365/)). Ověř to: SharePoint admin
centrum → **Sites** → **Active sites** → `isms-<ini>` → šablona. Nic neměň.

- Komunikační web → v krocích 5 a 6 lokace **SharePoint classic and communication sites**.
- Kdyby to byl týmový web **se skupinou** (náhradní web z fallbacku) → lokace **Microsoft 365
  Group mailboxes & sites** a v ní skupina webu.

**Checkpoint:** v poznámce máš typ webu a z něj zvolenou lokaci (u komunikačního webu
*SharePoint classic and communication sites*).

### 3. Navrhni retenční schéma na papíře

Pro čtyři druhy obsahu ISMS rozhodni: politika nebo štítek, jak dlouho, od kdy, co na konci,
záznam ano/ne.

| Obsah | Politika / štítek | Doba a počátek | Na konci | Record |
|---|---|---|---|---|
| Schválená Politika (např. řízení přístupu) | | | | |
| Záznam o přezkoumání přístupů | | | | |
| Položka Incident logu | | | | |
| Pracovní koncept v knihovně Documents | | | | |

**Checkpoint:** u položky Incident logu je „štítek" (politika položky seznamů nepokrývá) a u
aspoň jedné položky je na konci disposition review — srovnej s
[`reseni-retence-zaznamy.md`](reseni-retence-zaznamy.md), část A.

### 4. [TENANT] Vytvoř vlastní retenční štítek

Purview → **Solutions** → **Records Management** → **File plan** → **+ Create a label**:

| Nastavení | Hodnota |
|---|---|
| Name | `<ini>-ISMS záznam` (název nejde později změnit) |
| Description for users | „Záznam ISMS Vltava Servis — uchovat 5 let od označení, pak kontrola likvidace." |
| Label settings | **Retain items indefinitely or for a specific period** |
| Retention period | **5 years**, start **When items were labeled** |
| Mark items as a record | **ano** — record, **ne** regulatory record |
| Po skončení | **Start a disposition review**, jedna fáze, recenzent = ty |

**Checkpoint:** v File plan je `<ini>-ISMS záznam` se sloupcem *Record* = Yes a retencí 5 let;
u volby regulatory record nic nevybráno.

### 5. [TENANT] Publikuj štítek jen na svůj web

**Records Management** → **Policies** → **Label policies** → **Publish labels** → štítek
`<ini>-ISMS záznam`:

| Nastavení | Hodnota |
|---|---|
| Admin units | Full directory |
| Type | **Static** |
| Locations | jen lokace z kroku 2 → **Edit** → zahrnout jen `isms-<ini>`; všechny ostatní lokace **Off** |
| Name | `<ini>-ISMS zaznam publikace` |

**Checkpoint (negativní):** v detailu policy je jediná zapnutá lokace a v ní jediný zahrnutý
web / skupina `isms-<ini>` — ne *All*.

### 6. [TENANT] Vytvoř retenční politiku na web

Purview → **Solutions** → **Data Lifecycle Management** → **Policies** → **Retention policies** →
**New retention policy**:

| Nastavení | Hodnota |
|---|---|
| Name | `<ini>-ISMS retence web` |
| Admin units | Full directory |
| Type | **Static** |
| Locations | jako v kroku 5 — jen `isms-<ini>`, vše ostatní **Off** |
| Retention | **Retain items for a specific period** = **3 years**, start **When items were created**, na konci **Do nothing** |

**Checkpoint:** politika je v seznamu se stavem **On (Pending)** nebo **On (Success)** a v detailu
je jediná lokace s jediným webem `isms-<ini>`. **Negativní:** politika neobsahuje žádné *All*.

### 7. Prohlas záznam kurzovním štítkem

Tvůj štítek se na webu objeví nejdřív zítra (Learn: obvykle do dne, až 7 dní). Záznamy proto
prohlas **kurzovním** štítkem `GOC248 ISMS zaznam`:

1. V „Řízené dokumentaci" vyber schválený záznam `ZAZ-01 Zápis z přezkoumání vedením 2026` →
   podokno podrobností (ikona *i*) → **Apply label** → `GOC248 ISMS zaznam`. (Je-li v nabídce
   už `<ini>-ISMS záznam`, použij vlastní.)
2. Do zobrazení knihovny přidej sloupce **Retention label** a **Item is a Record**.
3. Otevři seznam **Incident log** — je prázdný, plní ho až den 4. Retenční politika položky
   seznamů nepokrývá; záznam se tu prohlašuje štítkem na **uzavřenou** položku incidentu.
   Zamčený záznam nejde upravit, proto se štítek na položku incidentu dává až po uzavření —
   ve čtvrtek. Dnes nic neaplikuj.

**Checkpoint:** `ZAZ-01` má štítek `GOC248 ISMS zaznam`, *Item is a Record* = Yes a v podrobnostech
**Record status = Locked**. Politika `POL-01` **nemá** retenční štítek (tu bude `test-<ini>`
ve stopě měnit).

### 8. Ověř, že záznam nejde smazat (negativní checkpoint)

Jako vlastník webu zkus záznam `ZAZ-01` smazat. Pak ho zkus otevřít a upravit v Word for the web.

**Checkpoint (negativní):** smazání skončí chybovou hláškou a dokument zůstane v knihovně;
úprava obsahu zamčeného záznamu není možná. Text hlášky si zapiš.

### 9. Připrav stopu pro zítřek (POVINNÉ — den 4 na tom stojí)

Den 4 ([`../../day-4/audit-incident-response/`](../../day-4/audit-incident-response/)) bude tyto
akce hledat v Purview Audit. **Checkpoint tohoto kroku jsou zapsané časy, ne audit** — audit má
zpoždění a ověří se zítra.

**Příprava.** Založ si poznámku `stopa-<ini>` (papír nebo textový soubor na svém počítači)
s tabulkou:

| # | Akce | Soubor | Čas (místní, hh:mm:ss) | Pozn. (typ odkazu, text hlášky) |
|---|---|---|---|---|
| 1 | otevření + stažení | `POL-01` | | |
| 2 | snížení štítku na Veřejné | `POL-01` | | zdůvodnění: |
| 3 | odkaz pro sdílení | `POL-01` | | typ odkazu: |
| 4 | pokus o smazání záznamu | `ZAZ-01` | | hláška: |

Čas zapisuj **místní** a připiš časové pásmo: v lednu je Praha **UTC+1** — Audit zobrazuje časy
v UTC nebo podle nastavení, ve čtvrtek je budeš přepočítávat.

**9.1 Přepni identitu.** V profilu prohlížeče pro Tenant A otevři **nové InPrivate okno**
a přihlas se jako `test-<ini>@cloudedu.cz`. Otevři web `isms-<ini>` → „Řízená dokumentace".

**Checkpoint:** vpravo nahoře je přihlášený `test-<ini>`, ne tvůj účet (krok přepíná identitu);
v knihovně vidíš `POL-01` se sensitivity labelem z `sensitivity-labels` (`<ini>-ISMS důvěrné`
nebo Důvěrné \ Vltava) a `ZAZ-01`.

**9.2 Otevři a stáhni označený dokument.** Otevři `POL-01` v Word for the web, prohlédni ji
a zavři. Pak ji v knihovně vyber → **Download**. Zapiš čas (řádek 1).

**Checkpoint:** soubor je stažený do počítače a v poznámce je čas řádku 1.

**9.3 Sniž štítek se zdůvodněním.** Otevři `POL-01` znovu v Word for the web → **Sensitivity**
→ **Veřejné**. V dialogu zdůvodnění zvol důvod nebo napiš „GOC248 stopa - snizeni stitku" →
potvrď. Zapiš čas a text zdůvodnění (řádek 2). Štítek **neodstraňuj** — snižuj: po odebrání by
výchozí štítek knihovny při další úpravě dokument znovu označil.

**Checkpoint:** Word for the web ukazuje štítek Veřejné; dialog zdůvodnění se objevil. Pokud se
neobjevil, zapiš to do poznámky — je to nález pro lektora (policy se nepropsala nebo zdůvodnění
už bylo zadáno v této relaci aplikace).

**9.4 Vytvoř odkaz pro sdílení.** V knihovně vyber `POL-01` → **Share** / **Copy link** →
nastavení odkazu **People in your organization** (lidé v organizaci) s oprávněním **Can view**
→ **Copy**. Zapiš čas a **typ odkazu** (řádek 3). Pokud volba pro celou organizaci není nabízena, zvol **Specific
people** a zadej svůj kurzovní účet — a zapiš, že jde o tento typ.

**Checkpoint:** odkaz je zkopírovaný a v poznámce je čas a typ odkazu.

**9.5 Zkus smazat záznam.** V knihovně vyber `ZAZ-01` → **Delete**. Zapiš čas a přesný text
chybové hlášky (řádek 4) a udělej snímek obrazovky.

**Checkpoint:** smazání selhalo, dokument je v knihovně, v poznámce je čas a text hlášky.

**9.6 Odhlas se** a zavři InPrivate okno.

**Co bude čtvrtek hledat.** Očekávané operace podle
[Learn: audit log activities](https://learn.microsoft.com/en-us/purview/audit-log-activities)
(neověřeno na tenantu; podrobně v [`reseni-retence-zaznamy.md`](reseni-retence-zaznamy.md),
část C). Do zítřka je **nehledej** — ingest auditu má zpoždění.

| # | Akce | Operace |
|---|---|---|
| 1 | otevření, stažení | `FileAccessed` (stejný uživatel + soubor se 5 min neopakuje), `FileDownloaded` |
| 2 | snížení štítku ve Word for the web | `FileSensitivityLabelChanged` |
| 3 | odkaz pro organizaci / pro konkrétní lidi | `CompanyLinkCreated` / `SecureLinkCreated` + `AddedToSecureLink` |
| 4 | zablokované smazání záznamu | **žádná dokumentovaná operace** — `RecordDelete` je jen pro provedené smazání; důkazem je snímek hlášky |

**Checkpoint (krok 9 jako celek):** poznámka `stopa-<ini>` má čtyři řádky s místními časy,
pásmem, typem odkazu, textem zdůvodnění a hlášky; poznámku máš u sebe na čtvrtek.

### 10. Zapiš do SoA

Do seznamu SoA ve workspace `isms-<ini>` přidej řádky:

| Opatření | Aplikovatelné | Zdůvodnění | Capability M365 | Důkaz | Modul | Tenant |
|---|---|---|---|---|---|---|
| A.5.33 | ano | vlastní text | retenční štítek označující záznam (`GOC248 ISMS zaznam`, vlastní `<ini>-ISMS záznam`), record versioning | odkaz na zamčený `ZAZ-01` + snímek hlášky z kroku 9.5 | `retention-lifecycle` | A |
| A.8.10 | ano | vlastní text | retenční politika `<ini>-ISMS retence web`, štítek s disposition review | snímek nastavení politiky a štítku | `retention-lifecycle` | A |

Sloupec **Požadavek** doplň z mapovací matice z pondělí. Vyplň i Stav zavedení, Prioritu,
Termín a Odpovědnou osobu (u zavedených opatření Termín necháš prázdný).

**Checkpoint:** v SoA jsou dva nové řádky s funkčním odkazem v Důkazu a Modul =
`retention-lifecycle`.

## Ověření

- [ ] Typ webu ověřený (komunikační) a lokace v krocích 5–6 odpovídá.
- [ ] Štítek `<ini>-ISMS záznam`: 5 let od označení, record (ne regulatory), disposition review.
- [ ] **Negativní:** label policy i retenční politika mají jedinou lokaci s jediným webem
      `isms-<ini>`; nikde *All*.
- [ ] `ZAZ-01` je zamčený záznam; `POL-01` retenční štítek nemá; Incident log beze změny.
- [ ] **Negativní:** smazání záznamu selhalo (vlastník i `test-<ini>`).
- [ ] Poznámka `stopa-<ini>`: 4 řádky s místním časem, pásmem, typem odkazu, zdůvodněním, hláškou.
- [ ] SoA: řádky A.5.33 a A.8.10.

## Fallback

- **Politika se nepropsala do konce labu** (retenční politika *On (Pending)*, vlastní štítek není
  v nabídce): očekávané — Learn uvádí až 7 dní. Do SoA dej snímek nastavení; ve čtvrtek ráno
  zkontroluj stav *On (Success)* a nabídku štítku a důkaz doplň.
- **Kurzovní štítek `GOC248 ISMS zaznam` na webu chybí:** kroky 7–8 a 9.5 ukáže lektor na
  lektorském webu; do poznámky si zapiš čas jeho pokusu o smazání a v řádku 4 uveď „lektor".
- **`test-<ini>` nevidí `POL-01` se štítkem** (vidí starou verzi bez štítku): nová verze je jen
  koncept — publikuj hlavní verzi, schval ji svým účtem a obnov okno `test-<ini>`.
- **Snížení štítku v 9.3 nejde uložit** nebo vytvoří koncept čekající na schválení: zapiš čas
  pokusu a co se stalo; auditní záznam o změně štítku se hledá i tak (neověřeno na tenantu).
- **`test-<ini>` se nepřihlásí** (MFA, heslo): kroky 9.2–9.5 udělej svým účtem a v poznámce
  uveď, který účet akci provedl — ve čtvrtek budeš hledat jiného uživatele.
- **Při časové tísni:** krok 3 jen ústně, krok 2 provede lektor za třídu podle seznamu webů;
  řádky SoA převezmi z [`reseni-retence-zaznamy.md`](reseni-retence-zaznamy.md). **Krok 9 se
  nekrátí.**

## Zdroje

- [Declare records by using retention labels](https://learn.microsoft.com/en-us/purview/declare-records)
- [Publish and apply retention labels](https://learn.microsoft.com/en-us/purview/create-apply-retention-labels)
- [Configure retention settings](https://learn.microsoft.com/en-us/purview/retention-settings)
- [Records management — compare restrictions](https://learn.microsoft.com/en-us/purview/records-management)
- [Use record versioning](https://learn.microsoft.com/en-us/purview/record-versioning)
- [Audit log activities](https://learn.microsoft.com/en-us/purview/audit-log-activities)
