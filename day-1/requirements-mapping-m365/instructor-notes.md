# Instructor notes — Mapování požadavků na Microsoft 365 a licenční realita

## Timing

- ~30 min výklad + 40 min lab + 5 min společná kontrola kroku 5.
- Výklad: tvar matice a kostra (12), retence není záloha (3), licenční princip na
  `comparison-licence.md` (10), čtyři konzole (5).
- Ventil dne č. 2 (−15): licenční tabulku jen promítnout k přečtení, v labu vypadne krok 2
  a krok 4 se zkrátí na řádky a), d), j).

## Go/no-go — otestovat před během

- **Licence na Tenant A**: Billing -> Licenses ukazuje produkt s E5 a Entra ID P2, studentské
  účty ho mají přiřazený — **neověřeno na tenantu** (go/no-go v environment.md).
- **OneDrive studentů**: první otevření OneDrive nového účtu může chvíli trvat (zřízení) —
  **neověřeno na tenantu**; kdo nemá OneDrive, jede podle Fallbacku.
- **Excel pro web** v OneDrive na Developer tenantu dostupný — **neověřeno na tenantu**.
- `comparison-licence.md` je ověřená k 2026-10-17. Den před během otevřít Purview service
  description a Entra licensing a porovnat ms.date; při změně projít řádky.

## Tripwires

- **„V naší firmě máme E3."** Zeptat se: Microsoft 365 E3, nebo Office 365 E3? Druhá nemá
  Entra ID P1, takže ani Conditional Access.
- **„Ne" čtené jako „nikdy".** Tabulka říká jen, co zdroj jmenuje. Add-ony se mění a přejmenovávají
  (Purview Suite, Defender Suite).
- **Purview Suite for Business Premium** studenti budou chtít použít na všechno. Zdroj ho
  jmenuje jen u Audit (Premium) — víc neslibovat.
- **Vymyšlený § u řízení rizik.** Vyhláška ho neupravuje; checkpoint kroku 4 na to cílí.
- **Retence jako záloha.** Opakovaně se objeví u § 6 kontinuity — opravit hned.
- **Global Administrator v Billing.** Krok 2 je jen čtení; nikdo nepřiřazuje licence.
- **Mapování na Annex A je návrh kurzu**, ne oficiální tabulka. Neprodávat jako „správnou odpověď".

## Vazby

- Zpět: `nis2-iso27001-fundamentals` (13 oblastí, neopominutelná opatření).
- Dopředu: `isms-design-m365` (sešit jako důkaz A.5.31), sekce Licence každého modulu,
  `copilot-governance-dspm` (proč B nemá Purview), capstone (co by organizace s vlastní
  licencí neudělala).
