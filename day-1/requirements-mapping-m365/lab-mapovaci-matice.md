# Lab · Mapovací matice a licenční realita Vltava Servis

> Modul: `requirements-mapping-m365` · Odhad: 40 min · Režim: hands-on, vlastní scope (admin centra jen čtení)
> Tenant: A `cloudedu.cz` · Scénář: [`../../scenario-isms-vltava.md`](../../scenario-isms-vltava.md)

## Cíl

Sešit `<ini>-mapovaci-matice` v tvém OneDrive na Tenant A se šesti řádky matice a s licenčním
sloupcem ověřeným proti [`comparison-licence.md`](comparison-licence.md).

**Jak lab číst:** každý krok končí **Checkpointem** — nesedí-li, nepokračuj.

> [!NOTE] Předpoklad labu
> Pro účely labu má Vltava Servis **Microsoft 365 Business Premium** pro všech 240 zaměstnanců.
> Tenant A má E5 — v labu tedy porovnáváš „co uvidíme v kurzu" a „co by firma měla doma".

## Předpoklady

- Hotový [`../onboarding/`](../onboarding/) — profil `GOC248 A` s funkčním MFA.
- Přečtené README modulu a [`comparison-licence.md`](comparison-licence.md).

## Kroky

### 1. Ověř profil

Pracuješ v okně **GOC248 A**.

**Checkpoint (správný účet ve správném profilu):** okno má barvu a název profilu `GOC248 A`
a vpravo nahoře je účet `@cloudedu.cz`.

### 2. Zjisti, co má Tenant A za licence — jen čtení

Microsoft 365 admin center (`https://admin.microsoft.com`) -> **Billing** -> **Licenses**.
Potom **Users** -> **Active users** -> ty -> karta **Licenses and apps**. Nic neměň.

Zapiš si: název produktu (produktů), které má tenant, a které z nich máš přiřazené ty.

**Checkpoint:** máš zapsaný aspoň jeden produkt přiřazený tvému účtu a umíš říct, zda obsahuje
Entra ID P2 (podle [`comparison-licence.md`](comparison-licence.md), řádek PIM). **Negativní:**
na stránce licencí jsi nic nepřiřadil ani neodebral.

### 3. Založ sešit v OneDrive

V profilu A otevři OneDrive -> **Add new** / **Create** -> **Excel workbook**. Pojmenuj ho
`<ini>-mapovaci-matice`. Do prvního řádku napiš záhlaví:

| A | B | C | D | E | F | G |
|---|---|---|---|---|---|---|
| Oblast | Vyhlaska | Neopominutelne | Opatreni ISO | Capability M365 | Licence BP / E3 / E5 | Blok kurzu |

**Checkpoint:** v OneDrive na Tenant A je sešit `<ini>-mapovaci-matice` se sedmi sloupci
záhlaví.

### 4. Vyplň šest řádků

Z README (sekce „Matice — kostra") a z [`comparison-licence.md`](comparison-licence.md) vyplň
řádky pro tyto oblasti:

1. a) přehled bezpečnostních opatření,
2. c) řízení aktiv,
3. d) řízení rizik,
4. g) řízení přístupu,
5. i) detekce a zaznamenávání událostí,
6. j) řešení incidentů.

Sloupec **Licence** vyplň trojicí, např. `ano / ano / ano`, a když je v řádku víc capabilities,
vezmi tu nejnáročnější. Sloupec **Neopominutelne**: `ano` / `ne` podle tabulky 13 oblastí
v [`../nis2-iso27001-fundamentals/`](../nis2-iso27001-fundamentals/).

**Checkpoint:** šest řádků, žádná prázdná buňka. Řádek **d) řízení rizik** má ve sloupci
Vyhlaska text „vyhláškou neupraveno", ne vymyšlený §. Řádek **g)** má v Licence u Business
Premium `ne` (PIM vyžaduje Entra ID P2).

### 5. Licenční hádanka vedení

Vedení Vltava Servis se ptá: „Co z toho, co v kurzu postavíte, **nebudeme moct** s Business
Premium udělat?" Pod tabulku napiš tři konkrétní funkce a ke každé, jakou cestu jmenuje zdroj
(add-on nebo E5).

**Checkpoint:** tři funkce, každá s názvem add-onu nebo „E5" a se jménem řádku v
[`comparison-licence.md`](comparison-licence.md). **Negativní:** mezi nimi **není** Conditional
Access ani DLP pro SharePoint — ty Business Premium má.

### 6. Najdi otevřenou otázku

V [`comparison-licence.md`](comparison-licence.md) najdi řádek, kde je místo „ne" otazník,
a napiš do sešitu jednou větou, proč tam není „ne".

**Checkpoint:** odpověď zmiňuje DSPM a to, že service description ho neuvádí — „?" je chybějící
zdroj, ne zákaz.

### 7. Zapiš do SoA

Zatím **ne** — seznam SoA vznikne v [`../isms-design-m365/`](../isms-design-m365/). Tam tenhle
sešit přesuneš na web a stane se důkazem řádku **A.5.31**.

**Checkpoint:** sešit je uložený (v OneDrive vidíš čas poslední úpravy z posledních minut).

## Ověření

- [ ] Sešit `<ini>-mapovaci-matice` v OneDrive na Tenant A, sedm sloupců, šest řádků.
- [ ] Řádek d) bez vymyšleného § — „vyhláškou neupraveno".
- [ ] Licenční sloupec odpovídá [`comparison-licence.md`](comparison-licence.md).
- [ ] Tři funkce, které Business Premium nezvládne, s cestou podle zdroje.
- [ ] **Negativní:** v Microsoft 365 admin center se nic nezměnilo (licence, uživatelé).
- [ ] **Negativní:** Conditional Access ani DLP pro SharePoint nejsou mezi „BP nezvládne".

## Fallback

- **OneDrive ještě není připravený** (nový účet, první otevření): vyplň matici v Poznámkovém
  bloku na učebním stroji — data jsou fiktivní — a v `isms-design-m365` ji vlož do sešitu
  přímo na webu. Lektor ukáže, kde.
- **Billing -> Licenses nejde otevřít**: krok 2 udělá lektor na projektoru.
- **Při časové tísni (ventil dne č. 2):** krok 2 vypadne, v kroku 4 jen řádky a), d), j);
  licenční sloupec se převezme z [`reseni-mapovaci-matice.md`](reseni-mapovaci-matice.md)
  jako hotová tabulka.

## Zdroje

- [Microsoft Purview service description](https://learn.microsoft.com/en-us/office365/servicedescriptions/microsoft-365-service-descriptions/microsoft-365-tenantlevel-services-licensing-guidance/microsoft-purview-service-description)
- [Microsoft Entra licensing](https://learn.microsoft.com/en-us/entra/fundamentals/licensing)
