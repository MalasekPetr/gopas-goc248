# Řešení · Registry, revize a Skill

> Modul: `lists-registers-workflow` · K labům: [`lab-registry-revize.md`](lab-registry-revize.md),
> [`lab-skill-kontrola-dokumentace.md`](lab-skill-kontrola-dokumentace.md)
> Schémata níže jsou **závazná** — podle nich skript zakládá seznamy pro ty, kdo nestihli,
> a na Incident log navazuje den 4. Zdůvodnění v SoA je vždy vlastní text studenta.

## Seznamy a adresy

| Seznam (display) | Adresa | Vazby |
|---|---|---|
| Asset Register | `/sites/isms-<ini>/Lists/AssetRegister` | — |
| Risk Register | `/sites/isms-<ini>/Lists/RiskRegister` | `RiskAsset` -> Asset Register Title |
| Incident log | `/sites/isms-<ini>/Lists/IncidentLog` | `AffectedAssets` -> Asset Register Title (multi) |

## Asset Register

| Display name | Internal name | Type |
|---|---|---|
| Název | Title | text |
| Typ aktiva | AssetType | choice: Informace / Aplikace / Služba / Infrastruktura / Zařízení / Dodavatel / Lidé |
| Popis | AssetDescription | multiline text |
| Vlastník aktiva | AssetOwner | person |
| Umístění | AssetLocation | text |
| Klasifikace | AssetClassification | choice: Veřejné / Interní / Důvěrné / Přísně důvěrné |
| Kritičnost | Criticality | choice: Nízká / Střední / Vysoká |
| Datum příští revize | NextReview | date |
| Stav | AssetStatus | choice: V provozu / Plánované / Vyřazené |

## Risk Register

| Display name | Internal name | Type |
|---|---|---|
| Název rizika | Title | text |
| Aktivum | RiskAsset | lookup to Asset Register Title |
| Hrozba | Threat | text |
| Zranitelnost | Vulnerability | text |
| Pravděpodobnost | Likelihood | number 1-5 |
| Dopad | Impact | number 1-5 |
| Míra rizika | RiskScore | calculated number = [Likelihood]*[Impact] |
| Vlastník rizika | RiskOwner | person |
| Způsob zvládání | Treatment | choice: Snížit / Přijmout / Vyhnout se / Sdílet |
| Plán zvládání | TreatmentPlan | multiline text |
| Vazba na opatření | ControlRef | text |
| Datum příští revize | NextReview | date |
| Stav | RiskStatus | choice: Identifikováno / V řešení / Přijato / Uzavřeno |

Sloupce, které přidá zapnutí Approvals (*Approval status*, *Approvers* …), jsou systémové
a do schématu pro skript nepatří.

## Incident log (pevné schéma, D4)

| Display name | Internal name | Type |
|---|---|---|
| Název | Title | text |
| Zjištěno | DetectedAt | date+time |
| Vyhodnoceno jako incident | ClassifiedAt | date+time |
| Lhůta prvotního hlášení | ReportDeadline | calculated date+time = [ClassifiedAt]+1 |
| Významný dopad | Significant | choice: ano / ne / posuzuje se |
| Kritérium významnosti | SignificanceBasis | multiline text |
| Dotčená aktiva | AffectedAssets | lookup (multi) to Asset Register Title |
| Stav | Status | choice: Nový / V řešení / Nahlášeno / Uzavřeno |
| Podklad pro hlášení | ReportDraft | hyperlink |
| Důkazy | Evidence | multiline text |

Lhůta +1 den odpovídá prvotnímu hlášení **nejpozději do 24 h od vyhodnocení události jako
incidentu** (viz [`../../GLOSSARY.md`](../../GLOSSARY.md)). Cvičný záznam
`CVICENI - ztraceny notebook` má Stav `Uzavřeno`; den 4 ho může ignorovat nebo smazat.

## Data

Aktiva a rizika podle tabulek v labu (kroky 3 a 5). Kontrolní hodnoty: Míra rizika 20 / 9 / 6;
zobrazení `K revizi` = jen „Ztráta notebooku technika"; „Vydání neschválené verze politiky"
má schválené Approvals a Stav `Přijato`.

## Řádky SoA

Sloupec **Požadavek** z mapovací matice D1.

| Opatření | Aplikovatelné | Zdůvodnění (vzor) | Capability M365 | Důkaz | Modul | Tenant |
|---|---|---|---|---|---|---|
| A.5.9 | ano | Bez seznamu aktiv a jejich vlastníků nelze rizika ani incidenty k ničemu vztáhnout. | Asset Register s vlastníkem, klasifikací, kritičností a datem revize | odkaz na `AssetRegister` | `lists-registers-workflow` | A |
| kap. 6.1 | ano | Riziko = aktivum × hrozba, míra P × D; nad 12 snižujeme, přijetí zbytkového rizika schvaluje vlastník rizika. | Risk Register + Approvals | odkaz na `RiskRegister` | `lists-registers-workflow` | A |
| kap. 8.2 | ano | Rizika revidujeme nejméně jednou ročně a při změně; po termínu je vidí zobrazení K revizi. | zobrazení `K revizi` (volitelně týdenní flow) | odkaz na zobrazení `K revizi` | `lists-registers-workflow` | A |
| A.5.24 | ano | Incident se eviduje s časem vyhodnocení, aby šla hlídat lhůta prvotního hlášení. | Incident log s počítanou lhůtou | odkaz na `IncidentLog` | `lists-registers-workflow` | A |
| kap. 7.5 | ano | Kontrola náležitostí dokumentů pokaždé stejně; neověřuje správnost obsahu, jen přítomnost údajů. | Skill webu v Copilot in SharePoint | odkaz na `SKILL.md` na Tenant B + screenshot | `lists-registers-workflow` | B |

## Skill — co by měl najít

Podle obsahu vzorových dokumentů (zadání v repu), ne podle naměřeného běhu:

| Dokument | Očekávaný nález |
|---|---|
| POL-01, POL-02, POL-03, SME-01 | žádný |
| POL-04 | žádný — vlastník je uvedený funkcí; kdo chce jméno, upraví skill |
| SME-02 | datum příští revize není uvedené přímo (jen „12 měsíců od účinnosti") |
| ZAZ-01 | žádný nález data revize (záznam); datum účinnosti u záznamu nedává smysl — dobrý podnět ke zpřesnění skillu |
