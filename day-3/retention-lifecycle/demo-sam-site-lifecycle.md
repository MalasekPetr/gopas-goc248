# Demo · SAM site lifecycle vedle Purview DLM

Instruktorské demo, 10 min, **jen pokud je SAM na Tenant A dostupné** (go/no-go). Jinak platí
kompresní ventil 3: srovnávací tabulka z [`README.md`](README.md) a nic víc.

> [!WARNING] Ověřit k datu běhu — dostupnost SAM na Tenant A.
> SAM vyžaduje kromě základní licence (Office 365 E3/E5, Microsoft 365 E3/E5 aj.) **buď
> přiřazenou licenci Microsoft Copilot alespoň jednomu uživateli, nebo add-on SAM Plan 1, nebo
> Microsoft 365 E7** ([Learn: SAM prerequisites](https://learn.microsoft.com/en-us/sharepoint/sharepoint-advanced-management-prerequisites)).
> Tenant A Copilot nemá. Neověřeno na tenantu.

## Cíl dema

Ukázat, že SAM se ptá „**žije tenhle web a má odpovědného vlastníka?**", zatímco Purview DLM se
ptá „**jak dlouho se drží tenhle obsah?**" — a kde se to potkává.

## Postup (lektorský účet, projektor)

1. SharePoint admin centrum → **Policies** → **Site lifecycle management**. Ukázat tři typy
   politik: inactive site, site attestation, site ownership.
2. **Inactive site policy** → **Create policy** → scope **Upload a CSV** s jediným lektorským
   webem → nečinnost 6 měsíců, upozornění vlastníkům, akce **Do nothing** → režim **Simulation**.
   Ukázat volbu **Include sites with retention policies and retention holds** — tady se SAM
   a Purview potkávají ([Learn: inactive site policy](https://learn.microsoft.com/en-us/sharepoint/inactive-site-policy)).
3. Říct, co by udělal **Active** režim: běh jednou měsíčně, tři měsíční upozornění, pak podle
   volby nic / jen pro čtení / archiv přes Microsoft 365 Archive.
4. **Site attestation** — jen ukázat průvodce: perioda 3/6/12 měsíců, kdo atestuje, stejné
   vynucovací akce ([Learn: site attestation](https://learn.microsoft.com/en-us/sharepoint/request-site-attestations)).
5. Uzavřít otázkou na třídu: „Web `isms-<ini>` má od dnešního dne retenční politiku. Co se stane,
   když ho SAM vyhodnotí jako neaktivní a správce ho bude chtít smazat?" Odpověď: web pod
   retencí smazat nejde ([Learn](https://learn.microsoft.com/en-us/purview/retention-policies-sharepoint));
   SAM ho může nanejvýš přepnout do režimu jen pro čtení nebo archivovat.

## Co nedělat

- Žádnou politiku v režimu **Active** a žádný scope **Select sites at scale** na celý tenant —
  e-maily vlastníkům by dostali všichni studenti i jiné kurzy na tenantu.
- Simulační politiku po demu smazat.

## Mapování

SAM site lifecycle dokládá spíš A.5.9 (inventář aktiv a jejich vlastníci) než retenci; do SoA
v tomto bloku nepíše — případně jako doplněk důkazu k řádku A.5.9 z dne 2.
