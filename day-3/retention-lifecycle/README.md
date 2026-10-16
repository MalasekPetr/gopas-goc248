# Retence, lifecycle a records management, srovnání se SAM

> Typ: povinný · Den: 3 · Odhad: 100 min
> Tenant: A `cloudedu.cz` · Režim: hands-on, vlastní scope; SAM jako instruktorské demo (podmíněně)
> Prostředí: [`../../environment.md`](../../environment.md) · Názvosloví: [`../../GLOSSARY.md`](../../GLOSSARY.md)

Třetí pilíř a třetí otázka dne: **jak dlouho se to drží.** ISO 27001 chce záznamy chránit před
ztrátou a zfalšováním (A.5.33) a informace, které už nejsou potřeba, mazat (A.8.10). Purview Data
Lifecycle Management a Records Management dělají obojí — a obojí funguje i proti uživateli
a proti administrátorovi. Blok končí krokem, na kterém stojí čtvrtek: **stopou pro audit**.

## Cíle

- Rozlišit retenční politiku a retenční štítek a vybrat, co kam patří v ISMS.
- Prohlásit dokument za záznam (record) a vysvětlit, proč v kurzovním tenantu nikdy regulatory
  record.
- Popsat Preservation Hold library a disposition review.
- Vytvořit retenční štítek, label policy a retenční politiku scopované jen na vlastní web.
- Odlišit SAM site lifecycle (weby) od Purview Data Lifecycle Management (obsah).
- Připravit časově zaznamenanou stopu pro dohledání v auditu ve čtvrtek.
- Zapsat do SoA řádky A.5.33 a A.8.10.

## Výklad

### Retenční politika vs. retenční štítek

| Schopnost | Retenční politika | Retenční štítek |
|---|---|---|
| Kam se aplikuje | lokace (weby, schránky, skupiny) | položka (dokument, e-mail, položka seznamu) |
| Ruční aplikace uživatelem | ne | ano |
| Zůstane při přesunu obsahu | ne | ano, v rámci tenantu |
| Prohlášení za záznam | ne | ano |
| Počátek retence od označení nebo události | ne | ano |
| Disposition review | ne | ano |
| Položky seznamů (Lists) | **ne** | ano |

Zdroj: [Learn: retention](https://learn.microsoft.com/en-us/purview/retention),
[Learn: retention for SharePoint](https://learn.microsoft.com/en-us/purview/retention-policies-sharepoint).
Pro ISMS z toho plyne vzor: **politika na celý web jako spodní hranice + štítek „záznam" na
konkrétní záznamy** (schválené politiky, záznamy o přezkoumání, položky Incident logu). Incident
log je seznam — retenční politika ho nepokryje, jen štítek.

### Principy retence — co vyhraje

1. **Retence vyhrává nad smazáním.** Obsah pod retencí může z pohledu uživatele „zmizet", ale
   trvale smazaný není.
2. **Nejdelší retence vyhrává.**
3. **Pro smazání vyhrává explicitní nad implicitním**: smazání ze štítku má přednost před
   smazáním z politiky; politika se zahrnutými konkrétními weby před politikou na celou lokaci.
4. **Nejkratší lhůta smazání vyhrává**, když předchozí pravidla nerozhodla.

Zdroj: [Learn: principles of retention](https://learn.microsoft.com/en-us/purview/retention).

### Preservation Hold library

Když uživatel upraví nebo smaže obsah pod retencí, SharePoint uloží originál do skryté
**Preservation Hold library** webu. Není určená k práci uživatele — obsah z ní se dohledává
nástroji compliance (eDiscovery). Časovač ji prochází jednou za sedm dní a obsah starší než
30 dní, jehož retence skončila, posílá přes druhostupňový koš ke smazání — celkem tedy až 37 dní
plus 93 dní koše. Mazat knihovnu, seznam nebo web pod retencí uživatel nemůže
([Learn](https://learn.microsoft.com/en-us/purview/retention-policies-sharepoint)).

### Record vs. regulatory record

| Akce | Retenční štítek | Record — zamčený | Record — odemčený | Regulatory record |
|---|---|---|---|---|
| Upravit obsah | ano | **ne** | ano | **ne** |
| Upravit vlastnosti | ano | ano (lze tenantově zakázat) | ano | **ne** |
| Smazat | ano (lze tenantově zakázat) | **ne** | **ne** | **ne** |
| Změnit / odebrat štítek | ano | jen správce kontejneru | **ne** | **ne** |

Zdroj: [Learn: records management](https://learn.microsoft.com/en-us/purview/records-management).
U záznamu v SharePointu funguje **record versioning**: odemčením se poslední verze zkopíruje do
složky Records v Preservation Hold library, dokument jde upravit a znovu zamknout
([Learn](https://learn.microsoft.com/en-us/purview/record-versioning)).

> [!IMPORTANT] Proč v kurzu nikdy regulatory record
> Regulatory record po aplikaci **nikdo, ani Global Administrator**, neodstraní; retenci štítku
> nejde zkrátit, jen prodloužit. Volba je proto skrytá a zapíná se PowerShellem
> (`Set-RegulatoryComplianceUI`). Na sdíleném kurzovním tenantu by jeden omyl zablokoval úklid
> navždy. Totéž platí pro **Preservation Lock** retenční politiky
> ([Learn: declare records](https://learn.microsoft.com/en-us/purview/declare-records),
> [Learn: retention](https://learn.microsoft.com/en-us/purview/retention)).

### Disposition review

Na konci retence může štítek místo smazání spustit **kontrolu likvidace**: určení recenzenti
(až 10 uživatelů nebo poštovních bezpečnostních skupin na fázi, až 5 fází) dostanou e-mail
a v Purview rozhodnou — schválit likvidaci, přeznačit, prodloužit. Schválená položka se smaže do
15 dnů. Volitelné automatické schválení 7–365 dní. Recenzent potřebuje roli **Disposition
Management** — Global Administrator ji ve výchozím stavu **nemá**. Smazání záznamů je doložitelné
(proof of disposition) ([Learn: disposition](https://learn.microsoft.com/en-us/purview/disposition)).

### Statické a adaptivní scopes

Kurz používá **statický scope** — výčet webů. Adaptivní scope vybírá weby, uživatele a skupiny
dotazem nad atributy a vyžaduje E5 / E5 IPG; v kurzu jen zmínka
([service description](https://learn.microsoft.com/en-us/office365/servicedescriptions/microsoft-365-service-descriptions/microsoft-365-tenantlevel-services-licensing-guidance/microsoft-purview-service-description)).

> [!WARNING] Statický scope a typ webu
> Lokace **SharePoint classic and communication sites** pokrývá komunikační weby a týmové weby
> **bez** skupiny Microsoft 365. Týmový web připojený ke skupině se vybírá v lokaci **Microsoft 365
> Group mailboxes & sites**. A když z výčtu zahrnutých webů odeberete poslední položku, lokace se
> vrátí na **All** — politika pak platí pro celý tenant
> ([Learn: retention settings](https://learn.microsoft.com/en-us/purview/retention-settings)).

> [!WARNING] Ověřit k datu běhu — latence až 7 dní.
> Retenční politiky a publikované retenční štítky: „allow up to seven days"; štítky publikované do
> SharePointu „typically appear within one day"
> ([Learn: retention](https://learn.microsoft.com/en-us/purview/retention),
> [Learn: publish retention labels](https://learn.microsoft.com/en-us/purview/create-apply-retention-labels)).
> Proto lab prohlašuje záznamy **kurzovním štítkem publikovaným lektorem předem**; studentské
> objekty se staví a ověřují ve čtvrtek.

### SAM site lifecycle vs. Purview Data Lifecycle Management

> [!IMPORTANT] Nezaměňovat — dvakrát „lifecycle"
> SAM řídí **weby** (žijí? mají vlastníka?), Purview DLM řídí **obsah** (jak dlouho se drží, kdy
> se smí smazat). Stejné slovo, jiný objekt správy.

| | SharePoint Advanced Management — site lifecycle | Purview Data Lifecycle Management / Records |
|---|---|---|
| Objekt | web jako celek | dokument, e-mail, položka, záznam |
| Otázka | je web ještě potřeba a má odpovědného vlastníka? | jak dlouho se obsah musí držet a kdy se smí smazat? |
| Nástroje | inactive site policy, site attestation, site ownership policy | retenční politika, retenční štítek, record, disposition review |
| Kdo jedná | vlastník webu potvrzuje e-mailem (certify / attest) | systém drží a maže; recenzent schvaluje likvidaci |
| Vynucení | po třech měsíčních upozorněních: nic / jen pro čtení / archiv | blokace smazání, kopie do Preservation Hold library, smazání po retenci |
| Zkušební režim | simulace — jednorázový běh s reportem | retenční politika a ručně aplikovaný štítek žádný nemají; Learn zmiňuje simulaci u automatické aplikace štítků (E5) |
| Licence | E3/E5 **a** licence Copilot nebo SAM Plan 1 nebo E7 | E3 (politiky, štítky); E5 (záznamy, disposition, adaptivní scope) |
| Opatření ISO | A.5.9 (aktiva a vlastníci), A.5.15 | A.5.33, A.8.10 |

Zdroje: [SAM overview](https://learn.microsoft.com/en-us/sharepoint/advanced-management),
[inactive site policy](https://learn.microsoft.com/en-us/sharepoint/inactive-site-policy),
[site attestation](https://learn.microsoft.com/en-us/sharepoint/request-site-attestations),
[SAM prerequisites](https://learn.microsoft.com/en-us/sharepoint/sharepoint-advanced-management-prerequisites).
Obě vrstvy se potkávají: SAM politiky umí do scope zahrnout nebo vyloučit weby pod retencí,
a web pod retencí nejde smazat, ani když ho SAM vyhodnotí jako neaktivní. Demo lektora:
[`demo-sam-site-lifecycle.md`](demo-sam-site-lifecycle.md).

### Mapování na požadavky

| Opatření ISO/IEC 27001:2022 | Vlastní parafráze | Capability |
|---|---|---|
| A.5.33 | záznamy jsou chráněné před ztrátou, zničením, falšováním a neoprávněným přístupem či zveřejněním | retenční štítek označující záznam, record versioning, retenční politika na web |
| A.8.10 | informace v systémech a zařízeních se mažou, když už nejsou potřeba | retenční štítek s disposition review, retenční politika s koncem retence |

## Klíčové rozlišení

- **Retenční politika vs. retenční štítek** — plošně na lokaci vs. cíleně na položku (a jen štítek
  umí záznam, disposition review a položky seznamu).
- **Record vs. regulatory record** — první se dá odemknout pro novou verzi a správce ho může
  odznačit; druhý je nevratný.
- **Retence vs. záloha** — retence brání zmizení a drží obsah pro compliance; obnovu po incidentu
  neřeší.
- **DLM vs. DLP** — jak dlouho se drží vs. co nesmí odejít.
- **SAM site lifecycle vs. DLM** — weby vs. obsah.

## Licence

| Funkce v bloku | Business Premium | E3 | E5 / add-on | Zdroj |
|---|---|---|---|---|
| Retenční politiky (celá lokace, include/exclude) | ano | ano | ano | [Purview service description](https://learn.microsoft.com/en-us/office365/servicedescriptions/microsoft-365-service-descriptions/microsoft-365-tenantlevel-services-licensing-guidance/microsoft-purview-service-description) |
| Retenční štítky — vytvoření, publikace, ruční aplikace | ano | ano | ano | tamtéž |
| Štítek označující record / regulatory record, disposition review, retence od události | ne | ne | E5 / E5 IPG | tamtéž |
| Výchozí retenční štítek knihovny, automatická aplikace štítku, adaptivní scope | ne | ne | E5 / E5 IPG | tamtéž |
| File plan (import, export) | ne | ne | E5 / E5 IPG | tamtéž |
| SAM site lifecycle | ne | jen s licencí Copilot / SAM Plan 1 | jen s licencí Copilot / SAM Plan 1 / E7 | [SAM prerequisites](https://learn.microsoft.com/en-us/sharepoint/sharepoint-advanced-management-prerequisites) |

> [!IMPORTANT] Licenční nit
> Organizace s E3 nebo Business Premium udělá v tomto bloku retenční politiku a běžný retenční
> štítek — **ale ne záznam (record) ani disposition review**. A.5.33 pak musí doložit jinak
> (verzování, schvalování, oprávnění z dne 2) a v capstonu to patří mezi nálezy.

## Naše prostředí

- Kurzovní záznamový štítek `GOC248 ISMS zaznam` (1 rok, record, zamčený) publikoval lektor
  do všech webů nejméně 7 dní předem; na něm stojí kroky 7–8 a stopa pro den 4.
- Studentské objekty: štítek `<ini>-ISMS záznam`, label policy `<ini>-ISMS zaznam publikace`
  a retenční politika `<ini>-ISMS retence web` — **jen** na `isms-<ini>`.
- SAM demo jen pokud je na Tenant A dostupné (go/no-go) — Tenant A nemá licenci Copilot.

## Lab

Viz [`lab-retence-zaznamy.md`](lab-retence-zaznamy.md), včetně povinného kroku „Připrav stopu pro
zítřek". Referenční řešení a očekávané auditní operace: [`reseni-retence-zaznamy.md`](reseni-retence-zaznamy.md).

## Nosná linka

Web `isms-<ini>` je pod retenční politikou, záznam `ZAZ-01` je prohlášený za record (položky
Incident logu dostanou záznamový štítek až po uzavření incidentu ve čtvrtek) a v poznámce
studenta jsou časy čtyř akcí `test-<ini>` — vstup pro
[`../../day-4/audit-incident-response/`](../../day-4/audit-incident-response/). Viz
[`../../scenario-isms-vltava.md`](../../scenario-isms-vltava.md).

| Opatření | Capability M365 | Důkaz |
|---|---|---|
| A.5.33 | retenční štítek označující záznam (kurzovní + vlastní `<ini>-ISMS záznam`), record versioning | odkaz na zamčený záznam v knihovně + snímek chybové hlášky při pokusu o smazání |
| A.8.10 | retenční politika `<ini>-ISMS retence web`, štítek s disposition review | snímek nastavení politiky a štítku |

## Zdroje

- [Learn about retention policies and retention labels](https://learn.microsoft.com/en-us/purview/retention)
- [Learn about retention for SharePoint and OneDrive](https://learn.microsoft.com/en-us/purview/retention-policies-sharepoint)
- [Configure retention settings](https://learn.microsoft.com/en-us/purview/retention-settings)
- [Records management](https://learn.microsoft.com/en-us/purview/records-management)
- [Declare records by using retention labels](https://learn.microsoft.com/en-us/purview/declare-records)
- [Use record versioning](https://learn.microsoft.com/en-us/purview/record-versioning)
- [Publish and apply retention labels](https://learn.microsoft.com/en-us/purview/create-apply-retention-labels)
- [Disposition of content](https://learn.microsoft.com/en-us/purview/disposition)
- [Get started with records management](https://learn.microsoft.com/en-us/purview/get-started-with-records-management)
- [Audit log activities](https://learn.microsoft.com/en-us/purview/audit-log-activities)
- [SharePoint Advanced Management overview](https://learn.microsoft.com/en-us/sharepoint/advanced-management)

## Stav produktu / delta

> [!WARNING] Ověřit k datu běhu — stav k 2026-10.
> Dostupnost SAM na Tenant A (bez licence Copilot pravděpodobně ne); typ webu `isms-<ini>`
> (komunikační / týmový se skupinou) a s tím správná lokace statického scope; latence publikace
> retenčního štítku a retenční politiky na kurzovním tenantu (zapsat s datem); zda pokus o smazání
> záznamu vytváří auditní záznam (Learn ho nedokumentuje).
