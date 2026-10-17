# Lab · DLP pro Copilot a prohlídka governance AI

> Modul: `copilot-governance-dspm` · Odhad: 40 min · Režim: hands-on, vlastní scope (DLP) + prohlídka jen ke čtení
> Tenant: A `cloudedu.cz` · Scénář: [`../../scenario-isms-vltava.md`](../../scenario-isms-vltava.md)

## Cíl

Na Tenant A existuje politika `<ini>-DLP-Copilot` v simulaci, scopovaná na `isms-<ini>-users`,
která vylučuje obsah se štítkem z dne 3 ze zpracování Copilotem — a student má zapsané, kde
se v tenantu rozhoduje o agentech a souhlasu správce.

**Jak lab číst:** každý krok končí **Checkpointem** — nesedí-li, nepokračuj.

## Předpoklady

- Profil prohlížeče pro **Tenant A**, Global Administrator.
- Tvůj štítek z bloku `sensitivity-labels` (den 3): `<ini>-ISMS důvěrné` ve skupině
  Důvěrné (dál „tvůj štítek"). Štítky lektorské taxonomie nepoužívej — sdílí je celá třída.
- Skupina `isms-<ini>-users` (založil lektor skriptem).
- Lektor potvrdil go/no-go: umístění **Microsoft 365 Copilot and Copilot Chat** je v DLP na
  Tenant A nabízené a DSPM má dokončené úvodní nastavení.

> [!WARNING] Tenantové obrazovky jsou v tomto labu jen ke čtení
> DSPM (krok 6), nastavení agentů (krok 7) a souhlas správce v Entra (krok 8) mění chování
> **celého tenantu** — všem 15 studentům i lektorovi. Nic tam neukládej, neaktivuj žádnou
> jednoklikovou politiku ani doporučení.

## Kroky

### 1. Ověř účet a profil

Zavři okna Tenant B. Otevři profil pro Tenant A.

**Checkpoint:** přihlášený účet končí `@cloudedu.cz`, jsi v profilu pro A. Žádné okno
s `@spdemo.online` není otevřené.

### 2. Založ politiku DLP pro Copilot

V Microsoft Purview portálu: **Data Loss Prevention** > **Policies** > **Create policy**.

1. Šablona **Custom** > **Custom policy**.
2. Název `<ini>-DLP-Copilot`, popis `Vylouceni obsahu se stitkem <ini> ze zpracovani Copilotem.`
3. Administrative units: **nevybírej** — umístění Copilot je nepodporuje.

**Checkpoint:** průvodce je na stránce **Locations** a politika se jmenuje `<ini>-DLP-Copilot`.

### 3. Umístění a scope

1. Zapni jen **Microsoft 365 Copilot and Copilot Chat**. Ostatní umístění se vypnou samy.
2. U umístění zvol scope **jen** skupinu `isms-<ini>-users` (*Edit* / *Specific users or
   groups* — přesné popisky ověř v UI).
3. Pokud UI nedovolí jiný scope než *All*, **nepokračuj**: politiku ulož ve stavu
   **Keep it off** a zapiš to jako nález (krok 9).

**Checkpoint:** u umístění Microsoft 365 Copilot and Copilot Chat je uvedená jen skupina
`isms-<ini>-users`; žádné jiné umístění není zapnuté.

### 4. Pravidlo pro štítek

1. **Create rule** — název `<ini>-R1-stitek`.
2. **Conditions**: *Content contains* > **Sensitivity labels** > tvůj štítek.
3. **Actions**: **Prevent Copilot from processing content**.
4. Nepřidávej do stejného pravidla podmínku na citlivé údaje — to dovolené není.

Volitelně, je-li v UI nabízené: druhé pravidlo `<ini>-R2-prompt` s podmínkou *Sensitive
information types* (např. Credit Card Number) a akcí *Prevent Copilot from processing
content* > *Processing prompts*. Je v preview a rolluje do tenantů s Copilotem — když chybí,
zapiš „nenabízeno na Tenant A".

**Checkpoint:** politika má pravidlo `<ini>-R1-stitek` se štítkem `<ini>-ISMS důvěrné`
a akcí Prevent Copilot from processing content.

### 5. Simulace a uložení

**Policy mode**: **Run the policy in simulation mode**. Nabízí-li průvodce automatické
zapnutí politiky po skončení simulace, **nezaškrtávej** ho. Ulož.

**Checkpoint:** v seznamu politik DLP je `<ini>-DLP-Copilot` ve stavu simulace. Úprava se
do Copilotu propisuje až za 4 hodiny — na Tenant A bez Copilota ji chováním neověříš;
důkazem je konfigurace.

**Checkpoint (negativní):** v seznamu politik DLP jsi neupravil žádnou politiku bez svého
prefixu `<ini>-` a žádná tvoje politika nemá scope *All users*.

### 6. DSPM — prohlídka jen ke čtení

Purview portál > **Solutions** > **DSPM** (ne položky s „(classic)").

1. **Objectives** — najdi cíl týkající se Copilotu a cíl týkající se oversharingu. Otevři
   jeden a přečti doporučené akce. **Nic nespouštěj.**
2. **AI observability** — kolik agentů a AI aplikací DSPM vidí?
3. **Discover** > **Data risk assessments** — je tu výchozí assessment? Co by ukázal
   o přesdílených webech?

Zapiš si odpovědi na tři otázky: Jak se jmenuje cíl pro Copilot? Proč jsou reporty
o Copilotu prázdné? Kde bys hledal web sdílený celé organizaci?

**Checkpoint:** máš zapsané tři odpovědi. **Negativní:** na stránce **Policies** / *Reports*
DSPM nepřibyla žádná politika, kterou jsi spustil ty (lektor zkontroluje počet před a po).

### 7. Kde se schvalují agenti — jen ke čtení

Microsoft 365 admin center > **Agents** > **Settings**. Zapiš aktuální hodnoty:
**Agent and plugin access** (tři volby), **Sharing**, **User access**. Pak *Agents* >
*All agents* > **Registry** — kolik agentů a jakého *Publisher type* vidíš?

Pokud na Tenant A položka *Agents* chybí (tenant nemá Copilot), zapiš „není k dispozici
na A" a hodnoty opiš z projekce lektora z Tenant B.

**Checkpoint:** máš zapsané hodnoty čtyř nastavení a u každé tenant, ze kterého pochází.
Nic nebylo uloženo.

### 8. Souhlas správce v Entra — jen ke čtení

Microsoft Entra admin center > **Entra ID** > **Enterprise apps** > **Consent and
permissions**. Přečti **User consent settings** a **Admin consent settings**: smí uživatelé
souhlasit s aplikacemi sami? Je zapnutý pracovní tok žádostí o souhlas správce a kdo je
posuzovatel?

**Checkpoint:** máš zapsané dvě hodnoty (souhlas uživatelů, admin consent workflow ano/ne).
Nic nebylo uloženo.

### 9. Zapiš do SoA

Ulož screenshoty politiky (krok 3–5) a zápis hodnot (krok 7–8) do knihovny
Documents (knihovna důkazů) webu `isms-<ini>`. Přidej řádky:

| Opatření | Požadavek | Aplikovatelné | Zdůvodnění | Capability M365 | Důkaz | Modul | Tenant |
|---|---|---|---|---|---|---|---|
| A.8.12 | dle mapovací matice | ano | obsah se štítkem nesmí Copilot použít v odpovědi | DLP, umístění Microsoft 365 Copilot and Copilot Chat, simulace | odkaz na screenshot politiky `<ini>-DLP-Copilot` | `copilot-governance-dspm` | A |
| A.5.12 | dtto | ano | klasifikace z D3 je podmínkou, co Copilot zpracuje | štítek `<ini>-...` jako podmínka pravidla DLP | odkaz na screenshot pravidla | `copilot-governance-dspm` | A |
| A.5.23 | dtto | ano | o agentech a souhlasu s oprávněními rozhoduje správce, ne uživatel | *Agent and plugin access*, *Sharing*, admin consent workflow | odkaz na zápis hodnot nastavení | `copilot-governance-dspm` | A (+ B z dema) |

Pokud politika zůstala vypnutá kvůli scope (krok 3), zapiš řádek A.8.12 s Aplikovatelné
= ano, Capability „navrženo, nenasazeno — scope na skupinu nebyl v UI k dispozici" a v
capstonu to uveď jako mezeru.

Vyplň i Stav zavedení, Prioritu, Termín a Odpovědnou osobu (u zavedených opatření Termín
necháš prázdný). Politika v simulaci nic neblokuje — u A.8.12 je poctivý stav
`Částečně zavedeno`; vypnutá politika (fallback výše) je `Plánováno`.

**Checkpoint:** v SoA jsou tři nové řádky s Modul = `copilot-governance-dspm` a funkčním
odkazem ve sloupci Důkaz.

## Ověření

- [ ] Politika `<ini>-DLP-Copilot` existuje, jediné umístění je Microsoft 365 Copilot and
      Copilot Chat, scope `isms-<ini>-users`, režim simulace (nebo vypnutá s nálezem).
- [ ] Pravidlo se štítkem s prefixem `<ini>-` a akcí Prevent Copilot from processing content.
- [ ] **Negativní:** žádná politika bez prefixu `<ini>-` upravená; žádná politika se scope
      *All users*; v DSPM nespuštěná žádná jednokliková politika.
- [ ] Zapsané tři odpovědi z DSPM a hodnoty nastavení agentů a souhlasu správce s tenantem.
- [ ] Tři řádky v SoA s odkazem na důkaz.

## Fallback

- **Umístění Copilot v DLP na Tenant A chybí:** politiku nezakládej. Lektor ukáže umístění
  na projekci (pokud ho má jiný tenant) nebo podle Learn; do SoA řádek A.8.12 jako „navrženo,
  na tenantu bez Copilota nedostupné" a v capstonu jako licenční mezera.
- **Scope na skupinu nejde nastavit:** politika zůstane *Keep it off* (krok 3) — nikdy
  *All users*, ani v simulaci.
- **DSPM chce dokončit úvodní nastavení:** neklikat, zavolat lektora — úvodní nastavení je
  tenantové a patří do přípravy.
- **Při časové tísni:** krok 6 jen na projekci lektora (kompresní ventil 2), krok 8 vypadne;
  kroky 2–5 a 9 se nekrátí. Řádky SoA podle tabulky v kroku 9.

## Zdroje

- [Microsoft Purview DLP for Microsoft 365 Copilot](https://learn.microsoft.com/en-us/purview/dlp-microsoft365-copilot-location-learn-about)
- [Learn about Data Security Posture Management (DSPM)](https://learn.microsoft.com/en-us/purview/data-security-posture-management-learn-about)
- [Agent settings in Microsoft 365 admin center](https://learn.microsoft.com/en-us/microsoft-365/admin/manage/agent-settings)
- [Configure the admin consent workflow](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/configure-admin-consent-workflow)
