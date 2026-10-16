# Instructor notes — Retence, lifecycle a records management, srovnání se SAM

## Timing

- ~25 min výklad + 10 min SAM (tabulka + podmíněné demo) + 60 min lab + 5 min rezerva.
- V labu chránit **krok 9 (stopa, ~15 min)** — začít ho nejpozději 25 min před koncem dne.
- Padá první: SAM demo (−10, ventil 3). Pak krok 3 jen ústně. Krok 9 se nekrátí.

## Go/no-go — otestovat před během

- Kurzovní štítek `GOC248 ISMS zaznam` publikovaný T−10 dní; úterý večer viditelný v **Apply
  label** na webech `isms-<ini>` (guide v `sensitivity-labels`).
- Typ webů `isms-<ini>` (komunikační / týmový se skupinou) — podle toho říct lokaci v krocích 5–6.
- `test-<ini>`: licence, MFA zaregistrované, člen webu, vidí schválené dokumenty — namátkou 3.
- Kurzovní citlivostní policy se zdůvodněním platí pro `test-<ini>` (Veřejné je v nabídce).
- Record versioning zapnuté v Records Management settings.
- SAM: stránka Site lifecycle management dostupná? Když ne, demo neprobíhá.
- Neověřeno na tenantu: zda pokus o smazání záznamu vytvoří auditní záznam; zda snížení štítku
  v knihovně se schvalováním obsahu vytvoří koncept; text dialogu zdůvodnění; zda Global
  Administrator smí vytvářet štítky ve File plan bez role Records Management.

## Tripwires

- **Odebrání posledního zahrnutého webu** v politice = lokace **All** = retence na celý tenant
  (blokace mazání webů všem). Kontrolovat detail každé politiky po krocích 5 a 6.
- **Špatná lokace pro týmový web se skupinou** — politika se uloží, ale nic nepokryje. Projeví se
  až po dnech; kontrolovat podle kroku 2.
- **Regulatory record / Preservation Lock** — nikdy; kdo se zeptá „jak zapnout", dostane odpověď
  a varování, ne příkaz.
- **Student aplikuje kurzovní záznamový štítek na Politiku**, kterou má `test-<ini>` snižovat —
  zamčený záznam nejde upravit a krok 9.3 selže. Záznam jen na `ZAZ-01`.
- **Stopa vlastním účtem místo `test-<ini>`** — InPrivate okno ve **správném profilu** (Tenant A),
  kontrola účtu vpravo nahoře.
- **Odstranění štítku místo snížení** — výchozí štítek knihovny dokument znovu označí; audit pak
  ukáže jinou sekvenci.
- **Časy bez pásma** — ve čtvrtek se nedají spárovat s UTC v auditu.
- Studenti chtějí stopu hned ověřit v auditu — ne; ingest má zpoždění, ověřuje se ve čtvrtek.

## Vazby

- Zpět: `sensitivity-labels` (Politika se štítkem, kurzovní policy se zdůvodněním),
  `lists-registers-workflow` (Incident log), `document-libraries-governance` (schvalování).
- Dopředu: `audit-incident-response` (stopa: časy a očekávané operace v `reseni-retence-zaznamy.md`),
  `compliance-manager-capstone` (A.5.33 bez E5 jako nález). Úklid: guide v `sensitivity-labels`.
