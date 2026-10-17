# Lab · Asset Register, Risk Register a Incident log s revizí

> Modul: `lists-registers-workflow` · Odhad: 65 min · Režim: hands-on, vlastní scope
> Tenant: A `cloudedu.cz` · Scénář: [`../../scenario-isms-vltava.md`](../../scenario-isms-vltava.md)

## Cíl

Ve webu `isms-<ini>` jsou tři seznamy přesně podle schémat níže, s daty Vltava Servis,
zobrazením „K revizi" a jedním rizikem, jehož přijetí schválil vlastník rizika přes Approvals.

**Jak lab číst:** každý krok končí **Checkpointem** — nesedí-li, nepokračuj. Schémata jsou
závazná: Incident log plní den 4, Risk Register čte capstone a podle tabulek vznikají skripty.

## Předpoklady

- Profil prohlížeče **Tenant A**, web `isms-<ini>` se seznamem `SoA`.
- Hotový [`../document-libraries-governance/`](../document-libraries-governance/) (kvůli aktivu
  „ISMS dokumentace").

## Pravidlo pro každý sloupec

1. Založ sloupec s **Internal name** z tabulky (ASCII, bez mezer).
2. Až budou v seznamu **všechny** sloupce včetně počítaných, přejmenuj je na **Display name**.
3. Sloupec `Title` nezakládej — existuje; jen ho přejmenuj.

Ověření interního názvu: v nastavení seznamu klikni na sloupec; adresa stránky končí
`&Field=<InternalName>`.

Počítaný a vyhledávací sloupec nenajdeš v základní nabídce **+ Add column**: použij
**See all column types**, nebo v nastavení seznamu **Create column**.

## Kroky

### 1. Ověř tenant, profil a web

**Checkpoint:** v profilu Tenant A je přihlášený tvůj účet `@cloudedu.cz` a jsi na
`/sites/isms-<ini>` s **tvými** iniciálami.

### 2. Založ Asset Register

**New** -> **List** -> **Blank list**, název `AssetRegister`, pak zobrazovaný název přejmenuj
na `Asset Register`. Sloupce:

| Display name | Internal name | Type |
|---|---|---|
| Název | Title | text |
| Typ aktiva | AssetType | choice: Informace / Aplikace / Služba / Infrastruktura / Zařízení / Dodavatel / Lidé |
| Popis | AssetDescription | multiline text |
| Vlastník aktiva | AssetOwner | person |
| Umístění | AssetLocation | text |
| Klasifikace | AssetClassification | choice: Veřejné / Interní / Důvěrné / Přísně důvěrné |
| Kritičnost | Criticality | choice: Nízká / Střední / Vysoká |
| Datum příští revize | NextReview | date |
| Stav | AssetStatus | choice: V provozu / Plánované / Vyřazené |

**Checkpoint:** adresa seznamu končí `/Lists/AssetRegister`; u sloupce Kritičnost končí adresa
nastavení sloupce `&Field=Criticality` a zobrazovaný název je česky.

### 3. Zapiš aktiva

Vlastník aktiva je u všech **ty**; Datum příští revize 2027-06-30, Stav `V provozu`.

| Název | Typ aktiva | Umístění | Klasifikace | Kritičnost |
|---|---|---|---|---|
| ISMS dokumentace | Informace | SharePoint `isms-<ini>` / `ControlledDocs` | Interní | Vysoká |
| Tenant Microsoft 365 | Služba | Microsoft 365 | Interní | Vysoká |
| Databáze servisních zakázek | Aplikace | provozovaná dodavatelem | Důvěrné | Vysoká |
| Notebooky servisních techniků | Zařízení | terén, 40 ks | Interní | Střední |
| Dodavatel IT podpory | Dodavatel | externí | Interní | Střední |

**Checkpoint:** Asset Register má 5 položek s vyplněným vlastníkem a klasifikací.

### 4. Založ Risk Register

Seznam `RiskRegister`, zobrazovaný název `Risk Register`:

| Display name | Internal name | Type |
|---|---|---|
| Název rizika | Title | text |
| Aktivum | RiskAsset | lookup to Asset Register Title |
| Hrozba | Threat | text |
| Zranitelnost | Vulnerability | text |
| Pravděpodobnost | Likelihood | number 1-5 |
| Dopad | Impact | number 1-5 |
| Míra rizika | RiskScore | calculated number = [Likelihood]*[Impact] |
| Vlastník rizika | RiskOwner | person |
| Způsob zvládání | Treatment | choice: Snížit / Přijmout / Vyhnout se / Sdílet |
| Plán zvládání | TreatmentPlan | multiline text |
| Vazba na opatření | ControlRef | text |
| Datum příští revize | NextReview | date |
| Stav | RiskStatus | choice: Identifikováno / V řešení / Přijato / Uzavřeno |

U `Likelihood` a `Impact` nastav minimum 1, maximum 5, 0 desetinných míst. `RiskScore` založ
**před** přejmenováním, se vzorcem `=[Likelihood]*[Impact]`, výsledek Number, 0 desetinných
míst.

**Checkpoint:** adresa seznamu končí `/Lists/RiskRegister`; po přejmenování ukazuje vzorec
sloupce Míra rizika české názvy (`=[Pravděpodobnost]*[Dopad]`) a interní název zůstal
`RiskScore`.

### 5. Zapiš rizika

Vlastník rizika je **ty**.

| Název rizika | Aktivum | Hrozba | Zranitelnost | P | D | Způsob | Vazba na opatření | Datum příští revize | Stav |
|---|---|---|---|---|---|---|---|---|---|
| Neoprávněný přístup k zakázkám | Databáze servisních zakázek | převzetí účtu phishingem | servisní účty bez MFA | 4 | 5 | Snížit | A.5.15, A.8.5 | 2027-03-31 | V řešení |
| Ztráta notebooku technika | Notebooky servisních techniků | krádež v terénu | disk bez šifrování | 3 | 3 | Snížit | A.8.1 | **včerejší datum** | Identifikováno |
| Vydání neschválené verze politiky | ISMS dokumentace | chyba autora | — | 2 | 3 | Přijmout | 7.5 | 2027-12-31 | Identifikováno |

Plán zvládání vyplň vlastní větou (u prvního rizika: „MFA přes Conditional Access, D4").

**Checkpoint:** Míra rizika je 20, 9 a 6. Pokud je prázdná nebo jiná, vzorec v kroku 4 odkazuje
na špatné sloupce.

### 6. Založ Incident log — schéma je pevné

Seznam `IncidentLog`, zobrazovaný název `Incident log`. Schéma **neměň** — den 4 na něj
navazuje:

| Display name | Internal name | Type |
|---|---|---|
| Název | Title | text |
| Zjištěno | DetectedAt | date+time |
| Vyhodnoceno jako incident | ClassifiedAt | date+time |
| Lhůta prvotního hlášení | ReportDeadline | calculated date+time = [DetectedAt]+1 |
| Významný dopad | Significant | choice: ano / ne / posuzuje se |
| Kritérium významnosti | SignificanceBasis | multiline text |
| Dotčená aktiva | AffectedAssets | lookup (multi) to Asset Register Title |
| Stav | Status | choice: Nový / V řešení / Nahlášeno / Uzavřeno |
| Podklad pro hlášení | ReportDraft | hyperlink |
| Důkazy | Evidence | multiline text |

`ReportDeadline`: počítaný sloupec, vzorec `=[DetectedAt]+1`, výsledek **Date and Time**
s formátem datum a čas. `AffectedAssets`: vyhledávací sloupec do Asset Register, sloupec
Název, **povolit více hodnot**.

**Checkpoint:** adresa seznamu končí `/Lists/IncidentLog`; v nastavení seznamu je deset
sloupců a u každého souhlasí interní název s tabulkou (`&Field=...`).

### 7. Ověř lhůtu cvičným záznamem

Přidej záznam: Název `CVICENI - ztraceny notebook`, Zjištěno dnes 08:00, Vyhodnoceno jako
incident dnes 10:30, Významný dopad `posuzuje se`, Dotčená aktiva `Notebooky servisních
techniků`, Stav `Uzavřeno`, do Důkazů „cvičný záznam D2, není incident".

**Checkpoint:** Lhůta prvotního hlášení je **zítra 08:00** (o 24 h později než Zjištěno —
ne než Vyhodnoceno).
Pokud je čas posunutý, zapiš rozdíl a ohlas lektorovi — je to známé riziko počítaných sloupců
s časovou zónou (viz instructor notes).

### 8. Zobrazení „K revizi"

V Risk Registeru vytvoř zobrazení `K revizi` v **klasickém editoru zobrazení** (nabídka
zobrazení -> **Create new view** / **Edit current view** -> stránka nastavení zobrazení;
moderní filtrovací panel `[Today]` neumí): filtr **Datum příští revize** je menší nebo
rovno `[Today]` **a** **Stav** se nerovná `Uzavřeno`; řazení podle Míry rizika sestupně.

**Checkpoint:** zobrazení `K revizi` ukazuje právě jedno riziko — „Ztráta notebooku technika".

### 9. Schválení přijetí rizika přes Approvals

V Risk Registeru zapni Approvals: na příkazovém řádku **Integrate** (případně **Automate**) ->
**Configure approvals** -> **Enable Approvals** -> **Apply**. Pak u rizika „Vydání neschválené
verze politiky" (Způsob zvládání `Přijmout`) **Request approval**, schvalovatel = ty jako
vlastník rizika, do podrobností „Prijeti zbytkoveho rizika". Žádost schval
(**Approval details** -> **Approve**) a teprve potom změň Stav na `Přijato`.

**Checkpoint:** u rizika je *Approval status* schválený a v **Approval details** je vidět, kdo
a kdy schválil. Stav rizika je `Přijato`.

**Checkpoint (negativní):** pokud změníš Stav **dřív**, než žádost vyřídíš, aplikace upozorní,
že úprava žádost zruší — v tom případě žádost podej znovu. Approvals jsou zapnuté **jen** na
tvém Risk Registeru; Asset Register a Incident log je nemají.

### 10. Zapiš do SoA

| Opatření | Aplikovatelné | Zdůvodnění | Capability M365 | Důkaz | Modul | Tenant |
|---|---|---|---|---|---|---|
| A.5.9 | ano | vlastní věta | Asset Register: aktiva s vlastníkem, klasifikací, kritičností a datem revize | odkaz na `AssetRegister` | `lists-registers-workflow` | A |
| kap. 6.1 | ano | vlastní věta, včetně hranice přijatelnosti rizika | Risk Register: aktivum × hrozba, P × D, vlastník, způsob a plán zvládání; přijetí schválené vlastníkem (Approvals) | odkaz na `RiskRegister` | `lists-registers-workflow` | A |
| kap. 8.2 | ano | vlastní věta: jak často a kdo reviduje | zobrazení `K revizi` podle data příští revize | odkaz na zobrazení `K revizi` | `lists-registers-workflow` | A |
| A.5.24 | ano | vlastní věta | Incident log s lhůtou prvotního hlášení 24 h od zjištění; naplní D4 | odkaz na `IncidentLog` | `lists-registers-workflow` | A |

Vyplň i Stav zavedení, Prioritu, Termín a Odpovědnou osobu (u zavedených opatření Termín
necháš prázdný).

**Checkpoint:** v `SoA` jsou čtyři nové řádky s Modul = `lists-registers-workflow`, Tenant = A
a funkčním odkazem v Důkazu.

## Ověření

- [ ] Tři seznamy s adresami `AssetRegister`, `RiskRegister`, `IncidentLog`.
- [ ] Interní názvy sloupců odpovídají tabulkám (kontrola `&Field=` aspoň u tří sloupců
      v každém seznamu, u Incident logu u všech).
- [ ] 5 aktiv, 3 rizika s mírou 20 / 9 / 6, cvičný incident s lhůtou +24 h.
- [ ] Zobrazení `K revizi` ukazuje jedno riziko.
- [ ] Přijetí rizika schválené přes Approvals; stav `Přijato` až po schválení.
- [ ] **Negativní:** Approvals jsou jen na tvém Risk Registeru; na webu jiného studenta jsi
      nic nezaložil ani neupravil.
- [ ] V `SoA` jsou řádky A.5.9, 6.1, 8.2, A.5.24.

## Fallback

- **Approvals se nedají zapnout** (menu chybí, chyba aplikace Approvals): krok 9 nahraď
  ručním záznamem — do Plánu zvládání připiš „Prijeti schvalil <jméno>, <datum>" a do
  Zdůvodnění řádku 6.1 napiš, že schválení není doložené workflow. Lektor ukáže Approvals
  na projektoru, nebo volitelný flow z [`guide-revizni-flow.md`](guide-revizni-flow.md).
- **Lookup nenabízí Asset Register:** seznam se jmenuje jinak nebo je v jiném webu; lookup
  funguje jen v rámci webu.
- **Překlep v interním názvu Incident logu:** sloupec smaž a založ znovu — dokud v něm nejsou
  data, je to levné. Přejmenování interní název neopraví.
- **Při časové tísni:** Incident log a Risk Register jsou **nekrátitelné**. Zkrátit lze
  zadávání dat (aktiva 3 místo 5) a krok 9 jako demo. Kdo nestihne seznamy, dostane je od
  lektora skriptem podle [`reseni-registry-revize.md`](reseni-registry-revize.md) a doplní
  jen data a SoA.

## Zdroje

- [Types of Power Automate licenses](https://learn.microsoft.com/en-us/power-platform/admin/power-automate-licensing/types)
- [SharePoint service description](https://learn.microsoft.com/en-us/office365/servicedescriptions/sharepoint-online-service-description/sharepoint-online-service-description)
