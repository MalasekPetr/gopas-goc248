# Den 4 — Identita, detekce a incidenty

Den vede jednou otázkou ve třech vrstvách: **kdo se dostane dovnitř** (Conditional Access),
**kdo smí víc a na jak dlouho** (PIM) a **co uděláme, když se něco stane** (audit a podklad pro
hlášení incidentu). Po dni má workspace `isms-<ini>` sadu CA politik a PIM skupinu pro vlastní
web, záznam incidentu v Incident logu s podkladem z auditu a v SoA řádky A.5.15, A.5.17, A.5.18,
A.8.2, A.8.5, A.5.24–A.5.26, A.5.28, A.8.15 a A.8.16.

Celý den běží na **Tenant A**. Studenti jsou Global Administrator — **jedna chybně zacílená CA
politika zamkne celou učebnu včetně lektora.** Pravidla v
[`../CONVENTIONS.md`](../CONVENTIONS.md#dva-tenanty--tenantová-disciplína) dnes neplatí „obecně",
ale doslova.

| Pořadí | Blok | Slug | Typ | min | Tenant |
|---|---|---|---|---|---|
| 1 | Conditional Access a řízení přístupu, risk-based politiky | [`conditional-access`](conditional-access/) | P | 100 | A |
| 2 | Privilegovaný přístup — PIM | [`privileged-access-pim`](privileged-access-pim/) | P | 90 | A |
| 3 | Detekce, audit a podklad pro hlášení incidentu | [`audit-incident-response`](audit-incident-response/) | P | 110 | A |

Celkem **300 min**.

## Kompresní ventily

Škrtá se odshora:

1. Risk-based politiky v [`conditional-access`](conditional-access/) jen vytvořit v report-only,
   bez vyhodnocení: všechny čtyři politiky vzniknou, ve What If (krok 6 labu) proběhnou jen běhy
   a a e — **−15 min**.
2. Schvalovací tok aktivace v [`privileged-access-pim`](privileged-access-pim/) jako demo lektora
   na projektoru: studenti nastaví eligible přiřazení bez schválení a aktivují rovnou — **−15 min**.

**Nekrátit** `audit-incident-response` — podklad pro hlášení a záznam v Incident logu jdou
do capstonu ([`../day-5/compliance-manager-capstone/`](../day-5/compliance-manager-capstone/)).

> [!NOTE] Dramaturgie dne
> Pořadí je oblouk „dveře → klíče od serverovny → kamera". Conditional Access je první, protože
> MFA pilot na `test-<ini>` ověří, že testovací uživatel má funkční MFA metodu (nebo Temporary
> Access Pass) — PIM ji o hodinu později potřebuje pro aktivaci členství. PIM končí
> **nálezem** „všichni v kurzu jsme Global Administrator" — a audit odpoledne ukáže, že se každý
> takový krok dá dohledat. Audit dne 4 pracuje se stopou, kterou student **včera** záměrně
> zanechal na konci [`../day-3/retention-lifecycle/`](../day-3/retention-lifecycle/): události
> potřebují čas na ingest a ráno už musí být ve vyhledávání.
