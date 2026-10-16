# Šablona · Report stavu souladu

> Modul: `compliance-manager-capstone` · Vyplňuje: student · Rozsah: 2 strany
> Uložit jako `<ini>-Report-stavu-souladu` ve workspace `isms-<ini>` na Tenant A.

Pokyny k vyplnění jsou v kurzívě — při psaní je nahraď vlastním textem. Každé tvrzení
o zavedeném opatření má odkaz na řádek SoA nebo na důkaz. Text normy ISO/IEC 27001 se
necituje — jen číslo opatření a vlastní parafráze.

---

## 0. Povaha dokumentu

Tento report je **podklad pro vedení a pro auditora** o stavu zavedení opatření ISMS
k datu uvedenému níže. **Není** atestem souladu se zákonem č. 264/2025 Sb. a vyhláškou
č. 410/2025 Sb. ani certifikací podle ISO/IEC 27001. Compliance score z Microsoft Purview
Compliance Manager je metrika pokroku v doporučených akcích, nikoli doklad souladu.

| | |
|---|---|
| Organizace | Vltava Servis s.r.o. (fiktivní) |
| Zpracoval(a) | *jméno, role v ISMS* |
| Datum stavu | *RRRR-MM-DD* |
| Pro koho | *vedení / auditor / manažer kybernetické bezpečnosti* |

## 1. Rozsah ISMS

*Co ISMS pokrývá: organizace, služby, lokality, systémy. Co výslovně nepokrývá a proč.
Dva až tři řádky.*

## 2. Režim a rámec

*Režim povinností podle zákona č. 264/2025 Sb. (u Vltava Servis: nižší povinnosti, opatření
podle vyhlášky č. 410/2025 Sb.). Rámec zavedení: ISO/IEC 27001:2022, Annex A. Jedna věta,
proč tato kombinace.*

## 3. Souhrn SoA

| Ukazatel | Počet |
|---|---|
| Řádků SoA celkem | |
| Aplikovatelné = ano | |
| Aplikovatelné = ne (se zdůvodněním) | |
| Řádky s funkčním odkazem ve sloupci Důkaz | |
| Řádky s důkazem z Tenant B (odkaz + screenshot) | |

## 4. Stav zavedení

*Rozděl aplikovatelná opatření do tří skupin. U každého: číslo opatření, capability
Microsoft 365, odkaz na řádek SoA. U navázaných v Compliance Manageru přidej název akce
`<ini>-...` v assessmentu `<ini>-ISO27001-2022`.*

### 4.1 Zavedeno a doloženo

| Opatření | Capability M365 | Důkaz (SoA) | Navázáno v Compliance Manageru |
|---|---|---|---|
| | | | ano / ne |

### 4.2 Částečně zavedeno

*Typicky: politika v simulaci, CA v režimu report-only, pilot na jedné skupině. Napiš, co
chybí do plného zavedení.*

| Opatření | Co je hotové | Co chybí | Kdo rozhoduje |
|---|---|---|---|
| | | | |

### 4.3 Nezavedeno

| Opatření | Proč | Plán |
|---|---|---|
| | | |

### 4.4 Stav v Compliance Manageru

| | |
|---|---|
| Assessment | `<ini>-ISO27001-2022`, skupina `<ini>-ISMS` |
| Navázaných důkazů | *počet* |
| Progress / stav kontrol k datu odečtu | *čísla z kroku 6 labu, datum a čas* |
| Technické akce citované bez zásahu | *seznam* |

## 5. Mezery a co by stály

*Aspoň 3 mezery. U každé: co chybí, dopad, a co by bylo potřeba — licence, práce nebo
rozhodnutí vedení. Licenci uváděj podle sekce Licence v modulech kurzu, ne odhadem.*

| Mezera | Dopad | Potřebná licence | Potřebná práce / rozhodnutí |
|---|---|---|---|
| | | *např. Business Premium -> E5 / add-on* | |

## 6. Připravenost na incident

*Z bloku `audit-incident-response`: je postup hlášení? Je záznam v Incident logu
s podkladem z auditu? Za jak dlouho jste dohledali událost (s datem měření)? Co by
chybělo pro prvotní hlášení do 24 hodin od vyhodnocení události jako incidentu?*

## 7. Governance AI

*Z bloků dne 5: agent v tenantu a jeho evaluace (skóre, negativní test), pravidlo `SME-02`,
hodnocení hotového agenta (verdikt), politika DLP pro Copilot (stav), kdo v tenantu
schvaluje agenty. Jedna věta k shadow AI: jak organizace ví, že se nepoužívá.*

## 8. Otevřená rizika

*Aspoň 2. Odkaz na Risk Register, pokud tam riziko je.*

| Riziko | Vlastník | Navržené ošetření | Termín |
|---|---|---|---|
| *např. všichni administrátoři jsou Global Administrator* | | | |

## 9. Doporučení vedení

*Tři body, seřazené podle priority. Každý s vlastníkem a termínem.*

1. *doporučení — vlastník — termín*
2. *doporučení — vlastník — termín*
3. *doporučení — vlastník — termín*
