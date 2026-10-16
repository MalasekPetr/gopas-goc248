# Den 1 — Rámec a ISMS základy

Od zákona k prázdné kostře ISMS v tenantu. Večer má každý student přístup do obou tenantů,
mapovací matici „požadavek -> opatření -> capability Microsoft 365" s ověřenou licenční realitou
a na Tenant A web `isms-<ini>` se seznamem **SoA** v pevném schématu a prvními dvěma řádky.

| Pořadí | Blok | Slug | Typ | min | Tenant |
|---|---|---|---|---|---|
| 1 | Onboarding a přístup do obou tenantů, kde se v kurzu objeví AI | [`onboarding`](onboarding/) | P | 45 | A + B |
| 2 | NIS2 a ISO 27001 — rekapitulace pro Microsoft 365 | [`nis2-iso27001-fundamentals`](nis2-iso27001-fundamentals/) | P | 60 | — |
| 3 | Mapování požadavků na Microsoft 365 a licenční realita | [`requirements-mapping-m365`](requirements-mapping-m365/) | P | 75 | A |
| 4 | Návrh ISMS v Microsoft 365 | [`isms-design-m365`](isms-design-m365/) | P | 120 | A |

Celkem **300 min**.

> [!IMPORTANT] Ráno před prvním blokem
> Lektor rozdá účty pro **oba** tenanty (`jmeno.prijmeni@cloudedu.cz` a `user.NN@spdemo.online`)
> a dočasná hesla. Studenti potřebují **telefon s Microsoft Authenticatorem** — MFA se registruje
> na obou tenantech hned v prvním bloku.

## Kompresní ventily

Škrtá se odshora:

1. `nis2-iso27001-fundamentals` — legislativní rekapitulace jen jako tabulky: povinnosti,
   13 oblastí a přehled vs. SoA zůstávají; sekce „Incident: kdy běží 24 hodin" (přijde v D4)
   a „ISMS v kostce" vypadnou; papírový lab zůstává, protože stojí na zbylých tabulkách (−15).
2. `requirements-mapping-m365` — licenční matice jako hotová tabulka k přečtení
   ([`comparison-licence.md`](requirements-mapping-m365/comparison-licence.md)); v labu
   odpadá krok 2 (prohlídka licencí v Microsoft 365 admin center) a krok 4 se zkrátí na tři
   řádky matice místo šesti (−15).

**Nekrátit** `isms-design-m365` — workspace `isms-<ini>` a seznam SoA nesou celý týden; každý
další blok do SoA zapisuje. **Nekrátit** registraci MFA na Tenant B v `onboarding` — v úterý
uprostřed labu stojí 15 minut a celou skupinu.

> [!NOTE] Proč den vypadá takhle
> Den jde od přístupu přes právní rámec k mapování a končí jedinou věcí, na které stojí zbytek
> týdne: webem `isms-<ini>` se seznamem SoA. Právo je jen rekapitulace — GOC240 je předpoklad —
> a jeho úkolem je dodat **sloupec Požadavek**: které ustanovení vyhlášky č. 410/2025 Sb. které
> opatření plní. Licenční realita se ověřuje hned v pondělí, aby student u každého dalšího bloku
> věděl, co z toho jeho organizace s její licencí udělá. Na Tenant B se v pondělí jen přihlásí —
> pracovat se tam začne v úterý.
