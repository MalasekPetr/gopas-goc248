# Instructor notes — Onboarding a přístup do obou tenantů

## Timing

- ~10 min výklad (dva tenanty, pravidla týdne, mapa AI) + 35 min lab.
- Registrace MFA dvakrát je nejdelší položka; kdo je hotov s A, jde rovnou na B — výklad mapy
  AI pustit **během** labu tomu, kdo čeká na průvodce.
- Krátí se první: krok 5 a 9 společně na projektoru. **Nekrátit** krok 6 (MFA na B) — chybějící
  MFA na B v úterý zastaví `content-type-hub`.

## Go/no-go — otestovat před během

- Účty pro oba tenanty, hesla a iniciály `<ini>` na lístcích; iniciály bez kolizí ve skupině.
- Tenant A: studentské účty mají Global Administrator; security defaults vypnuté; registrace
  MFA se při prvním přihlášení vyžádá (politikou) — **neověřeno na tenantu**.
- Tenant A: skupiny `isms-<ini>-users` a uživatelé `test-<ini>` založené skriptem pro každého.
- Tenant B: rozsah `user.NN` volný pro tento běh (kolize s GOC224), weby `isms-<ini>` založené
  skriptem, student je vlastník — **neověřeno na tenantu**.
- Krok 7: že Microsoft 365 admin center na B studenta bez role skutečně odmítne — **neověřeno
  na tenantu**; když ne, upravit checkpoint, ne vynechat.
- Krok 8: co přesně uvidí student při otevření URL tenantu B v profilu A (výběr účtu / výzva /
  odmítnutí) — **neověřeno na učebních strojích**. Checkpoint je formulovaný na výsledek „neotevřelo
  se s obsahem", ne na konkrétní hlášku.
- Edge na učebních strojích dovolí přidat profil bez přihlášení — **neověřeno**.

## Tripwires

- **Osobní účet v Edge.** Stroj může mít přihlášený profil školicího střediska nebo osobní
  účet; student se přihlásí do kurzu v něm. Nutit nové profily (krok 1).
- **Druhý účet do stejného profilu.** Nejčastější chyba celého týdne. Krok 8 je na to test —
  kdo v něm „uspěje", má v profilu A oba účty.
- **Telefon bez Authenticatoru / bez dat.** Mít připravenou alternativu, kterou povoluje
  politika tenantu (SMS) — jen pokud je v Authentication methods policy povolená.
- **„Já už MFA mám"** — z jiného kurzu na `cloudedu.cz`. Ověřit, že jde o tento účet; staré
  metody se na Security info dají smazat.
- **Zvědavost Global Administratora.** Krok 5 svádí klikat. Říct předem: dnes nic neukládáme.
- **Mapa AI:** nezabíhat do Copilota; konkrétní otázky parkovat na D2 a D5.

## Vazby

- Dopředu: `isms-design-m365` (web na A), `content-type-hub` a `lists-registers-workflow`
  (B v úterý), `conditional-access` a `privileged-access-pim` (tenantová nit), D5 (AI).
