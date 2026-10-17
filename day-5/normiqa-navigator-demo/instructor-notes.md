# Instructor notes — Hotový agent z Microsoft Marketplace — Normiqa Navigator

## Timing

- 30 min: 5 kritéria, 20 demo (listing 5, tenant 5, instalace a detail 5, agent v akci 3,
  exit 2), 5 verdikt. Studenti vyplňují šablonu průběžně.
- Ventil 1 (−15): bez živé instalace — listing + admin center bez instalace, šablona jen
  sloupec V a kritéria z listingu.

## Go/no-go — otestovat před během

- **Listing je veřejný** — otevřít v prohlížeči (automatizovaný dotaz vrací 403):
  `marketplace.microsoft.com/en-us/product/wa200011233` (odkaz v README). Bez listingu =
  ventil 1.
- **Agent jde na B nainstalovat** lektorským účtem — Agent Store nebo nasazení v registru
  jen na lektora. **Neověřeno na tenantu.**
- **Nastavení na B**: *Agent and plugin access* (externí vydavatelé), *User access*.
  Zjistit stav předem; neměnit za běhu, pokud to není nutné, a případnou změnu po bloku
  vrátit (sdílený tenant — kolize s GOC224).
- **Stránky *Agents* v admin center na B** existují — Learn je uvádí jako zapnuté
  v tenantech s licencí Copilot; B má jen PAYG. Když chybí, demo jen nad listingem (ventil 1).
- **Lektorský účet na B** má roli pro správu agentů (AI Administrator nebo Global
  Administrator) a profil prohlížeče jen pro B.
- Všechny kroky dema: **neověřeno na tenantu** do zkušebního průchodu.

## Tripwires

- **Neutralita.** Žádná tvrzení o produktu ze sesterských kurzů, z webu Malach IS ani
  z paměti — ani „je zdarma", ani „čerpá jen z webu", ani pro koho je určený. Co student
  nevidí na listingu nebo na tenantu, to v bloku neexistuje. Na otázku „a je to dobré?"
  odpověď zní: „vyplň kritéria a rozhodni sám".
- **Pořadí.** Agent se neukáže dřív než kritéria. Kdo začne dotazem na agenta, hodnotí
  dojem.
- **„Prošlo Marketplace = schváleno."** Publikace u Microsoftu není schválení
  v organizaci. Brána je nastavení externích vydavatelů a registr.
- **Souhlasová obrazovka.** Declarative agent ji mít nemusí. Neříkat předem, co se
  zobrazí — ukázat, co se zobrazilo.
- **Requests** v admin center neslouží pro agenty třetích stran (Learn: agent requests) —
  neukazovat ho jako cestu schválení cizího agenta.
- **Úklid:** po bloku agenta na B odebrat nebo nechat jen na lektorovi; zapsat
  do úklidového seznamu.

## Vazby

- Zpět: `ai-agents-tenant` (sloupec V šablony = vlastní agent).
- Dopředu: `copilot-governance-dspm` (schvalování agentů a admin consent jako tenantová
  politika), `compliance-manager-capstone` (šablona jako důkaz k A.5.23).
