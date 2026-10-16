# Demo · Co Copilot nad daty skutečně vidí

> Modul: `copilot-governance-dspm` · Odhad: 10 min · Režim: instruktorské demo
> Tenant: B `spdemo.online` · Účty: lektor + jeden testovací účet `user.NN` (bez přístupu k omezenému webu)

Cíl dema: jedna věta na tabuli — **Copilot nevidí víc než uživatel, ale najde všechno, co
uživatel vidět smí.** Bez Purview na B se to nedá ošetřit politikou; dá se to jen ukázat.

## Příprava (den předem, lektor)

1. Web `demo-oversharing` na B se dvěma fiktivními dokumenty:
   - `Platy-2026-FIKTIVNI` — sdílený celé organizaci (oprávnění nebo odkaz pro všechny
     v organizaci),
   - `Strategie-2027-FIKTIVNI` — přístup jen lektor.
2. Agent v Agent Builderu `DEMO Oversharing` se zdrojem web `demo-oversharing`, nasdílený
   testovacímu účtu s rolí *Can chat*, **bez** automatického sdílení souborů.
3. Ověřit oba dotazy z kroku 2 a 3 na testovacím účtu a výsledek zapsat s datem —
   **neověřeno na tenantu** do zkušebního průchodu.

## Průběh

### 1. Kdo co vidí (2 min)

Ukaž oprávnění obou dokumentů. Studenti tipují, co dostane testovací účet.

**Checkpoint:** na tabuli jsou tipy studentů pro oba dokumenty.

### 2. Dotaz na přesdílený dokument (3 min)

Testovacím účtem se zeptej agenta na obsah `Platy-2026-FIKTIVNI`.

**Checkpoint:** odpověď (nebo její absence) je na projekci; ukaž citaci.

### 3. Dotaz na omezený dokument (2 min)

Totéž pro `Strategie-2027-FIKTIVNI`.

**Checkpoint (negativní):** testovací účet obsah omezeného dokumentu nedostane.

### 4. Náprava je v oprávnění, ne v agentovi (3 min)

Odeber u `Platy-2026-FIKTIVNI` sdílení celé organizaci. Zeptej se znovu — teď nebo na konci
bloku (doba propsání změny oprávnění do odpovědí není změřená; zapsat s datem).

**Checkpoint:** studenti formulují, který den kurzu tohle řešil (oprávnění a sdílení — D2,
D4) a co by na Tenant A přidal Purview (štítek + DLP pro Copilot — lab tohoto bloku).

## Fallback

- **PAYG nebo agent nefunguje:** ukázat oprávnění a vysvětlit stejný princip na stránce
  [Learn: Copilot privacy](https://learn.microsoft.com/en-us/microsoft-365/copilot/microsoft-365-copilot-privacy);
  demo se nepředstírá screenshotem.
- **Při časové tísni:** jen kroky 2 a 3.
