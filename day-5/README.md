# Den 5 — AI a důkazování souladu

Den vede od agenta nad vlastní dokumentací (Tenant B) přes hodnocení hotového agenta a politiky
pro Copilot až k důkazům v Compliance Manageru (Tenant A). Po dni má student v SoA řádky
za AI governance (A.5.23, A.8.12, A.5.12, kap. 9.1) a za ověřování souladu (A.5.36), assessment `<ini>-...` s navázanými důkazy
a **report stavu souladu** obhájený před skupinou.

| Pořadí | Blok | Slug | Typ | min | Tenant |
|---|---|---|---|---|---|
| 1 | AI agenti uvnitř tenantu | [`ai-agents-tenant`](ai-agents-tenant/) | P | 90 | B |
| 2 | Hotový agent z Microsoft Marketplace — Normiqa Navigator | [`normiqa-navigator-demo`](normiqa-navigator-demo/) | P | 30 | B |
| 3 | Governance Copilotu a řízení rizik AI | [`copilot-governance-dspm`](copilot-governance-dspm/) | P | 60 | A + B |
| 4 | Compliance Manager a capstone | [`compliance-manager-capstone`](compliance-manager-capstone/) | P | 90 | A |

Celkem **270 min**. Den končí v 15:00 — capstone začíná **nejpozději ve 13:30**.

## Kompresní ventily

Škrtá se odshora:

1. `normiqa-navigator-demo` zkrátit na srovnávací tabulku bez živé instalace — studenti
   vyplní hodnoticí šablonu nad listingem, který lektor ukáže, ne nad nainstalovaným
   agentem (−15).
2. DSPM v `copilot-governance-dspm` jen prohlídka bez vyhodnocení — lektor projde stránky
   DSPM, studenti nic nevyplňují (−15).

**Nekrátit** `compliance-manager-capstone` — je to jediné místo, kde se SoA z celého týdne
mění v důkazy a report pro vedení. Když se den zpozdí, krátí se ventily výš, ne obhajoby.

> [!NOTE] Dramaturgie — přepnutí tenantu B -> A před capstonem
> Dopoledne běží na **Tenant B** (Copilot PAYG, student jen vlastník webu): vlastní agent,
> pak hotový agent hodnocený stejnými kritérii. `copilot-governance-dspm` je kloub dne —
> lektor na B ukáže, co Copilot nad daty skutečně vidí, a studenti pak **na Tenant A**
> (Purview, Global Administrator) nastaví politiku DLP pro Copilot. Od té chvíle se
> zůstává na A až do konce dne. Přepnutí profilu prohlížeče má vlastní checkpoint —
> Global Administrator ve špatném okně je reálný dopad. Z Tenant B se do SoA na A nic
> nekopíruje: jen odkaz a screenshot
> ([`../scenario-isms-vltava.md`](../scenario-isms-vltava.md)).

> [!WARNING] Ověřit k datu běhu — stav k 2026-10.
> Copilot PAYG na Tenant B nemá tvrdý strop — rozpočet v Microsoft 365 admin center jen
> posílá upozornění. Go/no-go položky dne jsou v `instructor-notes.md` každého bloku
> a v [`../environment.md`](../environment.md).
