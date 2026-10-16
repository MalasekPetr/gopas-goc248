# Lab · Sada CA politik pro testovacího uživatele a MFA pilot

> Modul: `conditional-access` · Odhad: 60 min · Režim: hands-on, vlastní scope (`test-<ini>`)
> Tenant: A `cloudedu.cz` · Scénář: [`../../scenario-isms-vltava.md`](../../scenario-isms-vltava.md)

## Cíl

Čtyři politiky `<ini>-CA0x` zacílené **jen** na `test-<ini>`, s vyloučenou skupinou nouzových
účtů; tři v report-only, MFA pilot vynucený. Dopad ověřený ve What If a v sign-in logu, návrh
zapsaný ve workspace a v SoA.

**Jak lab číst:** každý krok končí **Checkpointem** — nesedí-li, nepokračuj.

> [!WARNING] Tento lab může zamknout celou učebnu
> Jsi Global Administrator. Politika s *All users* a bez vyloučení nouzových účtů, přepnutá na
> **On**, zablokuje i lektora. Proto: v **Include** je vždy jen uživatel `test-<ini>`, v
> **Exclude** vždy skupina nouzových účtů, a na **On** se přepíná jen krok 7 — po kontrole
> sousedem.

## Předpoklady

- Profil prohlížeče **Tenant A**, přihlášený vlastním účtem `jmeno.prijmeni@cloudedu.cz`.
- Uživatel `test-<ini>` existuje (založil lektor skriptem) a jeho počáteční heslo máš od lektora.
- Název skupiny nouzových účtů ti sdělí lektor (v repu záměrně není).
- Lektor potvrdil: security defaults vypnuté, TAP povolený pro testovací uživatele.

## Kroky

### 1. Ověř účet, profil a výchozí stav tenantu

Microsoft Entra admin center → vpravo nahoře zkontroluj účet. Pak **Entra ID** → **Conditional
Access** → **Policies**. Projdi seznam, **nic neměň**: najdi politiky se sloupcem *Created by* =
Microsoft (Microsoft-managed) a politiky ostatních studentů (`xy-CA..`).

**Checkpoint:** v pravém horním rohu je tvůj kurzovní účet na `cloudedu.cz` (ne osobní, ne
Tenant B). Umíš lektorovi ukázat aspoň jednu politiku, kterou nevytvořil žádný student, a říct
její stav (Report-only / On / Off).

### 2. Zapiš návrh sady do workspace

Ve webu `isms-<ini>` vytvoř stránku nebo dokument **Návrh CA politik** s tabulkou:

| Politika | Persona | Prostředek | Podmínka | Řízení přístupu | Stav v kurzu |
|---|---|---|---|---|---|
| `<ini>-CA01-Pilot-AllResources-MFA` | pilot (`test-<ini>`) | All resources | — | authentication strength *Multifactor authentication* | **On** (krok 7) |
| `<ini>-CA02-Pilot-AllResources-LegacyAuth-Block` | pilot | All resources | client apps: Exchange ActiveSync, Other clients | Block | Report-only |
| `<ini>-CA03-Pilot-AllResources-SigninRiskMedHigh-MFA` | pilot | All resources | sign-in risk Medium + High | authentication strength *MFA* + sign-in frequency *Every time* | Report-only |
| `<ini>-CA04-Pilot-AllResources-UserRiskHigh-RiskRemediation` | pilot | All resources | user risk High | *Require risk remediation* | Report-only |

Pod tabulku napiš jednu větu: jak by vypadala persona **Admins** ve Vltava Servis a jakou sílu
ověření by dostala.

**Checkpoint:** dokument je uložený v `isms-<ini>`, má 4 řádky a každý název začíná tvými
iniciálami. Věta o personě Admins zmiňuje phishing-resistant MFA.

### 3. Onboarding `test-<ini>` přes Temporary Access Pass

1. Entra admin center → **Entra ID** → **Users** → `test-<ini>` → **Authentication methods** →
   **Add authentication method** → **Temporary Access Pass**. Délku nech podle výchozí politiky
   (nastavil lektor), **Add**. Hodnotu si opiš **hned** — po zavření ji už neuvidíš.
2. Otevři **InPrivate okno** profilu Tenant A, přihlas se jako `test-<ini>` na stránce
   **Security info** (My Sign-Ins), zadej TAP a zaregistruj **Microsoft Authenticator** (druhý
   účet v aplikaci na tvém telefonu). Má-li `test-<ini>` metodu už ze dne 3, přihlášení přes
   TAP i tak proveď — cvičíš onboarding — a novou registraci přeskoč.
3. InPrivate okno zavři.
4. Do dokumentu **Návrh CA politik** připiš sekci *Onboarding*: kdo TAP vytvořil, jakou měl
   životnost, jak byl předán a jaká metoda se zaregistrovala (2–3 věty, bez hodnoty TAP).

**Checkpoint:** v hlavním okně u `test-<ini>` → **Authentication methods** je vidět
*Temporary Access Pass* a aspoň jedna další MFA metoda (nebo podle fallbacku jen vícenásobný
TAP). Tvůj vlastní účet žádný nový TAP nemá. Dokument má sekci *Onboarding* a hodnota TAP
v něm není.

### 4. Vytvoř MFA pilot — zatím v report-only

**Conditional Access** → **Policies** → **New policy**:

- **Name:** `<ini>-CA01-Pilot-AllResources-MFA`
- **Users** → **Include** → *Select users and groups* → *Users and groups* → **jen** `test-<ini>`
- **Users** → **Exclude** → *Users and groups* → **skupina nouzových účtů**
- **Target resources** → *All resources*
- **Grant** → *Grant access* → *Require authentication strength* → **Multifactor authentication**
- **Enable policy:** **Report-only** → **Create**

**Checkpoint:** politika je v seznamu se stavem *Report-only*. V jejím detailu: Include = 1 uživatel
(`test-<ini>`), Exclude = 1 skupina (nouzové účty). Slovo *All users* se v přiřazení nevyskytuje.

### 5. Doplň zbylé tři politiky (report-only)

Stejně jako v kroku 4 — vždy Include jen `test-<ini>`, Exclude skupina nouzových účtů, *All
resources*, stav **Report-only**:

- `<ini>-CA02-...-LegacyAuth-Block`: **Conditions** → **Client apps** → *Configure: Yes* → jen
  *Exchange ActiveSync clients* a *Other clients*; **Grant** → *Block access*.
- `<ini>-CA03-...-SigninRiskMedHigh-MFA`: **Conditions** → **Sign-in risk** → *High* a *Medium*;
  **Grant** → *Require authentication strength* → *Multifactor authentication*; **Session** →
  *Sign-in frequency* → *Every time*.
- `<ini>-CA04-...-UserRiskHigh-RiskRemediation`: **Conditions** → **User risk** → *High*;
  **Grant** → *Require risk remediation* (authentication strength a sign-in frequency se doplní
  samy).

Sign-in risk a user risk **nedávej do jedné politiky**.

**Checkpoint:** v seznamu politik je filtr na `<ini>-` → 4 politiky, CA01–CA04 ve stavu
*Report-only*. U CA04 je v *Session* vidět *Sign-in frequency: Every time*.

### 6. Ověř ve What If — pozitivně i negativně

**Policies** → **What If**. Vždy vyplň: **identitu**, **jednu konkrétní aplikaci** (ne skupinu
aplikací jako *Office 365* — ta se nespáruje; vyber aplikaci SharePointu podle zobrazovaného
názvu), **Device platform** *Windows*, **Client app** *Browser*.

| Běh | Identita | Riziko | Co má vyjít |
|---|---|---|---|
| a | `test-<ini>` | žádné | CA01 mezi uplatněnými; CA02, CA03, CA04 mezi neuplatněnými (s důvodem) |
| b | `test-<ini>` | Sign-in risk *Medium* | CA01 a CA03 mezi uplatněnými |
| c | `test-<ini>` | User risk *High* | CA01 a CA04 mezi uplatněnými |
| d | **tvůj vlastní účet** | žádné | **žádná** `<ini>-` politika mezi uplatněnými |
| e | `test-<xy>` **souseda** | žádné | **žádná** `<ini>-` politika mezi uplatněnými |

Microsoft-managed politiky a politiky jiných studentů se ve výsledcích objeví také — pro tento
krok tě zajímají **jen** `<ini>-` politiky.

**Checkpoint:** běhy a–c odpovídají tabulce. **Negativní:** v bězích d a e je každá tvoje
`<ini>-` politika v sekci neuplatněných a důvod ukazuje na přiřazení uživatele.

### 7. Čtyři oči, pak zapni MFA pilot

Pozvi souseda k obrazovce. Soused otevře tvou `<ini>-CA01` a nahlas přečte Include a Exclude.
Teprve pak přepni **Enable policy** na **On** → **Save**.

**Checkpoint:** soused potvrdil: Include = jen `test-<ini>`, Exclude = skupina nouzových účtů.
`<ini>-CA01` má stav *On*, CA02–CA04 zůstaly *Report-only*.

### 8. Přihlas se jako `test-<ini>` a najdi stopu v sign-in logu

1. Nové InPrivate okno profilu Tenant A → přihlas se jako `test-<ini>` do Microsoft 365.
   Zapiš si čas přihlášení (místní čas).
2. Zpět ve svém účtu: **Entra ID** → **Monitoring & health** → **Sign-in logs** → filtr
   *Username* = `test-<ini>`, poslední hodina. Otevři záznam → záložky **Conditional Access**
   a **Report-only**.
3. Do dokumentu **Návrh CA politik** dopiš: čas přihlášení, čas, kdy se záznam v logu objevil,
   výsledek CA01 a výsledky CA02–CA04 tak, jak je log ukazuje.

**Checkpoint:** přihlášení `test-<ini>` vyžadovalo druhý faktor. V záznamu sign-in logu je
`<ini>-CA01` na záložce *Conditional Access* a CA02–CA04 na záložce *Report-only* s nějakým
výsledkem (*Report-only: ...*). Do dokumentu jsou opsané skutečné hodnoty, ne očekávané.

### 9. Zapiš do SoA

Do seznamu SoA ve workspace `isms-<ini>` přidej řádky (Modul = `conditional-access`,
Tenant = A):

| Opatření | Aplikovatelné | Capability M365 | Důkaz |
|---|---|---|---|
| A.5.15 | ano | Conditional Access — politiky po personách, `<ini>-CA01`–`CA04` | odkaz na dokument Návrh CA politik |
| A.5.17 | ano | Temporary Access Pass pro onboarding, authentication methods | odkaz na dokument (sekce Onboarding z kroku 3) |
| A.8.5 | ano | authentication strength MFA, risk-based CA v report-only | odkaz na dokument (výsledky sign-in logu z kroku 8) |

Zdůvodnění piš vlastními slovy; u A.8.5 uveď, co by Vltava Servis bez Entra ID P2 nemohla.

**Checkpoint:** v SoA jsou 3 nové řádky s vyplněným sloupcem Důkaz a Modul =
`conditional-access`.

## Ověření

- [ ] Dokument Návrh CA politik ve workspace se 4 politikami a personou Admins.
- [ ] `test-<ini>` má zaregistrovaný Authenticator (nebo TAP podle fallbacku).
- [ ] 4 politiky `<ini>-CA01`–`CA04`: Include jen `test-<ini>`, Exclude skupina nouzových účtů.
- [ ] Jen CA01 je *On*, ostatní *Report-only*.
- [ ] What If běhy a–c odpovídají očekávání.
- [ ] **Negativní:** What If pro vlastní účet a pro `test-<xy>` souseda — žádná `<ini>-` politika
      se neuplatní.
- [ ] Sign-in log `test-<ini>` ukazuje CA01 a report-only výsledky CA02–CA04.
- [ ] 3 řádky SoA s důkazem.

## Fallback

- **Záznam v sign-in logu se do konce labu neobjevil:** doložit What If (screenshot běhu a)
  a do dokumentu zapsat čas přihlášení; log zkontrolovat na začátku
  [`../privileged-access-pim/`](../privileged-access-pim/). Latence logu na Tenant A zatím
  nebyla změřena — zapiš, co jsi viděl, s časem.
- **`test-<ini>` nemůže zaregistrovat Authenticator (bez telefonu):** vytvoř vícenásobný TAP;
  TAP splňuje sílu *Multifactor authentication* a pilot projde. Zapiš to do dokumentu jako
  odchylku.
- **TAP se při přihlášení nenabídne:** `test-<ini>` není v rozsahu TAP politiky nebo TAP vypršel
  — zavolej lektora (politika je tenantová, neopravuj ji sám).
- **`test-<ini>` je zablokovaný MFA pilotem:** přepni `<ini>-CA01` na *Report-only*, nic jiného
  neměň, zavolej lektora.
- **Při časové tísni (ventil dne č. 1):** všechny čtyři politiky vytvoř, ale ve What If
  (krok 6) proveď jen běhy a a e — risk-based politiky zůstanou v report-only bez vyhodnocení.
  Řádky SoA převzít z [`reseni-ca-policy-set.md`](reseni-ca-policy-set.md).

## Zdroje

- [Plan a Conditional Access deployment](https://learn.microsoft.com/en-us/entra/identity/conditional-access/plan-conditional-access)
- [The Conditional Access What If tool](https://learn.microsoft.com/en-us/entra/identity/conditional-access/what-if-tool)
- [Report-only mode](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-conditional-access-report-only)
- [Risk policies](https://learn.microsoft.com/en-us/entra/id-protection/howto-identity-protection-configure-risk-policies)
- [Temporary Access Pass](https://learn.microsoft.com/en-us/entra/identity/authentication/howto-authentication-temporary-access-pass)
