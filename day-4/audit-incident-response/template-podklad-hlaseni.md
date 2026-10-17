# Šablona · Podklad pro prvotní hlášení kybernetického bezpečnostního incidentu

Šablona pro poskytovatele regulované služby v **režimu nižších povinností** (zákon č. 264/2025
Sb., vyhláška č. 410/2025 Sb.). Používá se v labu
[`lab-incident-evidence.md`](lab-incident-evidence.md) a student si ji odnáší.

Šablona má dvě části a **nesmí se slévat**:

- **Část A — interní podklad.** Co organizace potřebuje, aby rozhodla a doložila. Do Portálu
  NÚKIB se jako celek neposílá.
- **Část B — pole formuláře prvotního hlášení** na Portálu NÚKIB, převzatá z návodu NÚKIB.
  Co se tu vyplní, se při hlášení přepíše do formuláře.

> [!WARNING] Ověřit k datu běhu — stav k 2026-08 (část B), 2026-02 a 2026-06 (část A).
> Pole formuláře vycházejí z
> [Návodu k hlášení incidentů pro nižší režim](https://portal.nukib.gov.cz/informacni-servis/podpurne-materialy/6a1d9256fc2a7b93040173db)
> (NÚKIB, publikováno 14. 8. 2026), odtud i začátek 24h lhůty (od zjištění).
> Ostatní lhůty a podmínky z
> [Hlášení kybernetických bezpečnostních incidentů, v1.2](https://portal.nukib.gov.cz/storage/uploads/2026/06/08/podpurny-material-ke-hlaseni-incidentu_v1-2_uid_6a267e393778b.pdf),
> posouzení významnosti z
> [Stanovení významnosti incidentu v režimu nižších povinností, v1.0](https://portal.nukib.gov.cz/storage/uploads/2026/02/24/vyznamnost-incidentu-nizsi-rezim_uid_699dada722caf.pdf).
> Formulář na Portálu se může změnit dřív než tato šablona — před skutečným hlášením platí
> Portál.

---

## Část A — interní podklad

### A1. Identifikace

| Položka | Hodnota |
|---|---|
| Záznam v Incident logu (Název, odkaz) | |
| Zpracoval (jméno, role) | |
| Osoba oprávněná podat hlášení (statutární orgán / pověřený zástupce) | |
| Regulovaná služba, které se incident týká | |

Formulář na Portálu NÚKIB vyplňuje statutární orgán nebo pověřený zástupce; přihlášení přes
Identitu občana s úrovní záruky **značná nebo vysoká** (návod NÚKIB). Kdo to ve firmě je, musí
být známo **před** incidentem.

### A2. Časová osa a lhůty

Uvádět **místní čas i UTC** — audit Microsoft Purview pracuje v UTC.

| Okamžik | Místní čas | UTC | Zdroj |
|---|---|---|---|
| Výskyt (první známá akce) | | | export auditu |
| Zjištění (`DetectedAt`) | | | kdo a čím zjistil |
| Vyhodnocení jako incident (`ClassifiedAt`) | | | rozhodnutí v A3 |
| Lhůta prvotního hlášení (`ReportDeadline`) | | | `DetectedAt` + 24 h |
| Oznámení (jen významný incident) | | | do 72 h od zjištění |
| Závěrečná zpráva (jen významný incident) | | | do 30 dnů od vyřešení |

> [!WARNING] Začátek 24h lhůty
> Šablona počítá lhůtu **od zjištění** podle návodu NÚKIB pro nižší režim („od jeho
> **zjištění**"). Podpůrný materiál NÚKIB (v1.2) uvádí „od **vyhodnocení události jako
> incidentu**" — čtení od zjištění je konzervativnější. Vyhodnocení nesmí čekat — materiál
> výslovně říká, že má proběhnout co nejrychleji.

### A3. Událost, nebo incident?

| Otázka | Odpověď | Zdůvodnění |
|---|---|---|
| Došlo k **neplánovanému** narušení důvěrnosti, integrity nebo dostupnosti informací? | ano / ne | |
| Šlo o narušení v kybernetickém prostoru (elektronické zpracování informací)? | ano / ne | |
| Závěr | událost / incident | |

### A4. Hlásí se? (režim nižších povinností)

Všechny čtyři podmínky musí platit současně (materiály NÚKIB, § 15 zákona):

| Podmínka | Splněno | Zdůvodnění |
|---|---|---|
| 1. Projevil se ve stanoveném rozsahu řízení kybernetické bezpečnosti | ano / ne | |
| 2. Má původ v kybernetickém prostoru | ano / ne | |
| 3. Úmyslné zavinění **nelze vyloučit** (rozhodnout do 24 h) | ano / ne | |
| 4. Má **významný dopad** na poskytování regulované služby (A5) | ano / ne / posuzuje se | |
| **Závěr** | hlásí se / nehlásí se / dobrovolně | |

### A5. Významnost dopadu (§ 14 vyhlášky č. 410/2025 Sb.)

**Krok 1 — únosná míra újmy.** Hodnoty níže jsou **fiktivní pro Vltava Servis**; vlastní
organizace je musí mít ve své metodice předem.

| Oblast | Únosná míra újmy (fiktivní) | Tento incident | Překročeno |
|---|---|---|---|
| Finanční ztráta | do 500 000 Kč na incident | | ano / ne |
| Nedostupnost služby | do 4 h u kritických částí | | ano / ne |
| Počet dotčených osob | do 1 000 zákazníků | | ano / ne |
| Právní dopady | bez rizika pokuty / žaloby | | ano / ne |
| Reputace | bez negativní publicity ve významných médiích | | ano / ne |

**Krok 2 — oblasti posouzení** (stupeň 1 = nejnižší, 4 = nejvyšší; vodítka v materiálu NÚKIB):

| Oblast | Stupeň 1–4 | Zdůvodnění |
|---|---|---|
| Provozní dopad na schopnost poskytovat službu | | |
| Množství zasažených osob | | |
| Zdroje potřebné k obnově | | |
| Typ a umístění dotčených aktiv | | |
| Citlivost zasažených informací a dat | | |
| Přímá příčina (lidská chyba / technická závada / úmysl), je-li známa | | |

**Krok 3 — rozhodovací pravidlo** (zvolené v metodice organizace, např. „aspoň jedna oblast
na stupni 4, nebo aspoň tři na stupni 3"): ______________________

**Výsledek:** významný dopad **ano / ne** — dopad je významný, jen když je překročena únosná míra
újmy **a zároveň** práh u oblastí. Text do pole `SignificanceBasis` v Incident logu:
______________________

### A6. Důkazy

| Důkaz | Kde je uložen (odkaz ve workspace) | Poznámka |
|---|---|---|
| Uložené vyhledávání v Purview Audit (název úlohy, filtry, rozsah v UTC) | | úlohy se drží 30 dní |
| Export CSV z auditu | | obsahuje osobní údaje — přístup omezit |
| Další (sign-in log, historie PIM, DLP) | | |

---

## Část B — pole formuláře prvotního hlášení (Portál NÚKIB)

Podle návodu NÚKIB pro nižší režim, stav 2026-08. Neodesílat v rámci kurzu.

### B1. Před vyplněním

| Krok formuláře | Co vybrat / vyplnit |
|---|---|
| Typ incidentu | Ransomware / Malware / Phishing Malfile Dropper / Phishing Credential Harvester / DDoS / Útok na perimetr / **Jiný typ incidentu** |
| Organizace | organizace, za kterou hlásím (za více organizací = samostatná hlášení) |
| Služba | dotčená regulovaná služba (může být více) |
| Je to kybernetický bezpečnostní incident podle zákona? | **ANO** = incident; NE = událost (dobrovolné hlášení) |

### B2. Povinná pole

| Pole | Možnosti / obsah | Hodnota |
|---|---|---|
| Datum a čas výskytu incidentu | | |
| Datum a čas zjištění incidentu | | |
| Primární kontakt | e-mail osoby, se kterou bude CERT komunikovat po celou dobu řešení | |
| Popis incidentu | volný text: průběh, kontext, zjištění | |
| Fáze incidentu | identifikován / probíhá omezení šíření / probíhá eradikace / probíhá obnova / vyřešen | |
| Dopad incidentu | pouze na organizaci / na zákazníky a partnery / na celý sektor / národní / nadnárodní | |
| Poskytujete služby i během trvání incidentu | ano, všechny dostupné / ano, některé nedostupné / ano, většina nedostupná / ne, kompletní narušení | |
| Přijatá opatření | volný text | |
| Nahlásili jste incident na Policii ČR | ano / ne | |

### B3. Nepovinná pole

| Pole | Možnosti / obsah | Hodnota |
|---|---|---|
| Vyžadujete pomoc | nevyžadujeme / analytická asistence / metodická asistence / veškerou pomoc | |
| Technická specifika (podle typu) | u *Jiný typ incidentu*: jaký typ dat byl zasažen nebo kompromitován; případně vzorek a hash souboru | |

Návod u většiny typů incidentu uvádí v „obecných specifikách" také **zasažené systémy a hodnotu
jejich aktiv** — připravit z Asset Registeru (pole `AffectedAssets` v Incident logu).

### B4. Po odeslání

Potvrzení o přijetí obsahuje jméno osoby, datum a čas podání, dokument podání ke stažení, číslo
jednací osvědčení a osvědčení o digitálním úkonu (návod NÚKIB). **Uložit do pole `Evidence`**
a záznam v Incident logu přepnout na *Nahlášeno*.

Když formulář nejde odeslat: *Nahlásit chybu* a použít formulář **Náhradní hlášení
kybernetických incidentů** e-mailem nebo datovou schránkou (návod NÚKIB; § 16 odst. 4 zákona
podle podpůrného materiálu v1.2).
