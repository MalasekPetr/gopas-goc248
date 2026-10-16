# Instructor notes — Privilegovaný přístup — PIM

## Timing

- ~25 min výklad + 55 min lab + 10 min nález (tabulka rolí, krok 10).
- Ventil dne č. 2: schvalovací tok jako demo lektora (−15) — studenti nastaví bez schválení.
- Demo PIM pro role Entra (5 min) dělat **během** výkladu, ne po labu.

## Go/no-go — otestovat před během

- **Entra ID P2 na `test-*` i na studentských účtech** — Learn vyžaduje licenci pro eligible
  uživatele **a pro schvalovatele**. Bez P2 celý blok jako demo.
- Běžný uživatel (`test-*`) se dostane do PIM → My roles v Entra admin center: zkontrolovat
  nastavení omezení přístupu k admin portálu pro ne-adminy — **neověřeno na tenantu**.
- Demo účet a role pro demo PIM pro role Entra připravené (role, kterou kurz nepoužívá, např.
  Reports Reader). **Nikdy** neměnit nastavení Global Administrator ani Privileged Role
  Administrator.
- Úklid z minulého běhu: skupiny `*-isms-admins` smazané (ze správy PIM vyjmout nejdou).
- Neověřeno na tenantu: cesta k oprávněním webu podle typu webu z dne 1, za jak dlouho se
  aktivované členství projeví na webu `isms-<ini>` (změřit při zkušebním průchodu a zapsat
  do `mereni-*.md`).

## Tripwires

- **Student přidá `test-<ini>` do skupiny přímo** v Entra Groups „aby to fungovalo". PIM je tím
  obejitý — a je to přesně ten nález, který má umět najít. Nechat odebrat, ne mazat skupinu.
- **Student zvolí špatnou skupinu v Discover groups** (cizí `xy-isms-admins` nebo
  `isms-<ini>-users`). Nevratné; řešení = skupinu po kurzu smazat, nastavení vrátit vlastníkovi.
- **Schvalovatel = `test-<ini>`** → žádost nikdo neschválí. Schvalovatel je kurzovní účet.
- **„Web se neotevřel, PIM nefunguje."** PIM funguje; SharePoint může mít zpoždění. Důkaz je
  Active assignment.
- **Eligible vs. žádná role** — studenti říkají „test nemá práva". Má — jen je musí aktivovat.
- Diskuse „u nás máme 12 Global Adminů" — patří do kroku 10, ne do výkladu.

## Vazby

- Zpět: `conditional-access` (MFA metoda `test-<ini>`, authentication context),
  `isms-design-m365` (web `isms-<ini>`).
- Dopředu: `audit-incident-response` (aktivace a změny skupin jsou auditní události),
  `compliance-manager-capstone` (A.8.2 a Návrh rolí jako důkaz).
