# Instructor notes — Detekce, audit a podklad pro hlášení incidentu

## Timing

- ~40 min výklad + 65 min lab + 5 min Defender demo. Výklad: audit 15, NÚKIB proces 15,
  významnost 10.
- **Nekrátit** (agenda). Při skluzu krátit uvnitř labu podle Fallbacku, ne blok.
- Spustit vyhledávání (krok 2) hned na začátku labu — úloha běží, zatímco se vysvětluje A3.

## Go/no-go — otestovat před během

- **Ráno v den 4**: za jednoho studenta (nebo vlastní zkušební `test-*`) spustit vyhledávání
  stopy z dne 3. Zapsat čas události a čas, kdy je vyhledatelná → `mereni-*.md` s datem.
- **Náhradní události**: den 3 odpoledne provést stejné čtyři akce lektorským testovacím
  účtem na lektorském webu; uživatele a web napsat studentům při fallbacku. Případný export
  CSV držet **mimo repo** (osobní údaje, IP adresy).
- Audit zapnutý (Exchange Online PowerShell `Get-AdminAuditLogConfig`, hodnota
  `UnifiedAuditLogIngestionEnabled`).
- Studentské účty (Global Administrator) vidí v Purview **Audit → Search** — neověřeno na
  tenantu; jinak role group Audit Reader.
- Incident log z dne 2 má vypočtený sloupec lhůty a lookup na Asset Register.
- Den před během otevřít Portál NÚKIB a materiály v1.2 / návod — změnila se verze, pole
  formuláře nebo začátek lhůty? Upravit šablonu.
- Neověřeno: přesné názvy operací pro štítek a odkaz podle toho, jak to studenti den 3 udělali;
  zda se zablokovaný pokus o smazání záznamu audituje.

## Tripwires

- **UTC.** Studenti hledají v místním čase a „nic tam není". Krok 1 se nevynechává.
- **Filtr webu bez `*`** vrací jen záznamy přímo k URL webu, ne k souborům.
- **„Defender nemá incident, takže to není incident."** Dva různé pojmy — vrátit na A3.
- **„Máme to v auditu, splněno."** Audit je důkaz, ne hlášení.
- **Všechno je významné** („radši nahlásit"). Pro nižší režim zákon hlásí jen významný dopad;
  dobrovolné hlášení je jiná kategorie. Vyžadovat zdůvodnění, ne strach.
- **Spor o začátek lhůty** — neřešit právně v učebně; pravidlo kurzu je „24 h od zjištění"
  (návod NÚKIB 2026-08, konzervativní), `ReportDeadline` = `DetectedAt` + 1 den.
- **CSV na ploše učebního PC** — osobní údaje mimo tenant. Kontrolovat krok 5.
- Student chce podklad „zkusmo odeslat" na Portál NÚKIB. Ne.

## Vazby

- Zpět: `retention-lifecycle` (stopa z dne 3), `lists-registers-workflow` (Incident log,
  Asset Register), `sensitivity-labels` (štítky), `conditional-access` a `privileged-access-pim`
  (sign-in log a historie PIM jako další důkazy).
- Dopředu: `compliance-manager-capstone` (podklad a záznam incidentu jako důkaz A.5.24–A.5.28).
