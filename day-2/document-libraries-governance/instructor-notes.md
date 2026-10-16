# Instructor notes — Knihovny jako úložiště řízené dokumentace

## Timing

- ~30 min výklad + 60 min lab + 10 min SoA a dotazy. Výklad drž na tabulce „kap. 7.5 ->
  nastavení"; základy knihoven jsou GOC222, neopakovat.
- Lab: kroky 1–4 ~20 min, 5–8 ~25 min (přihlášení `test-<ini>` je žrout času), 9–10 ~15 min.
- Krátí se první krok 9, pak kroky 5–6 jako společné demo. **Nekrátit** krok 8 a SoA —
  na `ControlledDocs` stojí odpoledne i D3.

## Go/no-go — otestovat před během

- `test-<ini>` pro všechny studenty: licence se SharePointem, známé heslo, **MFA
  zaregistrované** (jinak 15 min na registraci uprostřed labu). Ideálně řešit už v
  `onboarding` (D1). Nejde-li to → fallback labu (autor = student), lektor ukáže kroky 6–7.
- Na zkušebním webu projít Versioning settings: zda knihovna s aktuálním limitem verzí
  nabízí vedlejší verze a volbu viditelnosti konceptů, a přesné popisky. **Neověřeno na
  tenantu** — upravit krok 3 podle reality.
- Ověřit popisky publikace a schválení v moderní knihovně (**Publish** / **Submit for approval**,
  **Approve/Reject**). **Neověřeno na tenantu.**
- Ověřit, že zděděný limit verzí na Tenant A je známý (automatický / ruční) — studenti ho zapisují.
- InPrivate okno profilu A: na učebních strojích povolené (politika prohlížeče).

## Tripwires

- **Špatný profil v kroku 6.** Student otevře InPrivate z profilu Tenant B nebo se přihlásí
  `test-<ini>` cizího studenta. Checkpoint kroku 6 kontrolovat pohledem.
- **Knihovna pojmenovaná rovnou česky** → adresa s `%C5%98...`. Lze opravit jen novou knihovnou;
  rozhodnout hned u kroku 2, ne až u SoA.
- **„Schválil jsem si to sám."** Student jako Global Administrator a vlastník webu může
  všechno — oddělení autora a schvalovatele je organizační rozhodnutí, ne technická
  nemožnost. Navázat na `privileged-access-pim` (D4).
- **Rezervace zapnutá „pro jistotu"** → `test-<ini>` pak upravuje dokument, který má rezervovaný
  student, a krok 9 selže. Vrátit na No.
- **Limit verzí** — někdo navrhne „nastavit 500 verzí kvůli auditu". Odpověď: uchování řeší
  retence (D3), která limit verzí přebíjí; v labu se limit nemění.
- **Moderní Approvals na téže knihovně** — studenti je najdou v menu **Automate/Integrate**.
  Nezapínat; nejsou integrované se schvalováním obsahu. Patří do odpoledního bloku k registrům.
- **SAM** — otázka „proč to nevidíme v admin centru": Tenant A nemá licenci Copilot ani add-on.
  Jen výhled; do detailu nejít.

## Vazby

- Zpět: `isms-design-m365` (web `isms-<ini>`, seznam `SoA`), `onboarding` (`test-<ini>`, MFA).
- Dopředu: `content-type-hub` (typy obsahu na `ControlledDocs`), `sensitivity-labels`,
  `dlp`, `retention-lifecycle` (D3 na téže knihovně), `privileged-access-pim` (oddělení rolí),
  `ai-agents-tenant` (agent nad kopií dokumentace na B).
