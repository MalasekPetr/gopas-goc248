# GOC248 — Postavte si ISMS v Microsoft 365: praktický kurz pro NIS2 a ISO/IEC 27001

Zdrojové materiály kurzu **GOC248** (GOPAS). Vše je psané v Markdownu s Mermaid diagramy,
renderovatelné přímo na GitHubu.

Kurz je pětidenní, česky, pro M365 a SharePoint administrátory, bezpečnostní a compliance
specialisty, ISMS manažery a IT vedoucí organizací, které nově spadají pod NIS2. Katalogová
stránka:
[GOC248](https://www.gopas.cz/postavte-si-isms-v-microsoft-365-prakticky-kurz-pro-nis2-a-iso-iec-27001_goc248).

> [!IMPORTANT] Kurz navazuje na GOC240 a GOC222
> Katalog uvádí jako předpoklad kurzy **GOC240** (NIS2 a zákon o kybernetické bezpečnosti)
> a **GOC222** (SharePoint Online a Microsoft 365, základy administrace). Právní výklad NIS2
> a základy SharePointu se proto v tomto kurzu jen rekapitulují — čas patří labům. Mapování
> katalogové osnovy na bloky je v [`self-study.md`](self-study.md), pořadí v
> [`agenda.md`](agenda.md).

## Jak repo číst

- **Pořadí bloků** drží [`agenda.md`](agenda.md) — složky jsou pojmenované **slugy**, ne čísly.
- **Nosná linka** celého týdne je [`scenario-isms-vltava.md`](scenario-isms-vltava.md).
  Přečti ji první — bez ní jsou moduly nesouvisející cvičení.
- **Závazné názvosloví** (právní pojmy, produkty Microsoft, licenční realita) je
  v [`GLOSSARY.md`](GLOSSARY.md).
- **Konvence** psaní (MD styl, Mermaid, currency-markery, pravidlo ověřování, tenantová
  disciplína) jsou v [`CONVENTIONS.md`](CONVENTIONS.md).
- **Prostředí** — dva tenanty, matice per blok, go/no-go — je v
  [`environment.md`](environment.md).
- **Šablony** modulu, labu, instruktorských poznámek a denního README jsou
  v [`_templates/`](_templates/).
- **Skripty** jsou v [`scripts/`](scripts/).

## Struktura

```text
gopas-goc248/
├─ README.md                  # tento soubor
├─ CONVENTIONS.md             # jak psát materiály
├─ GLOSSARY.md                # závazné názvosloví a licenční realita
├─ agenda.md                  # pořadí bloků (single source of order)
├─ environment.md             # dva tenanty, matice per blok, go/no-go
├─ scenario-isms-vltava.md    # nosná linka týdne
├─ self-study.md              # mapování na katalog, co se neodučí
├─ _templates/                # module.md, lab.md, instructor-notes.md, day-readme.md
├─ day-1/ … day-5/            # obsah po dnech; každý modul = složka se slugem
├─ marketing/                 # rozdíl proti katalogové stránce
├─ sample-docs/               # fiktivní dokumentace Vltava Servis pro Tenant B
└─ scripts/                   # příprava a úklid tenantů, build vzorových dokumentů, Test-RepoIntegrity
```

Modul obsahuje `README.md` (výklad, student), `lab-*.md` (zadání, student) a
`instructor-notes.md` (timing, go/no-go, tripwires — **jen lektor**).

## Legenda

- **Povinný** blok — součást každého běhu.
- **Volitelný** blok (slug s prefixem `opt-`) — spouští se dle času a potřeb skupiny. Volitelné
  bloky jsou vždy **leaf**: nic povinného ani capstone na nich nezávisí.
- **Tenant A** = `cloudedu.cz`, **Tenant B** = `spdemo.online` — viz
  [`environment.md`](environment.md).
- Markery v textu:
  - `> [!IMPORTANT] … — ověřeno na tenantu (RRRR-MM-DD)` — chování nebo číslo změřené na
    kurzovním tenantu s datem.
  - `> [!WARNING] Ověřit k datu běhu — stav k RRRR-MM` — fast-moving fakt (licence, ceny,
    preview, retirement, metodiky NÚKIB).
  - `> [!IMPORTANT] Názvosloví` — přejmenování, na které studenty upozornit.
  - `> [!IMPORTANT] Nezaměňovat` — pojmy, které se pletou (DLP vs. DLM, NIS2 vs. ISO 27001).
  - `> [!NOTE]` — dramaturgické zdůvodnění: proč je blok tady.

## Dvě věci, na kterých tenhle kurz stojí

**Nic netvrdit bez ověření.** Každé netriviální tvrzení je buď ověřitelné z dokumentace
s odkazem (Microsoft Learn, NÚKIB, Sbírka zákonů), nebo ověřené na kurzovním tenantu s datem.
U compliance kurzu to znamená hlavně licenční realitu („co z toho máte ve své licenci") a
chování politik (za jak dlouho se štítek objeví, kdy se událost ukáže v auditu) — ne „obvykle
do hodiny".

**Jeden ISMS celým týdnem.** Kurz není série nesouvisejících politik. Každý student staví
ISMS workspace fiktivní firmy Vltava Servis a každý blok do jeho **prohlášení
o aplikovatelnosti (SoA)** zapíše opatření, capability Microsoft 365 a odkaz na důkaz.
V pátek z toho vznikne report stavu souladu. Viz
[`scenario-isms-vltava.md`](scenario-isms-vltava.md).

## Stav

**První úplná verze (2026-10-17), čeká na autorskou revizi.** Všech 16 bloků má výklad,
lab nebo demo, referenční řešení a instructor notes; skripty přípravy a úklidu tenantů
a vzorová dokumentace Vltava Servis existují. Odkazy na Microsoft Learn a NÚKIB jsou
ověřené k 2026-10-17. První běh: **leden 2027**.

**Ověřeno z dokumentace, ne na tenantu.** Žádný lab ani skript zatím neproběhl na kurzovních
tenantech. Každý `instructor-notes.md` označuje kroky „neověřeno na tenantu" — zkušební
průchod je položka go/no-go v [`environment.md`](environment.md), stejně jako ověřovací
kolo v prosinci 2026.

Integrita repa se kontroluje skriptem, ne odhadem:

```powershell
./scripts/Test-RepoIntegrity.ps1
```

> [!WARNING] Před prvním během projít go/no-go seznam
> [`environment.md`](environment.md) obsahuje otevřené položky, které mohou zastavit celé dny —
> zejména **licence E5 a Entra ID P2 na Tenant A** a **Copilot a Document processing PAYG na
> Tenant B**.
