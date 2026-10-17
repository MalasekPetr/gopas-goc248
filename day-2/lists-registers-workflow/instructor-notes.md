# Instructor notes — Lists jako živé evidence a workflow, Skills

## Timing

- ~25 min výklad + 70 min lab registrů (A) + 15 min demo Skills (B, lektor) + 10 min rezerva.
- Lab registrů: kroky 2–3 ~12 min, 4–5 ~18 min, 6–7 ~15 min, 8–9 ~12 min, SoA ~5 min.
- Krátí se: demo Skills jen kroky 4 a 6 (ventil dne č. 2, −10 min); zadávání dat (3 aktiva). **Nekrátit**
  Incident log a Risk Register — D4 a capstone na nich stojí; kdo nestihne, dostane seznamy
  skriptem a doplní data.

## Go/no-go — otestovat před během

- **Lektorský účet na B s licencí Microsoft 365 Copilot** — bez ní Skills nejdou (Learn;
  potvrdil autor 2026-10, studentské PAYG účty nestačí). Web `isms-lektor` se vzorovou
  dokumentací a Autofill sloupci; kroky 1–5 dema projít den předem.
- Po 2026-11-01 platí místo `KnowledgeAgentScope` **Site AI settings** a RCD: ověřit, že
  weby `isms-*` na B nemají RCD a Copilot není skrytý.
- Ověřit, zda „advanced work" (Copilot Credits) nespouští už běh skillu nad 7 dokumenty;
  spending policy a limit na B.
- **Approvals v seznamech na Tenant A** (Developer tenant): zapnout na zkušebním seznamu,
  podat a schválit žádost; změřit, jak dlouho trvá první žádost. **Neověřeno na tenantu.**
  Umístění v menu (Integrate/Automate).
- Počítaný sloupec `ReportDeadline` s časem: ověřit, že `[DetectedAt]+1` ukazuje +24 h
  v časové zóně webu `isms-<ini>` (časová zóna webu z D1). **Neověřeno na tenantu.**
- Volitelný flow (`guide-revizni-flow.md`): projít jednou celý; filtr na datum neověřen.

## Tripwires

- **Sloupec založený česky** → interní název `_x0...`. Kontrolovat `&Field=` u Incident logu
  u každého studenta před SoA. Oprava = smazat a založit znovu, dokud nejsou data.
- **Přejmenování před založením počítaného sloupce** → vzorec se musí psát s českými názvy;
  funguje taky, ale studenti se zaseknou na diakritice. Držet pořadí z labu.
- **Lookup na jiný web** — nejde; Asset Register musí být ve stejném webu.
- **Změna stavu rizika během běžící žádosti** zruší žádost (nápověda Approvals). Proto pořadí
  „schválit, pak Přijato".
- **Schvalovatel = žadatel** v kroku 9 — v kurzu záměrně (student hraje vlastníka rizika).
  Říct nahlas, že v praxi žádá analytik a schvaluje vlastník rizika.
- **„Skill pošle e-mail / poběží každý týden."** Neumí: žádné externí systémy, žádný plánovač
  v základu. Na to je flow.
- **Skill uložený jako osobní** → nikdo jiný ho nevidí a v Agent Assets není.
- **Negativní test v kroku 5 dema** — Copilot může „odpovědět" obecně o rizicích. Rozhoduje,
  zda zmíní konkrétní rizika z A; obecná odpověď není únik.
- „Proč to nemůžu zkusit sám?" → licence: Autofill jde přes PAYG, Skills ne. Je to obsah,
  ne technický problém kurzu.
- Špatný profil při zápisu do SoA v kroku 6 → SoA na B neexistuje; student hledá seznam.

## Vazby

- Zpět: `isms-design-m365` (SoA), `document-libraries-governance` (aktivum ISMS dokumentace),
  `content-type-hub` (Autofill tabulka pro porovnání se skillem).
- Dopředu: `sensitivity-labels` (Klasifikace aktiv -> štítky), `audit-incident-response`
  (plní Incident log, schéma pevné), `conditional-access` (riziko 1 -> MFA),
  `ai-agents-tenant` (agent vs. skill), `compliance-manager-capstone` (Risk Register a SoA).
