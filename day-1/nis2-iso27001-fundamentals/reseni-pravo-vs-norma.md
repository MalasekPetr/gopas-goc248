# Řešení · Zákon, vyhláška, nebo norma?

Klíč k [`lab-pravo-vs-norma.md`](lab-pravo-vs-norma.md). Zdroje jsou v README modulu.

## Krok 1 — výroky

| # | Zařazení | Proč |
|---|---|---|
| 1 | Z | vyhl. č. 410/2025 Sb. § 3 odst. 2 a příloha č. 1; aktualizace alespoň 1× ročně |
| 2 | N | SoA je požadavek ISO/IEC 27001 (kap. 6.1.3); nižší režim chce přehled bezpečnostních opatření |
| 3 | X | certifikace je dobrovolná a měří proti normě; zákon má vlastní povinnosti (přehled, hlášení, vedení) |
| 4 | Z | prvotní hlášení do 24 h; nižší režim hlásí jen incidenty s významným dopadem (NÚKIB v1.2) |
| 5 | X | certifikace Microsoftu kryje jeho služby; kontroly uvnitř vlastní organizace posuzuje vlastní auditor (Learn, ISO/IEC 27001 offering) |
| 6 | Z+N | vyhl. § 3 odst. 3; v ISO politika a řízené dokumentované informace (A.5.1, kap. 7.5) |
| 7 | Z | § 7 je vyhodnotitelné opatření — nezavedení se odůvodní v přehledu |
| 8 | Z | vyhl. § 4 (osoba pověřená kybernetickou bezpečností) |

## Krok 2 — neopominutelná opatření

§ 3 odst. 2 až 6 (systém zajišťování minimální kybernetické bezpečnosti), § 4 (vrcholné vedení),
§ 5 (bezpečnost lidských zdrojů), § 6 (řízení kontinuity činností), § 10 (řešení kybernetických
bezpečnostních incidentů). Ostatní (§ 7–9, § 11–13) jsou vyhodnotitelná: nezavedení musí mít
odůvodnění v přehledu bezpečnostních opatření.

## Krok 3 — mezera mezi SoA a přehledem

Příloha č. 1 chce u opatření v procesu **stav**, **termín zavedení**, **prioritu** a **osobu
odpovědnou za zavedení**. Klasické SoA má aplikovatelnost a zdůvodnění; plán zavedení patří do
plánu zvládání rizik. Kurzovní seznam SoA má pevné schéma bez těchto sloupců — viz
[`../isms-design-m365/`](../isms-design-m365/).
