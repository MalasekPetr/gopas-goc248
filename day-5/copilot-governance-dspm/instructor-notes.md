# Instructor notes — Governance Copilotu a řízení rizik AI

## Timing

- 10 min demo na B, 10 min výklad (DLP pro Copilot, DSPM, schvalování agentů), 40 min lab
  na A: kroky 1–5 20 min, krok 6 8 min, kroky 7–8 7 min, krok 9 5 min.
- Ventil 2 (−15): krok 6 jen na projekci lektora, krok 8 vypadne. DLP politika a SoA se
  nekrátí.
- Po tomto bloku se na B nevrací — přepnutí profilu v kroku 1 kontrolovat pohledem.

## Go/no-go — otestovat před během

- **Umístění Microsoft 365 Copilot and Copilot Chat v DLP na Tenant A** (bez licencí
  Copilota) — nabízí se v šabloně Custom? Jde scope na skupinu? **Neověřeno na tenantu.**
  Když umístění chybí: fallback z labu, licenční mezera do capstonu.
- **DSPM na A — úvodní nastavení dokončí lektor předem.** První otevření DSPM nabízí
  nastavovací úlohy pro celý tenant; nesmí je kliknout 15 studentů. Zapsat počet politik
  na stránce DSPM před během (pro negativní checkpoint).
- **Agents v Microsoft 365 admin center na A** — existuje bez licencí Copilota? Když ne,
  krok 7 z projekce B.
- **Štítky studentů z D3** existují a jsou publikované; kdo štítek nemá, použije lektorův
  (zapíše jako nález).
- **Demo na B**: web `demo-oversharing`, agent `DEMO Oversharing`, testovací účet; ověřit
  den předem a zapsat výsledek s datem.
- **Vyřazení DSPM (classic)**: v lednu 2027 už classic verze nemusí existovat — ověřit,
  že popis stránek odpovídá.

## Tripwires

- **Jednoklikové politiky DSPM** — platí pro všechny uživatele. Student, který „jen klikne
  na doporučení", založí tenantovou politiku. Zkontrolovat stránku politik po kroku 6.
- **Scope *All users* „jen v simulaci"** — nepovoleno. Simulace na celý tenant zahltí
  reporty ostatních a porušuje tenantovou disciplínu.
- **Štítek + SIT v jednom pravidle** — UI to nedovolí nebo selže; dvě pravidla.
- **„Politika nefunguje"** — na A není Copilot, propsání trvá až 4 h. Checkpoint je
  konfigurace, ne chování.
- **Ukládání v Entra Consent and permissions** — tenantové; změna souhlasu uživatelů rozbije
  přihlášení do aplikací celé učebně.
- **DSPM vs. DLP** — studenti chtějí „zapnout DSPM, aby chránilo". DSPM nic nevynucuje.

## Vazby

- Zpět: `sensitivity-labels` (štítek jako podmínka), `dlp` (simulace, scope),
  `ai-agents-tenant` a `normiqa-navigator-demo` (agenti, které se tady schvalují).
- Dopředu: `compliance-manager-capstone` (řádky A.8.12, A.5.12, A.5.23; licenční mezera
  Business Premium / E3).
