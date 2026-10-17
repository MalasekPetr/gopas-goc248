# Den 2 — Řízená ISMS dokumentace v SharePoint Online a Lists

Den vede od dokumentu k evidenci: řízená knihovna se schvalováním, typy obsahu s povinnými
metadaty a tři registry (Asset, Risk, Incident log). Večer má workspace `isms-<ini>` první
schválenou politiku, registry pro den 4 a capstone a v SoA řádky kap. 7.5, A.5.1, A.5.37,
A.5.9, kap. 6.1, kap. 8.2 a A.5.24 — včetně dvou dokladů z Tenant B (Autofill hands-on,
Skills z dema lektora).

| Pořadí | Blok | Slug | Typ | min | Tenant |
|---|---|---|---|---|---|
| 1 | Knihovny jako úložiště řízené dokumentace | [`document-libraries-governance`](document-libraries-governance/) | P | 100 | A |
| 2 | Content Type Hub a standardizace politik, Autofill columns | [`content-type-hub`](content-type-hub/) | P | 80 | A + B |
| 3 | Lists jako živé evidence a workflow, Skills | [`lists-registers-workflow`](lists-registers-workflow/) | P | 120 | A + B |

Celkem **300 min**.

## Kompresní ventily

Škrtá se odshora:

1. Autofill columns v `content-type-hub` jako demo lektora — kroky 6–9 labu
   [`lab-typy-obsahu-autofill.md`](content-type-hub/lab-typy-obsahu-autofill.md); řádek 7.5
   pro Tenant B s odkazem na lektorovu knihovnu (−20).
2. Demo Skills v `lists-registers-workflow` jen kroky 4 a 6
   [`demo-skill-kontrola-dokumentace.md`](lists-registers-workflow/demo-skill-kontrola-dokumentace.md);
   zápis do SoA dělají všichni (−10).

**Nekrátit** registry v `lists-registers-workflow` — Risk Register a Incident log používá den 4
i capstone; schéma Incident logu je pevné.

> [!NOTE] Dramaturgie: dokument -> metadata -> evidence, dvakrát A -> B -> A
> První blok je celý na **Tenant A**: knihovna `ControlledDocs` a první politika schválená někým
> jiným, než kdo ji napsal. Druhý blok `content-type-hub` jde **A -> B -> A**: typy obsahu se
> publikují na začátku, během Autofill na B mají čas dorazit a na konci se na A připojí ke
> knihovně (nebo nastoupí lokální fallback). Poslední blok je hands-on jen na A: registry na A,
> Skill nad kopií dokumentace na B předvádí lektor (Skills vyžadují licenci Microsoft 365
> Copilot, studentské účty na B ji nemají) a studenti zapisují do SoA na A. Každé přepnutí má v labu vlastní
> checkpoint „správný účet ve správném profilu". SoA se zapisuje **vždy na A**; z B se dokládá
> odkazem a screenshotem. Den 3 navazuje na `ControlledDocs` štítky, DLP a retencí; Incident log
> naplní den 4.
