# SME-01 Zálohování a obnova

Vlastník dokumentu: vedoucí IT, Lenka Horáková

Datum účinnosti: 2026-06-30

Datum příští revize: 2027-06-30

Verze: 1.0

Klasifikace: Interní

## Účel a nadřazená politika

Směrnice stanoví, jak Vltava Servis s.r.o. zálohuje data a jak ověřuje, že je umí obnovit.
Nadřazená politika: POL-01 Politika bezpečnosti informací.

## Rozsah zálohování

- Databáze servisních zakázek: denní záloha, uchování 90 dní. Zálohu zajišťuje dodavatel
  podle smlouvy; vedoucí IT kontroluje měsíční report dodavatele.
- Dokumenty v Microsoft 365: verze dokumentů a koš podle nastavení služby; řízená
  dokumentace ISMS navíc podléhá retenci.
- Konfigurace síťových prvků v kanceláři: záloha po každé změně.

## Test obnovy

1. Obnova ze zálohy se testuje jednou za čtvrtletí.
2. Test vybírá vedoucí IT tak, aby se během roku vystřídala všechna aktiva v rozsahu
   zálohování.
3. Test provádí správce IT nebo dodavatel; obnovuje se do testovacího prostředí, nikdy
   přes produkční data.
4. Úspěšný test znamená, že obnovená data jsou úplná a čitelná a že obnova proběhla v čase
   sjednaném pro dané aktivum.

## Záznam o testu

Záznam o každém testu obnovy (datum, aktivum, výsledek, doba obnovy, zjištěné problémy)
zapisuje správce IT, který test provedl, a ukládá ho do řízené dokumentace. Vedoucí IT
záznam kontroluje a potvrzuje. Neúspěšný test se řeší jako bezpečnostní událost podle
POL-04.

## Odpovědnosti

- Vedoucí IT odpovídá za plán zálohování, výběr testů a kontrolu záznamů.
- Správce IT provádí zálohy a testy a zapisuje záznamy o testech.
- Manažer kybernetické bezpečnosti jednou ročně vyhodnotí výsledky testů pro přezkoumání
  vedením.
