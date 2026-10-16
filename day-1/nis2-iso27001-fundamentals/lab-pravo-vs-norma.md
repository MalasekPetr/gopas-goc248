# Lab · Zákon, vyhláška, nebo norma?

> Modul: `nis2-iso27001-fundamentals` · Odhad: 15 min · Režim: papírové cvičení ve dvojici
> Tenant: — · Scénář: [`../../scenario-isms-vltava.md`](../../scenario-isms-vltava.md)

## Cíl

Ve dvojici správně zařadit osm výroků vedení Vltava Servis a vybrat, která opatření musí firma
v režimu nižších povinností zavést vždy.

**Jak lab číst:** každý krok končí **Checkpointem** — nesedí-li, nepokračuj. Pracuj jen
s README modulu; text normy ISO nepotřebuješ.

## Předpoklady

- Přečtené README modulu, hlavně tabulky „13 oblastí" a „Přehled bezpečnostních opatření vs.
  SoA".

## Kroky

### 1. Zařaď výroky vedení

Ke každému výroku napiš **Z** (zákon č. 264/2025 Sb. nebo vyhláška č. 410/2025 Sb.), **N**
(norma ISO/IEC 27001), **Z+N** (obojí), nebo **X** (nepravda):

1. „Musíme mít přehled bezpečnostních opatření a jednou ročně ho aktualizovat."
2. „Musíme mít prohlášení o aplikovatelnosti ke každému opatření Annex A."
3. „Když budeme certifikovaní podle ISO 27001, máme splněný zákon."
4. „Incident s významným dopadem musíme prvotně nahlásit nejpozději do 24 hodin."
5. „Microsoft 365 je certifikovaný podle ISO 27001, takže my jsme taky."
6. „Bezpečnostní politiku musíme pravidelně aktualizovat a její dodržování vynucovat."
7. „Opatření pro řízení přístupu (§ 7) smíme nezavést, pokud to v přehledu odůvodníme."
8. „Vrcholné vedení musí určit osobu pověřenou kybernetickou bezpečností."

**Checkpoint:** u každého výroku je jedno písmeno a jedna věta proč s odkazem na řádek tabulky
v README. Výroky 3 a 5 jsou označené **X** — pokud ne, vraťte se k sekci „Klíčové rozlišení".

### 2. Vyber neopominutelná opatření

Ze 13 oblastí podle § 14 odst. 2 zákona zakroužkuj ta, která musí Vltava Servis v režimu
nižších povinností zavést **vždy**, a napiš jejich § ve vyhlášce.

**Checkpoint:** zakroužkovaných je pět: § 3 (odst. 2 až 6), § 4, § 5, § 6, § 10. Řízení
přístupu (§ 7) mezi nimi **není** — a umíte říct, co se s ním stane, když ho firma nezavede.

### 3. Najdi mezeru mezi SoA a přehledem

Vedení chce mít „jednu tabulku pro auditora i pro NÚKIB". Napište dvě informace, které příloha
č. 1 vyhlášky u opatření v procesu chce a které klasické SoA neobsahuje.

**Checkpoint:** na papíře jsou aspoň dvě z: stav „v procesu", termín zavedení, priorita,
odpovědná osoba.

### 4. Zapiš do SoA

V tomto labu **ne** — seznam SoA vznikne v [`../isms-design-m365/`](../isms-design-m365/).
Papír si nech: odpověď z kroku 3 se tam hodí.

**Checkpoint:** nic — přeskoč.

## Ověření

- [ ] Osm výroků zařazených, výroky 3 a 5 jako **X**.
- [ ] Pět neopominutelných opatření s čísly §.
- [ ] **Negativní:** § 7 (řízení přístupu) není mezi neopominutelnými.
- [ ] Aspoň dvě informace z přílohy č. 1, které SoA nemá.

## Fallback

- **Dvojice se zasekne na výroku:** přeskočit, lektor ho vezme ve společném rozboru.
- **Při časové tísni:** jen krok 2 a společně výroky 3 a 5 (−10). Klíč je v
  [`reseni-pravo-vs-norma.md`](reseni-pravo-vs-norma.md).

## Zdroje

- [Důvodová zpráva k vyhlášce č. 410/2025 Sb. — NÚKIB](https://portal.nukib.gov.cz/storage/uploads/2025/12/03/duvodova-zprava-vyhlaska-nizsi-rezim_uid_693039f42250d.pdf)
- [Manuál pro režim nižších povinností, v1.1 — NÚKIB](https://portal.nukib.gov.cz/storage/uploads/2026/06/02/manual-nizsi-rezim-v1-1_uid_6a1eaedd0ce9f.pdf)
- [Hlášení kybernetických bezpečnostních incidentů, v1.2 — NÚKIB](https://portal.nukib.gov.cz/storage/uploads/2026/06/08/podpurny-material-ke-hlaseni-incidentu_v1-2_uid_6a267e393778b.pdf)
