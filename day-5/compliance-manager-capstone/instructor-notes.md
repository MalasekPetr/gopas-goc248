# Instructor notes — Compliance Manager a capstone

## Timing

- 10 min výklad (pojmy, proč jen netechnické akce, licence šablon, skóre) + 80 min lab:
  kroky 1–3 10 min, krok 4 5 min, krok 5 20 min, krok 6 5 min, krok 7 20 min, krok 8
  15 min (trojice paralelně: 3 × (3 + 2) min), krok 9 5 min.
- Capstone začíná **nejpozději ve 13:30** — den končí v 15:00.
- 15 obhajob po 3 min za sebou = 45 min + přechody, to se nevejde. Proto trojice
  paralelně, lektor obchází; dvě nejlepší obhajoby zopakovat před třídou, pokud zbude čas.
- Při skluzu: 3 důkazy místo 5, obhajoba 2 min. Obhajoby se nevypouštějí.

## Go/no-go — otestovat před během

- **Šablona ISO/IEC 27001:2022** na Tenant A, T−14 dní: stránka *Regulations*, čítač
  *Regulation licenses used*. Slot = šablona na tenant, ne assessment; drží se rok. Volné
  2 sloty = OK, jinak trial (25 šablon / 90 dní, do 48 h). Lektor den předem založí
  `LEKTOR-ISO27001-2022` ve skupině `LEKTOR-ISMS`. **Neověřeno na tenantu.**
- **NIS2** jen pokud zbývá další volný slot; jinak studentům NIS2 nezakládat.
- **Netechnické improvement actions** v šabloně ISO/IEC 27001:2022 existují u kontrol
  doporučených v kroku 2 (A.5.37, A.5.12, A.8.12, A.5.24–A.5.26, A.5.23). Ověřit na
  lektorském assessmentu a případně upravit doporučenou kostru v labu.
- Tvar *Control ID* a vyhledávání podle čísla opatření — ověřit a doplnit do labu.
- **Fallback Data Protection Baseline** do vlastní skupiny — ověřit, že jde založit bez
  prémiového slotu.
- **SoA studentů** mají odkazy ve sloupci Důkaz (namátkou 3 studenti ve čtvrtek odpoledne).
- **Export SoA -> Export to CSV** vrátí statický soubor (ne živé spojení `.iqy`) — jen ten
  je uchovatelná verze přehledu pro vedení. **Neověřeno na tenantu.**

## Tripwires

- **Technické akce.** Student přidá důkaz k technické akci -> změna se propíše do všech
  skupin a vypne se automatické testování té akce pro celý tenant. Kontrolovat obcházením
  při kroku 5.
- **Test status *Passed*.** Student si „odškrtne" kontrolu. Důkazy pak nejdou smazat
  a report vypadá jako atest. Vrátit: test status patří assessorovi.
- **„Copy data from an existing group"** při zakládání — zkopíruje cizí stav do vlastní
  skupiny.
- **Skupiny nejdou smazat.** Překlep v názvu skupiny zůstane v tenantu navždy — kontrolovat
  prefix před *Create assessment*.
- **Česká šablona Act No. 181** — předchozí zákon, ne 264/2025 Sb. Kdo ji najde, dostane
  pochvalu za ostražitost, ne slot.
- **„Skóre se nehnulo."** Propis do 24 h. Report uvádí stav k datu odečtu.
- **Obhajoba bez důkazu** — „máme DLP". Vrátit otázkou: „Který řádek SoA a kam vede odkaz?"
- **Report jako atest** — vyžadovat sekci 0 šablony doslova.

## Vazby

- Zpět: všechny bloky týdne — SoA z `isms-design-m365`, důkazy z D2–D5, licenční nit
  z `requirements-mapping-m365`, podklad pro hlášení z `audit-incident-response`.
- Dopředu: úklid — assessmenty `<ini>-*` smazat, skupiny `<ini>-ISMS` zůstanou (nejdou
  smazat), zapsat do úklidového seznamu.
