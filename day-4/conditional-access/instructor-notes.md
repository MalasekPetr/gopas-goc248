# Instructor notes — Conditional Access a řízení přístupu

## Timing

- ~35 min výklad + 60 min lab + 5 min SoA. Výklad: CA model a pojmenování 10, síla ověření
  a TAP 10, break-glass a managed politiky 5, risk 10.
- Ventil dne č. 1: krok 6 labu jen běh a + e (risk bez vyhodnocení) — −15 min.
- Žrout času: registrace Authenticatoru pro `test-<ini>` (krok 3). Kdo nemá telefon, rovnou
  vícenásobný TAP.

## Go/no-go — otestovat před během

- Security defaults **vypnuté** (Entra ID > Overview > Properties).
- **Nouzové účty**: dva, cloudové, skupina nouzových účtů existuje; přihlášení nouzovým účtem
  ověřené den předem. Název skupiny je v lektorském souboru, ne v repu.
- **Microsoft-managed politiky**: projít seznam, u každé buď stav *Off*, nebo vyloučená skupina
  nouzových účtů **a lektorský účet**. Termín zapnutí zkontrolovat v detailu politiky
  a v Message center — Learn uvádí „ne dřív než 30 dní", ale připouští i dřívější zapnutí.
- **TAP politika** povolená jen pro skupinu testovacích uživatelů `test-*`; max. životnost
  aspoň 4 h, povolit vícenásobný TAP (fallback bez telefonu).
- Entra ID P2 na `test-*` (risk podmínky, PIM o blok později).
- Politiky `*-CA0*` z minulého běhu smazané (limit 240 politik na tenant).
- Neověřeno na tenantu: popisky *Client apps* (Exchange ActiveSync / Other clients), přesné
  znění důvodů ve What If, latence záznamu v sign-in logu po přihlášení `test-<ini>`.

## Tripwires

- **„All users" v Include.** Nejdražší chyba kurzu. Krok 7 (čtyři oči) se nevynechává ani
  v časové tísni. Při kontrole projít seznam politik filtrem `On` — jen `*-CA01`.
- **Student zahrne sám sebe** „aby to viděl". Ne. Jeho účet je Global Administrator; vidí to
  přes What If a přes `test-<ini>`.
- **Špatný profil prohlížeče** — student se přihlásí jako `test-<ini>` v hlavním okně a pak
  konfiguruje politiky pod testovacím účtem bez práv. InPrivate okno jen pro `test-<ini>`.
- **What If s *Office 365*** — nic se nespáruje, studenti si myslí, že politika nefunguje.
  Jedna konkrétní aplikace.
- **Risk ve What If nevyplněný** → CA03/CA04 „nefungují". Je to správně.
- **Managed politika ve výsledcích** — studenti ji chtějí „opravit". Nesahat; patří lektorovi.
- **Zablokovaný `test-<ini>`** — přepnout CA01 na Report-only, nemazat politiku (důkaz).

## Vazby

- Zpět: `onboarding` (MFA registrace, profily prohlížeče), `isms-design-m365` (SoA).
- Dopředu: `privileged-access-pim` (`test-<ini>` s MFA metodou aktivuje členství),
  `audit-incident-response` (sign-in log jako zdroj důkazů), capstone.
