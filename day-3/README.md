# Den 3 — Klasifikace a Information Protection

Den tří pilířů Microsoft Purview nad ISMS workspace. Večer má knihovna „Řízená dokumentace"
ve webu `isms-<ini>` výchozí sensitivity label, na webu běží DLP politika v simulaci, záznamy
jsou prohlášené retenčním štítkem za record a web má retenční politiku. V SoA přibudou řádky
A.5.12, A.5.13, A.8.12, A.5.33 a A.8.10 — a v poznámce každého studenta leží časy čtyř akcí,
které den 4 dohledá v auditu.

| Pořadí | Blok | Slug | Typ | min | Tenant |
|---|---|---|---|---|---|
| 1 | Klasifikace a sensitivity labels v Purview | [`sensitivity-labels`](sensitivity-labels/) | P | 110 | A |
| 2 | Data Loss Prevention napříč Microsoft 365 | [`dlp`](dlp/) | P | 90 | A |
| 3 | Retence, lifecycle a records management, srovnání se SAM | [`retention-lifecycle`](retention-lifecycle/) | P | 100 | A |

Celkem **300 min**.

> [!IMPORTANT] Den stojí na přípravě lektora, ne na rychlosti propagace
> Label policy se podle Learn propisuje až 24 h (se změnou členství ve skupině 24–48 h),
> publikovaný retenční štítek „obvykle do jednoho dne, počítejte až se sedmi dny". Nic, co
> student ve středu vytvoří, proto nesmí být podmínkou pro další krok téhož dne. Laby stojí na
> **kurzovních objektech, které lektor publikoval předem** (taxonomie štítků, kurzovní záznamový
> štítek) — postup v [`sensitivity-labels/guide-priprava-tenantu.md`](sensitivity-labels/guide-priprava-tenantu.md).
> Vlastní objekty studenta se staví, dokládají do SoA a ověřují ráno dne 4.

## Kompresní ventily

Škrtá se odshora:

1. Auto-labeling v `sensitivity-labels` jen výklad — krok 9 labu (auto-labeling politika
   v simulaci) odpadá (−15).
2. Vyšetření DLP shody v `dlp` jako demo lektora — kroky 6 a 7 labu (simulace, Activity
   explorer, upozornění) ukáže lektor na své politice (−15).
3. Srovnání se SAM v `retention-lifecycle` jen tabulkou z README, bez dema (−10). Pokud tenant
   SAM nemá (viz go/no-go), platí tento ventil automaticky a uvolněných 10 min jde do kroku
   „Připrav stopu pro zítřek".

**Nekrátit** štítky na ISMS knihovně (kroky 4–7 v `sensitivity-labels`) — DLP i Copilot
governance v pátek na nich stojí. **Nekrátit** krok „Připrav stopu pro zítřek"
v `retention-lifecycle` — `audit-incident-response` ve čtvrtek hledá právě tyto události.

> [!NOTE] Tři pilíře = tři otázky
> Den je postavený na jednom rozlišení: **jak je to klasifikované** (Information Protection,
> `sensitivity-labels`), **co nesmí odejít** (DLP, `dlp`) a **jak dlouho se to drží** (Data
> Lifecycle Management, `retention-lifecycle`). Pořadí není náhodné — DLP pravidlo používá štítek
> z prvního bloku jako podmínku a retence přidává k témuž dokumentu druhý, nezávislý štítek
> (retenční). Den končí stopou pro čtvrtek: `test-<ini>` stáhne označený dokument, sníží mu
> štítek, nasdílí ho a zkusí smazat záznam. Klasifikace, únik a retence se tak ve čtvrtek potkají
> v jednom auditním záznamu incidentu.
