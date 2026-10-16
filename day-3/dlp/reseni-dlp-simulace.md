# Řešení · DLP politika v simulaci nad ISMS webem

Referenční nastavení k [`lab-dlp-simulace.md`](lab-dlp-simulace.md). Totéž nastavení používá
lektor pro `LEKTOR-DLP-demo` na lektorském webu (T−2 dny).

## A. Nastavení politiky

| Část | Hodnota | Proč |
|---|---|---|
| Name | `<ini>-DLP-ISMS-osobni-udaje` | prefix iniciál = vlastník je dohledatelný při úklidu |
| Admin units | Full directory | administrativní jednotky se v kurzu nepoužívají |
| Locations | jen SharePoint sites, *Included* = `/sites/isms-<ini>` | DLP v SharePointu se zahrnuje po webech; nic mimo vlastní scope |
| Rule | `<ini>-DLP-RC-nebo-stitek` | |
| Conditions | Content contains, Any of these: sensitivity labels `<ini>-ISMS důvěrné`, Důvěrné \ Vltava; SIT Czech personal identity number (1+) | štítek = deterministická shoda; SIT = typ dat, který zná každá česká organizace |
| Actions | Restrict access → Block only people outside your organization | nejmenší akce, která dává smysl pro ISMS dokumentaci; sdílení uvnitř firmy zůstává |
| User notifications | On (policy tips) | uživatel se učí dřív, než přijde blokace |
| Incident reports | Low, upozornění sobě, každá shoda | v simulaci jen na kartě Alerts simulace |
| Mode | simulace + policy tips | kurzovní pravidlo |
| Auto turn on after 15 days | vypnuto | jinak by se politika zapnula týden po kurzu |

## B. Odpovědi na krok 8

1. V ostrém režimu by lidé mimo organizaci k dokumentu ztratili přístup; uživatel by viděl policy
   tip. Sdílení uvnitř organizace by fungovalo dál.
2. Falešné shody: desetimístná čísla s lomítkem v jiném významu (čísla smluv, zakázek, faktur),
   pokud náhodou projdou kontrolním součtem; SIT na střední spolehlivosti nepotřebuje klíčové
   slovo, proto je u čísel bez kontextu rizikovější.
3. Přepnutí do vynucení: vlastník procesu (ne IT) po vyhodnocení simulace za dohodnuté období,
   nejdřív s možností přepsání se zdůvodněním; rozhodnutí se zapíše jako změna v ISMS.

## C. Řádek SoA

| Opatření | Požadavek | Aplikovatelné | Zdůvodnění (vzor) | Capability M365 | Důkaz | Modul | Tenant |
|---|---|---|---|---|---|---|---|
| A.8.12 | vyhl. 410/2025 Sb. § 3 odst. 4 (podle mapovací matice `requirements-mapping-m365`) | ano | Únik řízené ISMS dokumentace a osobních údajů mimo organizaci se sleduje DLP politikou; politika je ve zkušebním (simulačním) provozu, přepnutí do vynucení schvaluje vlastník procesu. | Purview DLP, `<ini>-DLP-ISMS-osobni-udaje` nad `isms-<ini>` | snímek nastavení politiky + Simulation overview | `dlp` | A |

## D. Co se v auditu dne 4 může objevit

DLP aktivity se zapisují do auditu a do Activity exploreru
([Learn](https://learn.microsoft.com/en-us/purview/dlp-learn-about-dlp)). Activity explorer
filtruje *DLP rule matched* a *DLP rule undo*; přesný název operace DLP shody v Audit search
není v kurzu ověřený — **neověřeno na tenantu**, doplní dry-run.
