# Instructor notes — Data Loss Prevention napříč Microsoft 365

## Timing

- ~25 min výklad + 55 min lab + 10 min společné vyšetření na `LEKTOR-DLP-demo`.
- Krok 3 (průvodce politikou) je nejdelší — dělat podle projektoru, ~15 min.
- Padá první: kroky 6–7 jako demo lektora (−15, kompresní ventil 2). Krok 8 lze jako diskusi
  s celou třídou.

## Go/no-go — otestovat před během

- `LEKTOR-DLP-demo` vytvořená T−2 dny, má výsledky v Simulation overview, aspoň jedno upozornění
  na kartě Alerts a událost *DLP rule matched* v Activity exploreru.
- Testovací rodné číslo ověřené testem SIT (guide v `sensitivity-labels`, krok 8) — výsledek
  zapsat; hodnotu nepublikovat v repu, dokud není ověřená.
- Průvodce DLP politikou: kategorie, názvy akcí a voleb simulace — **neověřeno na tenantu**.
- Zda jde v podmínce *Content contains* v jedné skupině kombinovat sensitivity labels a SIT —
  **neověřeno**; lab má fallback na dvě pravidla.
- Zda Global Administrator vidí **View simulation** a Activity explorer bez přidání do role
  Information Protection Admin — **neověřeno**. Nepřidávat studenty do rolí plošně.
- Latence: doba do prvních položek v Items for review a do upozornění — změřit v dry-runu,
  zapsat do `mereni-*.md` s datem.

## Tripwires

- **Lokace zapnuté na All** — průvodce může nabízet zapnuté Exchange / OneDrive / Teams. Kontrola
  v kroku 4 u každého; politika bez zahrnutí webu = celý SharePoint tenantu.
- **Zaškrtnuté automatické zapnutí po 15 dnech** — politika by se sama zapnula po kurzu.
- **Reálné rodné číslo** — studenti někdy vloží „své" nebo vygenerované z webu. Zastavit, smazat,
  použít hodnotu z tabule.
- **„Nic se neděje"** — normální v prvních desítkách minut; neupravovat politiku opakovaně
  (každá úprava znovu spouští vyhodnocení), přejít na lektorskou politiku.
- **Testovací dokument v Řízené dokumentaci** — prochází schvalováním a zatíží knihovnu; patří
  do Documents.
- Studenti čekají upozornění ze simulace v Defender portálu — tam nejsou, jen na kartě simulace.

## Vazby

- Zpět: `sensitivity-labels` (štítek jako podmínka).
- Dopředu: `audit-incident-response` (DLP události v auditu), `copilot-governance-dspm` (lokace
  Microsoft 365 Copilot v DLP).
