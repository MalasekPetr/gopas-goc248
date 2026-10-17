# Instructor notes — Návrh ISMS v Microsoft 365

## Timing

- ~35 min výklad + 80 min lab + 5 min kontrola řádků SoA na projektoru.
- Výklad: cílový stav (8), typ webu (7), IA (5), schéma SoA a interní názvy (10), AI uvnitř
  hranice (5; demo na B jen pokud je čas).
- **Nekrátit.** Pokud den ujel, krátí se demo AI a v labu krok 10 (Mapa ISMS). Kroky 2–8 a 11
  nikdy — schéma SoA a první řádky potřebuje úterý.

## Go/no-go — otestovat před během

- **Adresy `/sites/isms-*` volné** — úklid předchozího běhu včetně smazaných webů v koši
  a přesměrování; jinak SharePoint přidá číselnou příponu.
- Global Administrator může v SharePoint admin center založit komunikační web; aktuální název
  šablony bez ukázkového obsahu — **neověřeno na tenantu**, zapsat do labu.
- Pole **Name** v panelu *Add column* tvoří interní název beze změny a `Field=` v URL nastavení
  sloupce ho ukazuje — **neověřeno na tenantu**; při jiném chování upravit checkpointy 6–8.
- `Priority` a `DueDate` jsou i názvy vestavěných sloupců webu: ověřit, že nový sloupec seznamu
  má `Field=Priority` / `Field=DueDate`, ne `Priority0` — **neověřeno na tenantu**.
- Přidání skupiny zabezpečení `isms-<ini>-users` do *Members* komunikačního webu — **neověřeno
  na tenantu**.
- **Copy to** z OneDrive na web v témže tenantu — **neověřeno na tenantu**.
- Demo AI na B: Copilot PAYG zapnuté, rozpočtový alert nastavený, připravený fiktivní prompt.
- Skript `New-IsmsWorkspace.ps1` pro dohánějící — zatím plán; bez něj založit web ručně.

## Tripwires

- **Diakritika v poli Name.** Nejčastější chyba — „Požadavek" rovnou při založení. Checkpoint 8
  (`_x00`) to chytí; jedině smazat a založit znovu.
- **Přejmenování Title v nastavení webu místo v seznamu.** Mění se jen sloupec seznamu SoA.
- **Týmový web „protože to tak děláme".** Vrátit k rozhodnutí: jedna skupina pro PIM v D4.
- **Adresa s příponou `2`.** Nepokračovat — další dny počítají s `/sites/isms-<ini>`.
- **Skupina do Owners místo Members.** Členství v Owners by PIM v D4 obcházelo.
- **Odkaz v Důkaz do OneDrive** místo na web — checkpoint 9.
- **AI demo jako pravda.** Ukázat i chybu výstupu proti pevnému schématu; nepodporovat vkládání
  dat z A do čehokoli mimo tenant.

## Vazby

- Zpět: `requirements-mapping-m365` (sešit matice), `onboarding` (skupina, profil).
- Dopředu: každý blok D2–D5 zapisuje do SoA; `privileged-access-pim` (skupina v Members),
  `compliance-manager-capstone` (export SoA = přehled bezpečnostních opatření pro vedení).
