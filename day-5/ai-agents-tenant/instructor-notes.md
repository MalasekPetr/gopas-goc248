# Instructor notes — AI agenti uvnitř tenantu

## Timing

- ~35 min výklad (datová hranice 10, declarative agent a Agent Builder 15, sdílení
  a Copilot Studio 10) + 55 min lab.
- Lab: kroky 1–4 15 min, 5–6 10 min, 7 10 min, 8–9 10 min, 10 5 min, 11–12 5 min.
- Krok 2 (kanárek) **hned na začátku** — dokument se musí zaindexovat do kroku 9.
- První padá krok 10 (iterace), pak zkrácená evaluace na dotazy 1, 4, 7, 9.
  Negativní test 8–9 se nekrátí.

## Go/no-go — otestovat před během

- **Agent Builder pro Business Basic + PAYG**: zkušební účet `user.NN` vytvoří agenta se
  SharePointem jako zdrojem a nasdílí ho druhému účtu s rolí *Can chat*. Tvorba pro PAYG
  ověřena autorem na B (2026-10); sdílení *Can chat* před během zopakovat. Když ne:
  fallback agent lektora.
- **Billing policy připojená ke službě SharePoint agents** a všechny účty `user.NN` ve
  skupině přiřazené k policy (Learn: prerequisites). Bez toho agent zdroj nepoužije.
- **Restricted SharePoint Search vypnuté** — jinak SharePoint jako zdroj nejde.
- **Rozpočet a alert** na billing policy i v Azure Cost Management. Rozpočet nic nezastaví,
  jen upozorní. Odhad: ~13 dotazů × počet studentů + iterace; skutečnou spotřebu změřit
  při zkušebním průchodu a zapsat s datem (zatím žádné číslo).
- **Weby `isms-<ini>` na B**: každý jen vlastník + lektor; žádný *Everyone except external
  users*. Jinak negativní test nic nedokazuje.
- **Vzorové dokumenty** obsahují fakta pro dotazy 1–8 (viz `reseni-lab-compliance-agent.md`,
  sloupec „Co musí odpověď obsahovat"). Projít dotazy na zkušebním agentovi.
- **Nastavení Sharing** v admin center na B (*All users* / *Specific* / *No users*) zjistit
  předem — při *No users* jde sdílet jen konkrétním lidem, což lab stačí.
- Všechny kroky labu: **neověřeno na tenantu** do zkušebního průchodu (prosinec 2026).

## Tripwires

- **Špatný profil** — Global Admin z A v okně, kde student „jen zkouší Copilot". Krok 1
  a 11 kontrolovat pohledem.
- **Automatické sdílení souborů** v dialogu Share. Kdo ho zaškrtne, přesdílí dokumentaci
  sousedovi a kanárek „projde". Vysvětlit jako nález, ne jako chybu studenta.
- **Nahrané soubory** místo knihovny: sdílením agenta se sdílí i jejich obsah. Zakázáno.
- **Politika do instrukcí** — studenti kopírují text `POL-01` do Instructions. Instrukce
  = chování, znalosti = knihovna.
- **„Only use specified sources" = vynucení** — není. Dotaz 9 to ukáže; nezakrývat.
- **Agent v Teams chatu** — agenty z Agent Builderu nejde použít ve skupinových ani 1:1
  chatech Teams (Learn: Agent Builder, known limitations). Soused otevírá chat link.
- **Tenant B obsah na A jako text** — do SoA jen odkaz na screenshot.

## Vazby

- Zpět: `onboarding` (přístup na B), `content-type-hub` a `lists-registers-workflow`
  (Copilot PAYG na B), `sensitivity-labels` (oprávnění a štítky platí i pro agenta).
- Dopředu: `normiqa-navigator-demo` (stejná kritéria na hotového agenta),
  `copilot-governance-dspm` (schválení agentů správcem), `compliance-manager-capstone`
  (řádky A.5.23 a kap. 9.1 jako důkaz).
