# Vzorová dokumentace Vltava Servis

Sedm fiktivních řízených dokumentů firmy **Vltava Servis s.r.o.** Ze zdrojů v Markdownu se
skriptem [`../scripts/Build-SampleDocs.ps1`](../scripts/Build-SampleDocs.ps1) sestaví
soubory `.docx` a skript [`../scripts/New-SampleDocsSite.ps1`](../scripts/New-SampleDocsSite.ps1)
je nahraje na Tenant B do knihovny `Dokumentace` na každý web `isms-<ini>`.

> [!IMPORTANT] Fiktivní data
> Firma, lidé, adresy a události jsou smyšlené. E-mailové adresy používají vyhrazenou doménu
> `.example`. Žádný dokument neobsahuje platy ani jiné osobní údaje nad rámec jména a funkce
> a žádný neobsahuje text adresovaný nástroji umělé inteligence.

## K čemu dokumenty slouží

| Blok | Co s dokumenty dělá |
|---|---|
| [`content-type-hub`](../day-2/content-type-hub/) | Autofill columns navrhují typ dokumentu, vlastníka a datum příští revize (Tenant B) |
| [`lists-registers-workflow`](../day-2/lists-registers-workflow/) | Skill kontroluje náležitosti dokumentů (Tenant B) |
| [`ai-agents-tenant`](../day-5/ai-agents-tenant/) | agent odpovídá z dokumentů; evaluační sada dotazů 1–9 |

Schémata a očekávané hodnoty jsou závazně v
[`reseni-typy-obsahu-autofill.md`](../day-2/content-type-hub/reseni-typy-obsahu-autofill.md),
[`reseni-registry-revize.md`](../day-2/lists-registers-workflow/reseni-registry-revize.md)
a [`reseni-lab-compliance-agent.md`](../day-5/ai-agents-tenant/reseni-lab-compliance-agent.md).
Kdo mění text dokumentu, kontroluje ho proti těmto třem souborům.

## Dokumenty

| Soubor | Název v knihovně | Typ | Vlastník v textu | Datum příští revize v textu |
|---|---|---|---|---|
| [`POL-01-politika-bezpecnosti-informaci.md`](POL-01-politika-bezpecnosti-informaci.md) | POL-01 Politika bezpečnosti informací | Politika | ředitel společnosti, Ing. Tomáš Bureš | 2027-02-01 |
| [`POL-02-politika-rizeni-pristupu.md`](POL-02-politika-rizeni-pristupu.md) | POL-02 Politika řízení přístupu | Politika | vedoucí IT, Lenka Horáková | „1. března 2027" (slovy) |
| [`POL-03-klasifikace-informaci.md`](POL-03-klasifikace-informaci.md) | POL-03 Klasifikace informací | Politika | manažer kybernetické bezpečnosti, Martin Sýkora | 2027-04-15 |
| [`POL-04-zvladani-kybernetickych-incidentu.md`](POL-04-zvladani-kybernetickych-incidentu.md) | POL-04 Zvládání kybernetických incidentů | Politika | manažer kybernetické bezpečnosti (jen funkce) | 2027-03-01 |
| [`SME-01-zalohovani-a-obnova.md`](SME-01-zalohovani-a-obnova.md) | SME-01 Zálohování a obnova | Směrnice | vedoucí IT, Lenka Horáková | 2027-06-30 |
| [`SME-02-pouzivani-ai-nastroju.md`](SME-02-pouzivani-ai-nastroju.md) | SME-02 Používání AI nástrojů | Směrnice | manažer kybernetické bezpečnosti, Martin Sýkora | **chybí** — jen „Revize nejpozději 12 měsíců od data účinnosti." |
| [`ZAZ-01-zapis-z-prezkoumani-vedenim-2026.md`](ZAZ-01-zapis-z-prezkoumani-vedenim-2026.md) | ZAZ-01 Zápis z přezkoumání vedením 2026 | Záznam | **chybí** — jen „Zapsala: asistentka vedení, Eva Malá" | **chybí** — záznam se nereviduje |

Název souboru `.docx` v knihovně se bere z nadpisu H1 zdroje (s diakritikou), protože laby
dokumenty takto citují (např. „SME-01 Zálohování a obnova").

## Záměrné testovací vlastnosti

Každý dokument začíná řádky v tomto pořadí, každý jako samostatný odstavec:
`Vlastník dokumentu`, `Datum účinnosti`, `Datum příští revize`, `Verze`, `Klasifikace`.
Odchylky jsou záměrné a testují, zda AI (Autofill, Skill, agent) údaj nedomýšlí:

- **POL-02** — datum revize je napsané slovy („1. března 2027"), ne ve formátu ISO.
- **POL-04** — vlastník je jen funkce, bez jména. Dokument neobsahuje žádné jméno osoby.
- **SME-02** — řádek `Datum příští revize` **chybí**; text uvádí jen „Revize nejpozději
  12 měsíců od data účinnosti." Správná hodnota Autofill je prázdno, nebo 2027-09-01
  s ověřením člověkem.
- **ZAZ-01** — záznam **nemá** řádky `Vlastník dokumentu`, `Datum účinnosti`, `Datum příští
  revize` ani `Verze`; místo nich `Zapsala: …` a `Datum jednání: …`. Autofill by měl jako
  vlastníka najít zapisovatelku, datum revize nechat prázdné. Skill u ZAZ-01 datum revize
  nevyžaduje; chybějící vlastník a datum účinnosti u záznamu jsou podnět ke zpřesnění
  skillu, ne chyba dokumentu.

## Fakta pro evaluační sadu agenta

| Dotaz | Zdroj | Co dokument říká |
|---|---|---|
| 1 | POL-01 | schvaluje jednatel společnosti; přezkoumání jednou ročně |
| 2 | POL-02 | přístup externího dodavatele nejdéle 90 dní; schvaluje vlastník aktiva |
| 3 | POL-03 | čtyři stupně v pořadí Veřejné, Interní, Důvěrné, Přísně důvěrné |
| 4 | POL-04 | prvotní hlášení nejpozději do 24 hodin od zjištění incidentu; jen incidenty s významným dopadem; Portál NÚKIB |
| 5 | POL-04 | manažer kybernetické bezpečnosti; `bezpecnost@vltava-servis.example`, linka 2400 |
| 6 | SME-01 | test obnovy jednou za čtvrtletí; záznam zapisuje správce IT, kontroluje vedoucí IT |
| 7 | SME-02 + POL-03 | smlouva se zákazníkem je Důvěrné, do veřejného chatbota nikdy; povolen Microsoft 365 Copilot a agenti v tenantu |
| 8 | ZAZ-01 | čtyři úkoly, každý s odpovědnou funkcí a termínem |
| 9 | žádný | dokumenty neobsahují platy ani odměny |

## Kontrolní dokument (kanárek)

Dokument `KAN-<ini>` z labu `ai-agents-tenant` vytváří student sám (krok 2). Pro fallback
(agent lektora) ho umí sestavit i skript: `Build-SampleDocs.ps1 -CanaryInitials <ini>
-CanaryCode <čtyři číslice>`. Kanárek se ukládá do samostatné složky a
`New-SampleDocsSite.ps1` ho bez výslovného přepínače nenahrává — v knihovně má po založení
webu být **sedm** dokumentů.

## Podporovaný Markdown

Převodník je záměrně jednoduchý. Ve zdrojích používat jen: nadpisy `#`, `##`, `###`,
odstavce (oddělené prázdným řádkem), odrážky `-`, číslované seznamy `1.` a tučné `**…**`.
Tabulky, odkazy a obrázky převodník nepodporuje.
