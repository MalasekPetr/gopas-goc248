# Lab · Knihovna řízené dokumentace a první schválená politika

> Modul: `document-libraries-governance` · Odhad: 60 min · Režim: hands-on, vlastní scope
> Tenant: A `cloudedu.cz` · Scénář: [`../../scenario-isms-vltava.md`](../../scenario-isms-vltava.md)

## Cíl

Ve webu `isms-<ini>` je knihovna `Řízená dokumentace` (`/ControlledDocs`) s hlavními
a vedlejšími verzemi, schvalováním obsahu a vlastními oprávněními a v ní politika `POL-01`
ve schválené verzi 1.0, kterou napsal někdo jiný, než kdo ji schválil.

**Jak lab číst:** každý krok končí **Checkpointem** — nesedí-li, nepokračuj. Kroky 6–7 děláš
jako `test-<ini>`, ostatní jako ty (vlastník webu).

## Předpoklady

- Profil prohlížeče **Tenant A**, přihlášený tvůj účet `jmeno.prijmeni@cloudedu.cz`.
- Web `/sites/isms-<ini>` a seznam `SoA` z `isms-design-m365` (D1).
- Skupina `isms-<ini>-users` a uživatel `test-<ini>` (založil lektor), heslo `test-<ini>`
  a jeho MFA ve tvém Authenticatoru (nastavené v pondělí v `onboarding`).

## Kroky

### 1. Ověř tenant, profil a web

Otevři `https://<tenant>.sharepoint.com/sites/isms-<ini>` v profilu Tenant A.

**Checkpoint:** vpravo nahoře je tvůj účet `@cloudedu.cz`, adresa končí `/sites/isms-<ini>`
s **tvými** iniciálami a v obsahu webu je seznam `SoA`.

### 2. Vytvoř knihovnu s ASCII adresou

**New** -> **Document library** -> prázdná knihovna s názvem `ControlledDocs`. Pak v nastavení
knihovny (**Settings** -> **Library settings** -> **List name, description and navigation**)
změň zobrazovaný název na `Řízená dokumentace`.

Proč dvakrát: adresa knihovny vzniká z prvního názvu a s diakritikou by byla nečitelná
(`/%C5%98%C3%ADzen%C3%A1...`). Adresa jde do SoA jako důkaz a zítra do politik Purview.

**Checkpoint:** knihovna se v navigaci jmenuje `Řízená dokumentace` a její adresa končí
`/ControlledDocs/Forms/AllItems.aspx`.

### 3. Nastav verzování, schvalování a viditelnost konceptů

**Settings** -> **Library settings** (v novém panelu případně **More library settings**) ->
**Versioning settings**:

1. **Require content approval for submitted items** -> **Yes**.
2. Vytváření verzí -> **hlavní a vedlejší verze** (major and minor / draft versions).
3. Limit verzí **neměň** — ponech, co knihovna zdědila z nastavení organizace. Zapiš si, jaký
   režim to je (automatický / ruční a s jakými čísly).
4. **Set who can see draft items** -> nejužší varianta: jen autor a ti, kdo smějí schvalovat.
5. **Require documents to be checked out before they can be edited** -> **No**.

Ulož. Pak do poznámky (použiješ v kroku 10) napiš jednou větou, proč rezervaci nevyžaduješ.

**Checkpoint:** po znovuotevření Versioning settings jsou všechny čtyři volby nastavené podle
zadání a v zobrazení knihovny přibyl sloupec stavu schválení (*Approval Status*). Máš zapsaný
zděděný režim limitu verzí a větu o rezervaci.

### 4. Přeruš dědění oprávnění a nastav role

**Settings** -> **Library settings** -> **Permissions for this document library** ->
**Stop Inheriting Permissions**. Pak:

| Kdo | Úroveň |
|---|---|
| vlastníci webu `isms-<ini>` | Full Control (ponech) |
| členové webu, návštěvníci webu | **odebrat** z knihovny |
| `isms-<ini>-users` | **Read** |
| `test-<ini>` | **Contribute** |

Nikoho dalšího nepřidávej — ani souseda, ani skupinu jiného studenta.

**Checkpoint:** stránka oprávnění knihovny ukazuje hlášku, že knihovna má jedinečná oprávnění,
a právě tři položky: vlastníky webu (Full Control), `isms-<ini>-users` (Read) a `test-<ini>`
(Contribute).

### 5. Jako vlastník založ koncept, který nikdo nemá vidět

V knihovně **New** -> **Word document**. Napiš jednu větu a dokument pojmenuj
`POL-02 Politika řízení přístupu`. Nepublikuj ho.

**Checkpoint:** `POL-02` má v historii verzí jen vedlejší verzi (0.x) a stav schválení
*Draft*.

### 6. Přihlas se jako `test-<ini>` a ověř, co nevidí

V profilu Tenant A otevři **okno InPrivate** a přihlas se jako `test-<ini>@cloudedu.cz`.
Otevři `https://<tenant>.sharepoint.com/sites/isms-<ini>/ControlledDocs`.

**Checkpoint:** v okně InPrivate je přihlášený `test-<ini>` (ne ty, ne účet z Tenant B).

**Checkpoint (negativní):** `test-<ini>` v knihovně **nevidí** dokument `POL-02` — je to
cizí koncept. Pokud ho vidí, viditelnost konceptů v kroku 3 není nastavená nejúžeji.

### 7. Jako `test-<ini>` napiš politiku a odešli ji ke schválení

Stále jako `test-<ini>`: **New** -> **Word document**, název
`POL-01 Politika bezpečnosti informací`, obsah:

> Vltava Servis s.r.o. — Politika bezpečnosti informací
>
> Vlastník dokumentu: ředitel společnosti
>
> Datum účinnosti: 2026-02-01
>
> Datum příští revize: 2027-02-01
>
> Klasifikace: Interní
>
> Vedení stanovuje cíle bezpečnosti informací a zajišťuje zdroje pro ISMS. Politika platí pro
> všechny zaměstnance a dodavatele s přístupem k informacím společnosti.

Zavři dokument, v knihovně ho vyber a přes **...** -> **More** zvol publikaci hlavní verze
(**Publish** / **Submit for approval** — podle toho, co UI nabídne). Doplň komentář
`Prvni vydani`.

**Checkpoint:** `POL-01` má stav schválení *Pending* (čeká na schválení).

**Checkpoint (negativní):** `test-<ini>` v nabídce **...** -> **More** u `POL-01` **nemá**
akci **Approve/Reject** — autor si dokument sám neschválí. Okno InPrivate zavři.

### 8. Jako vlastník politiku schval

Zpět ve svém okně profilu Tenant A: vyber `POL-01` -> **...** -> **More** -> **Approve/Reject**
-> **Approved**, komentář `Schvaleno vedenim` (v kurzu zastupuješ vedení).

**Checkpoint:** `POL-01` má stav *Approved* a v historii verzí je hlavní verze **1.0**
s předchozí vedlejší verzí 0.x. U verze 1.0 je vidět komentář.

### 9. Ověř, že změna znovu otevírá řízení změn

Otevři `POL-01`, připiš větu `Politiku prezkoumava vedeni jednou rocne.` a zavři.

**Checkpoint:** v historii verzí přibyla vedlejší verze **1.1** a stav schválení je znovu
*Draft*; verze 1.0 zůstala. Čtenáři z `isms-<ini>-users` dál dostávají 1.0, dokud 1.1
neprojde schválením (podle README — ověření čtenářským účtem v kurzu neděláme).

### 10. Zapiš do SoA

Do seznamu `SoA` ve webu `isms-<ini>` přidej tři řádky (sloupec **Požadavek** doplň podle
mapovací matice z D1, nevymýšlej paragraf):

| Opatření | Aplikovatelné | Zdůvodnění | Capability M365 | Důkaz | Modul | Tenant |
|---|---|---|---|---|---|---|
| kap. 7.5 | ano | vlastní věta: proč vedlejší verze + schválení + rezervace ne | knihovna `ControlledDocs`: hlavní a vedlejší verze, schvalování obsahu, koncepty vidí jen autor a schvalovatel | odkaz na Versioning settings knihovny | `document-libraries-governance` | A |
| A.5.1 | ano | vlastní věta | politika vydaná schválením vlastníka, autor jiný než schvalovatel | odkaz na `POL-01` (verze 1.0) | `document-libraries-governance` | A |
| A.5.37 | ano | vlastní věta | postupy dostupné čtenářům (`isms-<ini>-users` Read), upravuje jen autor (Contribute) | odkaz na oprávnění knihovny | `document-libraries-governance` | A |

Vyplň i Stav zavedení, Prioritu, Termín a Odpovědnou osobu (u zavedených opatření Termín
necháš prázdný).

**Checkpoint:** v `SoA` jsou tři nové řádky s vyplněným sloupcem **Důkaz** (funkční odkaz
do `ControlledDocs`), **Modul** = `document-libraries-governance` a **Tenant** = A.

## Ověření

- [ ] Knihovna `Řízená dokumentace` má adresu `/ControlledDocs`.
- [ ] Versioning settings: schvalování ano, hlavní a vedlejší verze, nejužší viditelnost
      konceptů, rezervace ne; zděděný limit verzí zapsaný.
- [ ] Oprávnění knihovny: přesně tři položky, dědění přerušené.
- [ ] **Negativní:** `test-<ini>` nevidí koncept `POL-02`.
- [ ] **Negativní:** `test-<ini>` nemá u `POL-01` akci Approve/Reject.
- [ ] `POL-01` má verzi 1.0 se stavem Approved a po úpravě vedlejší verzi 1.1.
- [ ] **Negativní:** na webu `isms-*` jiného studenta se nic nezměnilo — do cizích knihoven
      jsi nikoho nepřidal a cizí `SoA` jsi neupravoval.
- [ ] V `SoA` jsou řádky 7.5, A.5.1 a A.5.37 s odkazem na důkaz.

## Fallback

- **`test-<ini>` se nepřihlásí** (heslo, MFA, licence): kroky 6–7 udělej sám a v kroku 6
  zapiš negativní checkpoint jako **neověřený**; schválení vlastního dokumentu v kroku 8
  zapiš do Zdůvodnění v SoA jako známou slabinu (autor = schvalovatel). Lektor předvede kroky
  6–7 na projektoru.
- **UI nenabízí volbu viditelnosti konceptů nebo vedlejší verze** (změna Versioning settings
  kvůli limitům verzí): nastav, co UI nabízí, a odchylku zapiš do Zdůvodnění řádku 7.5.
  Lektor ji zapíše do instructor notes.
- **Publikace v kroku 7 nevytvoří stav Pending:** zkontroluj, že je v kroku 3 skutečně
  uložené schvalování; dokument publikuj znovu.
- **Při časové tísni:** krok 9 vynech; kroky 5–6 (negativní test konceptu) udělej jako
  společné demo lektora. Řádky SoA převezmi z
  [`reseni-rizena-dokumentace.md`](reseni-rizena-dokumentace.md) a doplň vlastní Zdůvodnění.

## Zdroje

- [Version history limits for document library and OneDrive overview](https://learn.microsoft.com/en-us/sharepoint/document-library-version-history-limits)
- [Plan document versioning, content approval, and check-out controls (SharePoint Server)](https://learn.microsoft.com/en-us/sharepoint/governance/versioning-content-approval-and-check-out-planning)
