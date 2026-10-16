# NIS2 a ISO 27001 — rekapitulace pro Microsoft 365

> Typ: povinný · Den: 1 · Odhad: 60 min
> Tenant: — (bez tenantu) · Režim: výklad + papírové cvičení
> Prostředí: [`../../environment.md`](../../environment.md) · Názvosloví: [`../../GLOSSARY.md`](../../GLOSSARY.md)

Rekapitulace, ne výklad práva: kurz **GOC240** je předpoklad. Blok vybírá z zákona č. 264/2025 Sb.
a vyhlášky č. 410/2025 Sb. jen to, co se během týdne promítne do konfigurace Microsoft 365
a do sloupce **Požadavek** v SoA. Zařazení organizace do režimu je výchozí stav scénáře —
Vltava Servis je v **režimu nižších povinností**.

## Cíle

- Vyjmenovat 13 oblastí bezpečnostních opatření podle zákona a rozlišit **neopominutelná**
  a **vyhodnotitelná** opatření režimu nižších povinností.
- Popsat, co musí obsahovat **přehled bezpečnostních opatření** a čím se liší od SoA podle
  ISO/IEC 27001.
- Říct, kdy běží 24hodinová lhůta prvotního hlášení a kdo v režimu nižších povinností hlásí.
- Popsat ISMS jako systém řízení (kap. 4–10) + katalog opatření (Annex A) + SoA.
- Odlišit soulad se zákonem od certifikace ISO a certifikaci Microsoftu od vlastního ISMS.

## Výklad

### Co zákon a vyhláška chtějí — tabulka povinností

| Povinnost | Co přesně | Zdroj | Kde v kurzu |
|---|---|---|---|
| Zavést bezpečnostní opatření | 13 oblastí (níže); v režimu nižších povinností nejpozději **do 1 roku** od doručení rozhodnutí o registraci | [NÚKIB Manuál v1.1](https://portal.nukib.gov.cz/storage/uploads/2026/06/02/manual-nizsi-rezim-v1-1_uid_6a1eaedd0ce9f.pdf), kap. 2 | celý týden |
| Vést přehled bezpečnostních opatření | zavedená (s popisem), plánovaná (termín, priorita, odpovědná osoba), nezavedená (s odůvodněním); aktualizace alespoň 1× ročně; verze předložené vedení uchovat **alespoň 4 roky** | vyhl. č. 410/2025 Sb. § 3 odst. 2 a příloha č. 1 — podle [důvodové zprávy NÚKIB](https://portal.nukib.gov.cz/storage/uploads/2025/12/03/duvodova-zprava-vyhlaska-nizsi-rezim_uid_693039f42250d.pdf) | SoA od `isms-design-m365`, verzování D2, retence D3 |
| Bezpečnostní politika a dokumentace | obsahově pokrýt oblasti vyhlášky, dodržovat a vynucovat, pravidelně aktualizovat; názvy a počet dokumentů nejsou podstatné | § 3 odst. 3 (tamtéž) | `document-libraries-governance` |
| Hlásit incidenty | prvotní hlášení **do 24 h**; v režimu nižších povinností jen incidenty s **významným dopadem** (posouzení podle § 14 vyhlášky) | [NÚKIB, hlášení v1.2](https://portal.nukib.gov.cz/storage/uploads/2026/06/08/podpurny-material-ke-hlaseni-incidentu_v1-2_uid_6a267e393778b.pdf) | `audit-incident-response` |
| Zapojit vrcholné vedení | určit osobu pověřenou kybernetickou bezpečností, školení vedení, zdroje, pravidelné seznamování se stavem | § 4 — [NÚKIB Manuál v1.1](https://portal.nukib.gov.cz/storage/uploads/2026/06/02/manual-nizsi-rezim-v1-1_uid_6a1eaedd0ce9f.pdf), kap. 3.2 | capstone (report pro vedení) |

> [!IMPORTANT] Dva režimy, dvě vyhlášky
> **Režim vyšších povinností** — vyhláška č. **409/2025 Sb.**; **režim nižších povinností** —
> vyhláška č. **410/2025 Sb.** (číslo 409/2025 Sb. uvádí
> [NÚKIB Manuál v1.1](https://portal.nukib.gov.cz/storage/uploads/2026/06/02/manual-nizsi-rezim-v1-1_uid_6a1eaedd0ce9f.pdf),
> kap. 3.2). Kurz pracuje jen s 410/2025 Sb.

### 13 oblastí a jak s nimi pracuje režim nižších povinností

Zákon v § 14 odst. 2 vyjmenovává oblasti opatření; vyhláška č. 410/2025 Sb. je rozpracovává
od § 3. Struktura podle důvodové zprávy NÚKIB:

| Oblast (§ 14 odst. 2 zákona) | Vyhláška č. 410/2025 Sb. | Typ v nižším režimu |
|---|---|---|
| a) systém zajišťování minimální kybernetické bezpečnosti | § 3 | **neopominutelné** (§ 3 odst. 2 až 6) |
| b) požadavky na vrcholné vedení | § 4 | **neopominutelné** |
| c) řízení aktiv | zákon; pravidla pro technická aktiva v § 3 odst. 4 | v rámci § 3 |
| d) řízení rizik | **vyhláškou neupraveno** | — |
| e) bezpečnost lidských zdrojů | § 5 | **neopominutelné** |
| f) řízení kontinuity činností | § 6 | **neopominutelné** |
| g) řízení přístupu | § 7 | vyhodnotitelné |
| h) řízení identit a jejich oprávnění | § 8 | vyhodnotitelné |
| i) detekce a zaznamenávání kybernetických bezpečnostních událostí | § 9 | vyhodnotitelné |
| j) řešení kybernetických bezpečnostních incidentů | § 10 | **neopominutelné** |
| k) bezpečnost komunikačních sítí | § 11 | vyhodnotitelné |
| l) aplikační bezpečnost | § 12 | vyhodnotitelné |
| m) kryptografické algoritmy | § 13 | vyhodnotitelné |

Dále § 14 vyhlášky — stanovení významnosti dopadu incidentu; příloha č. 1 — přehled
bezpečnostních opatření; příloha č. 2 — požadavky na smluvní ujednání s dodavateli.

- **Neopominutelná** opatření je nutné zavést vždy; míru zavedení lze přizpůsobit kontextu
  organizace.
- **Vyhodnotitelná** opatření jsou také povinná, ale organizace smí vyhodnotit, že pro ni nejsou
  relevantní — a pak **musí nezavedení odůvodnit v přehledu bezpečnostních opatření**.
- Řízení rizik vyhláška pro nižší režim neupravuje; jeho výstupem — výběrem přiměřených
  opatření — je v nižším režimu právě přehled bezpečnostních opatření
  ([Manuál v1.1](https://portal.nukib.gov.cz/storage/uploads/2026/06/02/manual-nizsi-rezim-v1-1_uid_6a1eaedd0ce9f.pdf), kap. 2).

> [!WARNING] Ověřit k datu běhu — stav k 2026-10.
> Struktura vyhlášky výše je převzatá z **důvodové zprávy** (doplněná a revidovaná verze,
> která podle NÚKIB „není zcela totožná" s verzí z legislativního procesu) a z Manuálu v1.1.
> Znění na [e-Sbírce](https://e-sbirka.gov.cz/sb/2025/410) se při přípravě nepodařilo strojově
> načíst. Před během ověřit čísla § proti aktuálnímu znění na e-Sbírce.

### Přehled bezpečnostních opatření vs. SoA

Tohle je pro kurz nejdůležitější rozdíl dne.

| | Přehled bezpečnostních opatření (vyhl. 410/2025 Sb.) | SoA (ISO/IEC 27001, kap. 6.1.3) |
|---|---|---|
| Povaha | právní povinnost režimu nižších povinností | požadavek dobrovolné normy |
| Řádky | opatření **podle vyhlášky** (odkazem na §) | opatření **Annex A** (A.5–A.8) |
| Stav | zavedeno / v procesu / nezavedeno | aplikovatelné ano / ne + zdůvodnění |
| Plán | termín, priorita, odpovědná osoba u opatření v procesu | v plánu zvládání rizik, ne v SoA |
| Uchování | verze předložené vedení alespoň 4 roky | dokumentovaná informace (kap. 7.5) |

Podle důvodové zprávy NÚKIB je přehled pro nižší režim inspirovaný dokumenty režimu vyšších
povinností (plán zvládání rizik a prohlášení o aplikovatelnosti), ale přiměřeně zredukovaný.
Kurzovní **seznam SoA** proto nese oba pohledy v jednom řádku: sloupec **Opatření** (Annex A)
a sloupec **Požadavek** (§ vyhlášky). Co v něm proti příloze č. 1 chybí (stav „v procesu",
termín, priorita, odpovědná osoba), se ukáže v [`../isms-design-m365/`](../isms-design-m365/)
a v capstonu.

### ISMS v kostce

- **Kap. 4–10 ISO/IEC 27001** — systém řízení: kontext, vedení, plánování (rizika, SoA), podpora
  (mj. dokumentované informace, kap. 7.5), provoz, hodnocení výkonnosti, zlepšování.
- **Annex A** — katalog opatření ve čtyřech tématech: A.5 organizační, A.6 lidská, A.7 fyzická,
  A.8 technologická.
- **SoA** — které opatření Annex A se aplikují a proč (kap. 6.1.3).
- Kurz pracuje hlavně s opatřeními **A.5 a A.8** a s dokumentací a evidencemi systému řízení
  (kap. 7.5) — tam má konfigurace tenantu co doložit. Lidská (A.6) a fyzická (A.7) opatření
  zůstávají převážně mimo kurz.

Text normy se v kurzu necituje — jen čísla opatření a vlastní parafráze
([`../../CONVENTIONS.md`](../../CONVENTIONS.md)).

### Incident: kdy běží 24 hodin

Podle [podpůrného materiálu NÚKIB v1.2 (2026-06-08)](https://portal.nukib.gov.cz/storage/uploads/2026/06/08/podpurny-material-ke-hlaseni-incidentu_v1-2_uid_6a267e393778b.pdf):

- Hlásí se incident, který se projevil ve stanoveném rozsahu, má původ v kybernetickém prostoru
  a u kterého nelze bez zbytečného odkladu, nejpozději do 24 hodin, vyloučit úmyslné zavinění.
- **Nižší režim hlásí jen incidenty s významným dopadem**; významnost posuzuje sám podle § 14
  vyhlášky č. 410/2025 Sb. Vyšší režim hlásí všechny incidenty splňující znaky.
- **Prvotní hlášení bez zbytečného odkladu, nejpozději do 24 h** — v praxi od okamžiku, kdy
  pověřená osoba vyhodnotí zjištěnou událost jako incident.
- Hlásí se přes **Portál NÚKIB**; když to není možné, e-mailem nebo datovou schránkou (§ 16
  odst. 4 zákona). Podle důvodové zprávy hlásí nižší režim **Národnímu CERT**.
- Po vyřešení incidentu s významným dopadem následuje **závěrečná zpráva nejpozději do 30 dnů**.
- Neohlášení nebo opožděné ohlášení je **přestupek** (materiál odkazuje na § 59 zákona).

Proto kurz staví v D4 podklad pro hlášení z toho, co tenant už má: Incident log, audit,
časová osa ([`../../day-4/audit-incident-response/`](../../day-4/audit-incident-response/)).

> [!WARNING] Ověřit k datu běhu — stav k 2026-10.
> Výše pokut za přestupky podle § 59 zákona a lhůty mezi prvotním hlášením a závěrečnou zprávou
> pro nižší režim nejsou v materiálu v1.2 uvedené — **otevřená otázka**, ověřit v e-Sbírce.
> Podpůrné materiály NÚKIB se verzují (v1.2 je z 2026-06-08).

## Klíčové rozlišení

- **Zákon vs. norma** — zákon č. 264/2025 Sb. je právní povinnost pod dozorem NÚKIB; ISO/IEC
  27001 je dobrovolná norma. „Soulad se zákonem" ≠ „certifikace ISO 27001" (GLOSSARY).
- **Přehled bezpečnostních opatření vs. SoA** — viz tabulka výše; kurz je spojuje v jednom
  seznamu, ale nejsou totéž.
- **Neopominutelné vs. vyhodnotitelné** — obojí je povinné; vyhodnotitelné smíš odůvodněně
  nezavést.
- **Certifikace Microsoftu vs. tvůj ISMS** — Microsoft 365 je certifikovaný podle ISO/IEC 27001
  a certifikaci lze použít ve vlastním hodnocení, ale **kontroly a procesy uvnitř vlastní
  organizace musí posoudit vlastní auditor**
  ([Learn: ISO/IEC 27001 offering](https://learn.microsoft.com/en-us/compliance/regulatory/offering-iso-27001)).
- **Událost vs. incident** — hlášení události je dobrovolné, hlášení incidentu (se znaky výše)
  povinné.

## Licence

Blok je bez tenantu a bez funkcí Microsoft 365 — licenční otázky začínají v
[`../requirements-mapping-m365/`](../requirements-mapping-m365/). Jediná licenční poznámka:
šablony assessmentu **ISO/IEC 27001:2022** a **NIS2 Directive** jsou v Compliance Manageru
prémiové; zahrnutý pro všechny je jen Microsoft Data Protection Baseline
([Learn: Compliance Manager regulations list](https://learn.microsoft.com/en-us/purview/compliance-manager-regulations-list)).
Podrobně v [`../requirements-mapping-m365/comparison-licence.md`](../requirements-mapping-m365/comparison-licence.md).

## Naše prostředí

Bez tenantu. Scénář: Vltava Servis s.r.o., 240 zaměstnanců, poskytovatel regulované služby
v režimu nižších povinností ([`../../scenario-isms-vltava.md`](../../scenario-isms-vltava.md)).

## Lab

Viz [`lab-pravo-vs-norma.md`](lab-pravo-vs-norma.md) — 15minutové papírové cvičení bez tenantu.

## Nosná linka

Ve workspace nic nepřibylo a do SoA se nezapisuje. Blok dodává **slovník sloupce Požadavek**
(§ vyhlášky) a vysvětluje, proč má seznam SoA v kurzu dva identifikátory v jednom řádku.
Navazuje [`../requirements-mapping-m365/`](../requirements-mapping-m365/).

## Zdroje

- [Vyhláška č. 410/2025 Sb. — e-Sbírka](https://e-sbirka.gov.cz/sb/2025/410) (závazné znění)
- [Důvodová zpráva k vyhlášce č. 410/2025 Sb. — NÚKIB](https://portal.nukib.gov.cz/storage/uploads/2025/12/03/duvodova-zprava-vyhlaska-nizsi-rezim_uid_693039f42250d.pdf)
- [Manuál pro poskytovatele regulovaných služeb v režimu nižších povinností, v1.1 — NÚKIB](https://portal.nukib.gov.cz/storage/uploads/2026/06/02/manual-nizsi-rezim-v1-1_uid_6a1eaedd0ce9f.pdf)
- [Hlášení kybernetických bezpečnostních incidentů, v1.2 — NÚKIB](https://portal.nukib.gov.cz/storage/uploads/2026/06/08/podpurny-material-ke-hlaseni-incidentu_v1-2_uid_6a267e393778b.pdf)
- [ISO/IEC 27001 — Microsoft compliance offering](https://learn.microsoft.com/en-us/compliance/regulatory/offering-iso-27001)

## Stav produktu / delta

> [!WARNING] Ověřit k datu běhu — stav k 2026-10.
> Aktuální znění vyhlášky č. 410/2025 Sb. na e-Sbírce (čísla §, přílohy); nové verze Manuálu
> pro nižší režim (v1.1 z 2026-06-02) a materiálu k hlášení (v1.2 z 2026-06-08); výše pokut
> podle § 59 zákona.
