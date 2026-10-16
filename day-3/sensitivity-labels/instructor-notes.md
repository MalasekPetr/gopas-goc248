# Instructor notes — Klasifikace a sensitivity labels v Purview

## Timing

- ~35 min výklad + 70 min lab + 5 min rezerva. Krok 2 (papírová taxonomie) max 10 min — kdo
  nemá hotovo, pokračuje podle `reseni-stitky-isms.md`, část B.
- Kroky 4 a 5 dělá celá třída **současně podle projektoru** — jsou to tenantové objekty.
- Padá první: krok 9 (auto-labeling, −15, kompresní ventil 1). Nekrátit kroky 4–7.

## Go/no-go — otestovat před během

- Celá příprava podle `guide-priprava-tenantu.md` (T−10 dní), vč. úterní kontroly.
- Schéma štítků (modern / classic) zapsané; podle něj říct třídě krok 4a nebo 4b.
- `EnableAIPIntegration = True`; výchozí štítek knihovny je na testovacím webu nabízen.
- Kontejnerové štítky: scope *Groups & sites* je dostupný, Interní je v Site information.
- Jak dlouho trvá, než se nový štítek z policy na `isms-<ini>-users` ukáže v Word for the web
  a v nastavení knihovny — **neověřeno na tenantu**; změřit v dry-runu a zapsat do
  `mereni-propagace.md`. Learn: až 24 h, nové štítky ve webových Office aplikacích někdy do hodiny.
- Popisky UI (*Create label in group*, *Default sensitivity labels* v Library settings, text
  volby zdůvodnění v policy) — **neověřeno na tenantu**, upravit lab podle reality.
- `isms-<ini>-users`: typ skupiny (security / Microsoft 365) a že ji label policy nabízí.

## Tripwires

- **Move up / Move down** — student přeřadí štítek a změní prioritu pro celý tenant (co je
  „snížení", co přebije výchozí štítek knihovny). Kontrolovat pořadí po kroku 4; případně vrátit
  lektorem.
- **Policy na All users** — studentova policy je novější (vyšší pořadové číslo) a její nastavení
  přebije kurzovní policy všem. Kontrolovat po kroku 5 seznam Label policies.
- **Publish label z průvodce štítku** — vytvoří druhou policy; nechat jednu, druhou smazat.
- **Classic schéma bez nadřazeného štítku v policy** — sublabel se uživatelům nezobrazí.
- **Kontejnerový štítek ze SharePoint admin centra** — admin centrum nabízí všechny štítky pro
  všechny weby; Global Administrator tak snadno označí cizí web. Jen Site information vlastního webu.
- **Mismatch e-maily** — dokument Přísně důvěrné na webu Důvěrné \ Vltava pošle vlastníkům e-mail
  *Incompatible sensitivity label detected*. Není to chyba labu; dobrý vstup pro den 4.
- **Automatické zapnutí auto-labeling policy po 7 dnech** — zaškrtnuté by zaplo politiku týden
  po kurzu. Kontrolovat u každého (ventil 1).
- **Neschválené dokumenty** (krok 7.3) — `test-<ini>` je ve stopě neuvidí; stopa v
  `retention-lifecycle` pak selže.
- „Štítek se nezobrazuje" v prvních minutách je očekávané; neopravovat policy, počkat a použít
  fallback (Důvěrné \ Vltava).

## Vazby

- Zpět: `document-libraries-governance` (knihovna, schvalování), `isms-design-m365` (SoA).
- Dopředu: `dlp` (štítek jako podmínka), `retention-lifecycle` (stopa: snížení štítku),
  `audit-incident-response` (FileSensitivityLabelChanged), `copilot-governance-dspm` (štítky
  pro Copilot).
