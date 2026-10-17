# Lab · Capstone — důkazy v Compliance Manageru a report stavu souladu

> Modul: `compliance-manager-capstone` · Odhad: 80 min · Režim: hands-on, vlastní scope
> Tenant: A `cloudedu.cz` · Scénář: [`../../scenario-isms-vltava.md`](../../scenario-isms-vltava.md)

## Cíl

V Compliance Manageru na Tenant A je assessment `<ini>-ISO27001-2022` ve skupině `<ini>-ISMS`
s aspoň pěti důkazy navázanými ze SoA, ve workspace `isms-<ini>` je report stavu souladu
podle šablony a student ho obhájil za 3 minuty.

**Jak lab číst:** každý krok končí **Checkpointem** — nesedí-li, nepokračuj.

## Předpoklady

- Profil prohlížeče pro **Tenant A**, Global Administrator.
- SoA ve workspace `isms-<ini>` s řádky ze dnů 1–5. Sloupce: Opatření, Požadavek,
  Aplikovatelné, Zdůvodnění, Capability M365, Důkaz (odkaz), Modul, Tenant, Stav zavedení,
  Priorita, Termín, Odpovědná osoba.
- Kdo nestihl některý den, doplnil řádky z `reseni-*.md` daného bloku — a v reportu to
  uvede jako nález.
- Lektor potvrdil: šablona **ISO/IEC 27001:2022** je v tenantu dostupná.
- [`template-report-souladu.md`](template-report-souladu.md) otevřený vedle.

> [!WARNING] Čtyři pravidla pro sdílený Compliance Manager
>
> 1. Jen assessment `<ini>-ISO27001-2022` ve **vlastní nové skupině** `<ini>-ISMS`.
> 2. Důkazy a stav implementace jen u **netechnických** improvement actions
>    (*Action type*: dokumentační nebo provozní). Technické akce jsou tenantové — jen číst.
> 3. **Test status** nenastavuj. Posouzení patří assessorovi a po *Passed* už důkazy nejdou
>    smazat.
> 4. Žádnou jinou šablonu neaktivuj — každá prémiová spotřebuje licenční slot tenantu.

## Kroky

### 1. Ověř účet a profil

**Checkpoint:** přihlášený účet končí `@cloudedu.cz`, jsi v profilu pro A a vidíš svůj
seznam SoA.

### 2. Vyber pět řádků SoA

Ze SoA vyber **5 řádků** s funkčním odkazem ve sloupci Důkaz tak, aby pokryly aspoň tři dny.
Doporučená kostra (uprav podle svého SoA):

| # | Opatření | Odkud | Typ důkazu |
|---|---|---|---|
| 1 | A.5.37 nebo kap. 7.5 | `document-libraries-governance` | řízená knihovna se schvalováním |
| 2 | A.5.12 | `sensitivity-labels` | taxonomie a label policy |
| 3 | A.8.12 | `dlp` nebo `copilot-governance-dspm` | politika DLP v simulaci |
| 4 | A.5.24–A.5.26 | `audit-incident-response` | záznam v Incident logu s podkladem z auditu |
| 5 | A.5.23 | `ai-agents-tenant` | konfigurace a evaluace agenta (screenshot z B) |

Každý odkaz otevři a ověř, že vede tam, kam má.

**Checkpoint:** máš seznam 5 řádků SoA s funkčními odkazy z aspoň tří dnů.

### 3. Zkontroluj šablony — jen čtení

Purview portál > **Compliance Manager** > **Regulations**. Najdi **ISO/IEC 27001:2022**
a zapiš stav (*Active* / *Inactive*) a hodnotu počítadla **Free regulation licenses used**.

**Checkpoint:** máš zapsaný stav šablony a hodnotu počítadla. Nic jsi neaktivoval.

### 4. Založ assessment ve vlastní skupině

**Assessments** > **Add assessment**:

1. **Select regulation**: ISO/IEC 27001:2022.
2. **Assessment name**: `<ini>-ISO27001-2022`.
3. **Assessment group**: **Create new group** — `<ini>-ISMS`. Volbu *Copy data from an
   existing group* **nezaškrtávej**.
4. **Select services**: Microsoft 365.
5. **Create assessment**.

**Checkpoint:** na stránce Assessments je `<ini>-ISO27001-2022` ve skupině `<ini>-ISMS`.

**Checkpoint (negativní):** žádný jiný assessment nezměnil skupinu ani název; skupina
s tvým názvem neobsahuje cizí assessment.

### 5. Navaž pět důkazů

Pro každý z pěti řádků SoA:

1. V assessmentu na kartě **Controls** vyhledej kontrolu podle čísla opatření (přesný tvar
   *Control ID* ověř v UI).
2. V kontrole otevři improvement action, jejíž **Action type** je **netechnický**
   (dokumentační nebo provozní) a věcně odpovídá řádku SoA. Má-li kontrola jen technické
   akce, **nic neměň** — zapiš si ji do reportu jako „technická akce, tenantová" a vyber
   jiný řádek SoA.
3. **Evidence** > **Add evidence** > **Link**: název `<ini>-<opatření>-<slug>`, URL = odkaz
   ze sloupce Důkaz v SoA.
4. **Implementation status**: *Implemented*, *Planned* nebo *Alternative implementation*
   podle reality — výchozím bodem je sloupec **Stav zavedení** řádku SoA. **Edit notes** > datum implementace + poznámka `SoA isms-<ini>, radek <opatreni>`.
5. **Save**. **Test status** nech, jak je.

**Checkpoint:** v assessmentu `<ini>-ISO27001-2022` má 5 netechnických improvement actions
odkaz na důkaz ve tvaru `<ini>-...` a nastavený stav implementace s datem.

**Checkpoint (negativní):** žádné technické improvement action jsi nepřidal důkaz ani
nezměnil stav; žádná akce nemá od tebe test status *Passed*.

### 6. Odečti stav assessmentu

Na stránce assessmentu si zapiš: *Progress*, počet tvých a Microsoft actions, rozpad stavu
kontrol na kartě **Controls**. Nečekej změnu skóre — stav se propisuje do 24 hodin.
Volitelně: **Export actions** (Excel) a ulož ho do workspace jako přílohu reportu.

**Checkpoint:** máš zapsaná čísla z assessmentu s datem a časem odečtu.

### 7. Napiš report stavu souladu

Zkopíruj [`template-report-souladu.md`](template-report-souladu.md) do dokumentu
`<ini>-Report-stavu-souladu` ve workspace `isms-<ini>` a vyplň všechny sekce. Každé tvrzení
o zavedeném opatření má odkaz na řádek SoA nebo na důkaz. Rozsah: 2 strany.

Skupiny v sekci 4 ber ze sloupce **Stav zavedení**, mezery v sekci 5 doplň o Prioritu,
Termín a Odpovědnou osobu z řádků SoA. Seznam SoA exportuj (**Export** -> **Export to
CSV**) a ulož soubor do workspace jako přílohu reportu: to je **přehled bezpečnostních opatření**, který se předkládá
vedení (aktualizace alespoň 1× ročně, verze předložené vedení uchovat alespoň 4 roky —
vyhl. č. 410/2025 Sb. § 3 odst. 2 a příloha č. 1, podle
[důvodové zprávy NÚKIB](https://portal.nukib.gov.cz/storage/uploads/2025/12/03/duvodova-zprava-vyhlaska-nizsi-rezim_uid_693039f42250d.pdf)).

**Checkpoint:** report má vyplněné všechny sekce šablony včetně prohlášení o povaze reportu,
aspoň 3 mezery s licenční poznámkou a aspoň 2 otevřená rizika. Export SoA je ve workspace.

### 8. Obhajoba ve trojicích

Lektor rozdělí třídu do trojic. Každý má **3 minuty** na čtyři otázky, pak 2 minuty dotazů
od dvojice:

1. **Rozsah a režim** — co ISMS pokrývá, proč režim nižších povinností.
2. **Co je zavedené a čím to dokládám** — tři nejsilnější řádky SoA s důkazem.
3. **Kde je mezera** — dvě největší mezery a co by stály (licence, práce, rozhodnutí vedení).
4. **Co z toho není** — proč report není atest souladu ani certifikace.

Posluchači zapíšou ke každé obhajobě jednu otázku, na kterou zazněla slabá odpověď.

**Checkpoint:** každý v trojici obhájil a dostal aspoň jednu zapsanou otázku.

### 9. Zapiš do SoA

| Opatření | Požadavek | Aplikovatelné | Zdůvodnění | Capability M365 | Důkaz | Modul | Tenant |
|---|---|---|---|---|---|---|---|
| kap. 9.1 | dle mapovací matice | ano | stav zavedení opatření se měří a vyhodnocuje | Compliance Manager, assessment ISO/IEC 27001:2022, důkazy u improvement actions | odkaz na assessment `<ini>-ISO27001-2022` | `compliance-manager-capstone` | A |
| A.5.36 | dtto | ano | soulad s politikami a normou se pravidelně ověřuje a reportuje vedení | report stavu souladu nad SoA a assessmentem | odkaz na `<ini>-Report-stavu-souladu` | `compliance-manager-capstone` | A |

Vyplň i Stav zavedení, Prioritu, Termín a Odpovědnou osobu (u zavedených opatření Termín
necháš prázdný).

**Checkpoint:** v SoA jsou dva nové řádky s Modul = `compliance-manager-capstone` a funkčními
odkazy.

## Ověření

- [ ] Assessment `<ini>-ISO27001-2022` ve skupině `<ini>-ISMS`.
- [ ] 5 netechnických improvement actions s odkazem na důkaz ze SoA a stavem implementace.
- [ ] **Negativní:** žádná technická akce změněná, žádný test status *Passed*, žádná jiná
      šablona aktivovaná, žádný cizí assessment dotčený.
- [ ] Report `<ini>-Report-stavu-souladu` ve workspace se všemi sekcemi šablony; export SoA
      ve workspace.
- [ ] Obhajoba ve trojici proběhla.
- [ ] Dva řádky v SoA.

## Fallback

- **Šablona ISO/IEC 27001:2022 není dostupná (žádný volný slot):** založ assessment podle
  zahrnuté šablony **Data Protection Baseline** se jménem `<ini>-DPB` ve skupině `<ini>-ISMS`
  (nespotřebuje prémiový slot; **neověřeno na tenantu**) a postupuj stejně. Do reportu zapiš
  licenční mezeru („organizace s E5 má 3 prémiové šablony zdarma; kurzovní tenant je měl
  obsazené").
- **Nejde založit ani to:** mapování SoA -> kontrola -> důkaz jako tabulka v reportu
  (sekce 4 šablony); assessment nahradí lektor projekcí.
- **Kontrola má jen technické akce:** vyber jiný řádek SoA (krok 5.2).
- **Při časové tísni:** 3 důkazy místo 5, report bez sekce 6 (AI governance zkrátit na
  odkaz na řádky SoA), obhajoba 2 minuty. Krok 8 nevypadává.

## Zdroje

- [Build and manage assessments](https://learn.microsoft.com/en-us/purview/compliance-manager-assessments)
- [Working with improvement actions](https://learn.microsoft.com/en-us/purview/compliance-manager-improvement-actions)
- [Compliance Manager scoring](https://learn.microsoft.com/en-us/purview/compliance-manager-scoring)
- [Learn about regulations](https://learn.microsoft.com/en-us/purview/compliance-manager-regulations)
