# Řešení · Dohledání události v auditu a podklad pro hlášení

Referenční řešení k [`lab-incident-evidence.md`](lab-incident-evidence.md). **Žádné vzorové
auditní záznamy, IP adresy ani časy** — lab nebyl na Tenant A zatím odzkoušen a výsledky se
zapisují jen z běhu. Tady je logika rozhodování, mapování polí a řádky SoA.

## Událost, nebo incident (A3)

Stopa z dne 3: uživatel stáhl řízenou Politiku, **snížil její štítek citlivosti na Veřejné**
se zdůvodněním, vytvořil k ní **odkaz ke sdílení** (typicky pro celou organizaci) a zkusil
smazat záznam `ZAZ-01` (zablokováno retenčním štítkem).

- Neplánované? Ano — žádná schválená změna ani servisní okno.
- Narušení důvěrnosti, integrity nebo dostupnosti? **Důvěrnost je ohrožená**: dokument bez
  ochrany štítku a s odkazem ke sdílení může číst někdo, kdo nemá. Pokus o smazání záznamu je
  pokus o narušení integrity (zablokovaný = bez dopadu).
- V kybernetickém prostoru? Ano — vše proběhlo v Microsoft 365.

**Závěr:** obhajitelný závěr je **incident** (definice podle podpůrného materiálu NÚKIB v1.2:
neplánované narušení důvěrnosti, integrity nebo dostupnosti). Obhajitelný je i závěr
„událost", **pokud** student doloží, že odkaz nikdo nepoužil (operace typu `...LinkUsed`
v auditu chybí) a dokument neopustil organizaci — pak jde o potenciál, ne narušení. Rozhoduje
zdůvodnění, ne slovo.

## Hlásí se? (A4)

| Podmínka | Typické vyhodnocení | Proč |
|---|---|---|
| 1. stanovený rozsah | ano | ISMS dokumentace je v rozsahu řízení kybernetické bezpečnosti Vltava Servis (scénář) |
| 2. kyberprostor | ano | Microsoft 365 |
| 3. úmysl nelze vyloučit | ano | snížení štítku se zdůvodněním a vytvoření odkazu jsou vědomé kroky |
| 4. významný dopad | **ne** (typicky) | viz A5 |
| Závěr | **nehlásí se** povinně; záznam v Incident logu, řešení interně; dobrovolné hlášení možné | |

## Významnost (A5) — vzorové zdůvodnění

Únosná míra újmy (fiktivní hodnoty ze šablony): jeden dokument, žádná doložená finanční ztráta,
žádná nedostupnost, dotčené osoby v řádu jednotek → **únosná míra újmy nepřekročena**.
Oblasti: provozní dopad 1, množství osob 1, zdroje k obnově 1–2, typ aktiva 1–2 (řízená
dokumentace, ne infrastruktura), citlivost 2–3 (podle obsahu dokumentu a štítku), příčina 2
(úmyslné jednání uživatele bez konkrétního cíle). Protože pravidlo vyžaduje překročení únosné
míry **a zároveň** prahu oblastí, **významný dopad = ne**.

Kdy by se to otočilo: dokument obsahuje osobní údaje celé firmy (citlivost 3), odkaz je
anonymní a audit ukazuje jeho použití zvenku (`AnonymousLinkUsed`), počet dotčených osob
překročí únosnou míru → významný dopad ano → prvotní hlášení do 24 h, oznámení do 72 h.

## Incident log — vzorové hodnoty polí

| Pole | Vzor |
|---|---|
| Název | `<ini>-INC-01 Snížení štítku a sdílení řízeného dokumentu` |
| Zjištěno (DetectedAt) | čas, kdy student záznamy uviděl v kroku 4 |
| Vyhodnoceno jako incident (ClassifiedAt) | čas rozhodnutí v kroku 6 |
| Lhůta prvotního hlášení (ReportDeadline) | ClassifiedAt + 1 den (vypočtené) |
| Významný dopad (Significant) | *ne* (nebo *ano* se zdůvodněním) |
| Kritérium významnosti (SignificanceBasis) | „Únosná míra újmy nepřekročena (1 dokument, bez ztráty, bez nedostupnosti); nejvyšší oblast citlivost 2–3. Podle § 14 vyhl. 410/2025 Sb. a metodiky Vltava Servis bez významného dopadu." |
| Dotčená aktiva (AffectedAssets) | aktivum z Asset Registeru pro knihovnu Řízená dokumentace |
| Stav (Status) | *V řešení* (ne *Nahlášeno*) |
| Podklad pro hlášení (ReportDraft) | odkaz na `<ini>-INC-01 Podklad pro hlášení` |
| Důkazy (Evidence) | odkaz na CSV z auditu |

## Část B — vzor obsahu povinných polí

- **Typ incidentu:** *Jiný typ incidentu* (žádný z ostatních typů neodpovídá).
- **Popis incidentu:** kdo (účet), co (stažení, snížení štítku, odkaz ke sdílení, pokus o
  smazání), kde (web a knihovna), kdy (UTC), jak zjištěno (Purview Audit).
- **Fáze:** *incident byl identifikován* nebo *probíhá omezení šíření* (pokud už byl odkaz
  zrušen a štítek vrácen).
- **Dopad:** *dopad pouze na organizaci*.
- **Služby během incidentu:** *ano, všechny služby byly dostupné*.
- **Přijatá opatření:** zrušení odkazu, obnovení štítku, revize oprávnění účtu.
- **Policie ČR:** *ne*.

## Řádky SoA

| Opatření | Aplikovatelné | Zdůvodnění (vzor, piš vlastní) | Capability M365 | Důkaz | Modul |
|---|---|---|---|---|---|
| A.5.24 | ano | Existuje evidence incidentů a připravená struktura podkladu s lhůtami podle NÚKIB. | Incident log, šablona podkladu | odkaz na šablonu | `audit-incident-response` |
| A.5.25 | ano | Událost byla vyhodnocena podle definice a významnost posouzena podle § 14 vyhl. 410/2025 Sb. | Incident log (ClassifiedAt, Significant) | položka `<ini>-INC-01` | `audit-incident-response` |
| A.5.26 | ano | Reakce má podklad pro hlášení připravený do 24 h od zjištění a stav záznamu. | podklad pro prvotní hlášení | odkaz na podklad | `audit-incident-response` |
| A.5.28 | ano | Důkazy jsou exportované z auditu a uložené v tenantu s omezeným přístupem. | Purview Audit export | odkaz na CSV | `audit-incident-response` |
| A.8.15 | ano | Aktivity uživatelů a správců se zaznamenávají; retence 180 dní (Standard) nebo 1 rok (Premium) — rozhoduje licence. | Purview Audit | odkaz na CSV | `audit-incident-response` |
| A.8.16 | ano | Aplikovatelné, ale zavedené jen zčásti: audit umožňuje zpětné dohledání, průběžné sledování a výstrahy (Defender XDR, alert policies) v kurzu nastavené nejsou — mezera pro capstone. | Purview Audit, Defender XDR (přehled) | odkaz na podklad pro hlášení (A2: jak byla událost zjištěna) | `audit-incident-response` |

Vlastní parafráze účelu opatření (ne text normy): **A.5.24** — kdo co dělá, když nastane
incident, je jasné dřív, než nastane; **A.5.25** — u každé podezřelé události padne doložitelné
rozhodnutí, zda jde o incident; **A.5.26** — reakce na incident se řídí připraveným postupem,
ne improvizací; **A.5.28** — stopy po incidentu se zajistí tak, aby jim šlo věřit i později;
**A.8.15** — organizace má z čeho zpětně zjistit, kdo co kdy v systémech udělal; **A.8.16** —
neobvyklé dění se má zachytit průběžně, ne až při pátrání po incidentu.
