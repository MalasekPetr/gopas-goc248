# Instructor notes — Lists jako živé evidence a workflow, Skills

## Timing

- ~25 min výklad + 65 min lab registrů (A) + 25 min lab Skills (B -> A) + 5 min rezerva.
- Lab registrů: kroky 2–3 ~12 min, 4–5 ~18 min, 6–7 ~15 min, 8–9 ~12 min, SoA ~5 min.
- Krátí se: Skills jako demo (ventil dne č. 2, −15 min); zadávání dat (3 aktiva). **Nekrátit**
  Incident log a Risk Register — D4 a capstone na nich stojí; kdo nestihne, dostane seznamy
  skriptem a doplní data.

## Go/no-go — otestovat před během

- **Skills na Tenant B pro `user.NN` bez licence Microsoft 365 Copilot.** Learn (2026-09)
  uvádí licenci jako prerekvizitu; empirie z jiného kurzu (2026-07, preview) říkala opak.
  Na jednom studentském účtu projít kroky 2–5 labu Skills den předem.
  Funguje → hands-on. Nefunguje → demo lektorským účtem s licencí a ohlásit ráno.
  **Neověřeno na tenantu.**
- Po 2026-11-01 platí místo `KnowledgeAgentScope` **Site AI settings** a RCD: ověřit, že
  weby `isms-*` na B nemají RCD a Copilot není skrytý.
- Ověřit, zda „advanced work" (Copilot Credits) nespouští už běh skillu nad 7 dokumenty;
  spending policy a limit na B.
- **Approvals v seznamech na Tenant A** (Developer tenant): zapnout na zkušebním seznamu,
  podat a schválit žádost; změřit, jak dlouho trvá první žádost. **Neověřeno na tenantu.**
  Umístění v menu (Integrate/Automate).
- Počítaný sloupec `ReportDeadline` s časem: ověřit, že `[ClassifiedAt]+1` ukazuje +24 h
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
- **Negativní test v kroku 6 Skills** — Copilot může „odpovědět" obecně o rizicích. Rozhoduje,
  zda zmíní konkrétní rizika z A; obecná odpověď není únik.
- Špatný profil při návratu na A v kroku 7 → SoA na B neexistuje; student hledá seznam.

## Vazby

- Zpět: `isms-design-m365` (SoA), `document-libraries-governance` (aktivum ISMS dokumentace),
  `content-type-hub` (Autofill tabulka pro porovnání se skillem).
- Dopředu: `sensitivity-labels` (Klasifikace aktiv -> štítky), `audit-incident-response`
  (plní Incident log, schéma pevné), `conditional-access` (riziko 1 -> MFA),
  `ai-agents-tenant` (agent vs. skill), `compliance-manager-capstone` (Risk Register a SoA).
