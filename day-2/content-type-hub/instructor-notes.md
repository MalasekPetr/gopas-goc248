# Instructor notes — Content Type Hub a standardizace politik, Autofill columns

## Timing

- ~15 min výklad + 60 min lab + 5 min SoA. Lab: kroky 1–4 ~15 min (A), 5–9 ~25 min (B),
  10–12 ~20 min (zpět A).
- Pořadí A -> B -> A je záměrné: publikace typů obsahu (krok 4) má čas dorazit, zatímco se
  pracuje na B. Neprohazovat.
- Krátí se první kroky 6–9 jako demo lektora (ventil dne č. 1, −20 min).

## Go/no-go — otestovat před během

- **Den předem:** sdílené sloupce `VS ISMS` v hubu Tenant A existují (6 sloupců, ASCII
  interní názvy podle README). Chybí → založit ráno; bez nich kroky 2–3 nejdou.
- **Den předem:** publikovat testovací typ obsahu a změřit, kdy je dostupný v knihovně
  (`mereni-publikace-typu-obsahu.md`). Je to víc než ~40 min → rovnou ohlásit fallback `L-*`.
  **Neověřeno na tenantu.**
- **Tenant B:** Document processing PAYG aktivní; rozsah Autofill zahrnuje všechny weby
  `isms-*` (Selected sites max 100, nebo All sites); rozpočtový alert. Na jednom studentském
  webu projít kroky 6–8 a změřit dobu zpracování. **Neověřeno na tenantu.**
- **Tenant B:** sedm vzorových dokumentů v `Dokumentace` na každém webu; obsah odpovídá
  tabulce v `reseni-typy-obsahu-autofill.md` (datum slovy v POL-02, odvozené datum v SME-02,
  bez data v ZAZ-01).
- Ověřit, zda Tenant B nemá licence Microsoft 365 Copilot — s nimi by Autofill jel jinou
  cestou (součást Copilot in SharePoint) a PAYG výpočet v labu by neplatil.

## Tripwires

- **Úprava sdíleného sloupce `VS ISMS`** (přejmenování, nové volby) — mění sloupec všem.
  Kontrolovat po kroku 4; opravit hned.
- **Typ obsahu bez prefixu** nebo v cizí kategorii — po kurzu ho nikdo neuklidí. Kontrola
  v galerii filtrem podle kategorií.
- **Krok 8 dřív než krok 7** → dokumenty se zpracují dvakrát a platí se dvakrát. Proto
  „ještě nic nezpracovávej" v kroku 6.
- **„Autofill to vyplnil, takže to platí."** Vrátit k ZAZ-01: záznam nemá datum revize;
  vymyšlené datum je přesně ta chyba, kterou schválení musí chytit.
- **Person sloupec na A vs. text na B** — studenti to vezmou jako chybu materiálu. Je to
  pointa: Autofill Person nepodporuje.
- **Hubový a lokální typ Politika v jedné knihovně** po pozdním doručení publikace. Nechat
  jen jeden.
- **Špatný profil při návratu na A (krok 10)** — v profilu B není `ControlledDocs`; student
  pak hledá chybu v publikaci.

## Vazby

- Zpět: `document-libraries-governance` (knihovna, `POL-01`, schvalování po změně metadat).
- Dopředu: `lists-registers-workflow` (Skills nad toutéž dokumentací na B),
  `sensitivity-labels` (Klasifikace -> štítky; šifrované soubory Autofill nezpracuje),
  `retention-lifecycle` (typ Záznam -> retence), `ai-agents-tenant` (agent nad `Dokumentace`).
