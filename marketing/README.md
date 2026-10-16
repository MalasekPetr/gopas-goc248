# Marketing — rozdíl proti katalogové stránce

Katalogová stránka
[GOC248](https://www.gopas.cz/postavte-si-isms-v-microsoft-365-prakticky-kurz-pro-nis2-a-iso-iec-27001_goc248)
je publikovaná (stav 2026-10-17). Tento soubor drží jen **rozdíly** mezi stránkou a obsahem
kurzu v repu — jako podklad pro editora GOPAS. Celý text stránky se nepřepisuje.

## Delta tabulka

| Na stránce | V kurzu | Navrhovaná úprava textu | Priorita |
|---|---|---|---|
| „PIM a Identity Protection pro privilegovaný přístup" | Risk-based politiky jsou v bloku Conditional Access; legacy risk politiky ID Protection byly vyřazeny k 2026-10-01 | „Conditional Access: návrh politik, MFA, break-glass účty **a politiky založené na riziku**" a „PIM pro privilegovaný přístup, ID Protection jako zdroj rizika" | střední — věcná přesnost |
| „Lab: konfigurace PIM pro privilegované role" | Hands-on přes PIM for Groups (vlastní skupina studenta); PIM pro role Entra jako demo lektora | „Lab: just-in-time přístup přes PIM" | nízká |
| „Purview DSPM for AI" | Purview sloučil DSPM a DSPM for AI do jednoho prostředí | „Purview Data Security Posture Management (DSPM) pro AI" | nízká — název v UI |
| „Onboarding a přístup do tenantu" | Dva tenanty: ISMS a Purview na jednom, Copilot a agenti na druhém | beze změny; případně „přístup do kurzovních tenantů" | nízká |
| „NIS2 (264/2025 Sb.) a ISO 27001:2022 — role NÚKIB, lhůty, sankce" | Rekapitulace (60 min) — právní výklad je předpoklad GOC240 | beze změny; předpoklad GOC240 už stránka uvádí | — |
| Předpoklady GOC240 a GOC222 | Kurz s nimi počítá | beze změny | — |

## Co na stránce chybí a stálo by za doplnění

- **Licenční upozornění.** Část funkcí kurzu (automatické štítkování, PIM, risk-based CA,
  rozšířené šablony Compliance Manageru) vyžaduje E5, E5 Compliance nebo Entra ID P2.
  Kurz u každého bloku říká, co zvládne Business Premium a E3 — stránka by to měla slíbit
  výslovně, aby účastník s E3 nečekal, že si vše zapne doma.
- **Výstupy pro účastníka.** Vzor ISMS workspace se SoA, šablona podkladu pro prvotní hlášení
  incidentu, šablona reportu stavu souladu.
- **Co kurz neslibuje.** Report z capstonu je podklad pro vedení a auditora, ne atest souladu
  s NIS2 ani certifikace ISO 27001.

> [!WARNING] Ověřit k datu běhu — stav k 2026-10.
> Licenční tvrzení pro stránku převzít až z ověřené licenční tabulky v
> [`../GLOSSARY.md`](../GLOSSARY.md), ne z tohoto souboru.
