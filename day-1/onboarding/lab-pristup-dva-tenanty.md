# Lab · Přístup do dvou tenantů a vlastní scope

> Modul: `onboarding` · Odhad: 35 min · Režim: hands-on, vlastní scope (v tenantu se nic nenastavuje; mění se jen hesla a MFA vlastních účtů)
> Tenant: A `cloudedu.cz` + B `spdemo.online` · Scénář: [`../../scenario-isms-vltava.md`](../../scenario-isms-vltava.md)

## Cíl

Dva profily prohlížeče, v každém jeden kurzovní účet s funkčním MFA, a ověřený vlastní scope na
Tenant A — bez jediné změny v tenantu.

**Jak lab číst:** každý krok končí **Checkpointem** — nesedí-li, nepokračuj.

> [!WARNING] V tomto labu nic neukládej
> Admin centra jen otevíráš a čteš. Žádné tlačítko **Save**, **Create**, **Delete** ani
> **Enable**. Jsi Global Administrator — každé uložení platí pro celou učebnu. Jediné, co
> měníš, jsou hesla a MFA vlastních účtů (tvého a `test-<ini>`) na stránkách přihlášení.

## Předpoklady

- Lístek od lektora: účet na Tenant A (`jmeno.prijmeni@cloudedu.cz`), účet na Tenant B
  (`user.NN@spdemo.online`), dočasná hesla, tvoje iniciály `<ini>` (malými písmeny).
- Telefon s aplikací **Microsoft Authenticator**.
- Prohlížeč Microsoft Edge na učebním stroji.

## Kroky

### 1. Založ dva profily prohlížeče

V Edge vytvoř dva nové profily (ikona profilu vlevo nahoře -> přidat profil), **bez** přihlášení
osobním účtem a bez synchronizace:

| Profil | Název | Barva motivu |
|---|---|---|
| A | `GOC248 A` | např. modrá |
| B | `GOC248 B` | např. zelená |

Profil, ve kterém Edge běžel doteď, pro kurz nepoužívej.

**Checkpoint:** na liště jsou dvě okna Edge s rozdílnou barvou a názvem profilu `GOC248 A`
a `GOC248 B`.

### 2. Tenant A: první přihlášení a MFA

V okně **GOC248 A** otevři `https://www.office.com` a přihlas se účtem `@cloudedu.cz`. Změň dočasné
heslo. Až tě průvodce vyzve k zabezpečení účtu, zaregistruj **Microsoft Authenticator** (QR kód
-> v aplikaci přidat pracovní nebo školní účet -> schválit testovací oznámení).

Pokud tě průvodce nevyzve, otevři stránku **Security info** (`aka.ms/mysecurityinfo`) a metodu
přidej ručně.

**Checkpoint:** na stránce Security info v profilu A je uvedená metoda **Microsoft
Authenticator** a jako výchozí metoda je nastavené oznámení z aplikace.

### 3. Tenant A: kdo jsem a s jakou rolí

Stále v profilu A otevři Microsoft Entra admin center (`https://entra.microsoft.com`) ->
**Users** -> vyhledej sebe -> **Assigned roles**.

**Checkpoint:** v pravém horním rohu je účet `@cloudedu.cz` a v Assigned roles je **Global
Administrator**.

### 4. Tenant A: najdi svůj scope

V Entra admin center, profil A:

- **Groups** -> vyhledej `isms-<ini>-users`,
- **Users** -> vyhledej `test-<ini>`.

Nic neotevírej k úpravě, jen ověř, že existují. Zapiš si, kdo je členem `isms-<ini>-users`.

Pak zprovozni testovacího uživatele — v úterý za něj píšeš a schvaluješ dokumenty, ve středu
s ním zanecháš auditní stopu a ve čtvrtek na něm pilotuješ MFA. Z okna profilu A otevři
**nové okno InPrivate** (Ctrl+Shift+N), přihlas se na `https://www.office.com` jako
`test-<ini>@cloudedu.cz` heslem z lístku, změň heslo a zaregistruj Microsoft Authenticator jako
**druhý účet** ve stejné aplikaci. Nové heslo si poznač jen na lístek, ne do souboru. Okno
InPrivate zavři.

**Checkpoint:** skupina `isms-<ini>-users` i uživatel `test-<ini>` existují; obojí s **tvými**
iniciálami. V Authenticatoru jsou dva účty `@cloudedu.cz` (tvůj a `test-<ini>`). Neexistují-li,
hlas se lektorovi (skript přípravy prostředí) — nezakládej je sám.

### 5. Tenant A: prohlídka konzolí bez ukládání

V profilu A otevři a jen se rozhlédni:

| Konzole | Adresa | Co tu v kurzu děláme |
|---|---|---|
| Microsoft 365 admin center | `https://admin.microsoft.com` | licence (dnes v `requirements-mapping-m365`) |
| SharePoint admin center | z Microsoft 365 admin center -> **Admin centers** -> **SharePoint** | založení webu (dnes), Content Type Hub (D2) |
| Microsoft Purview portál | `https://purview.microsoft.com` | štítky, DLP, retence (D3), audit (D4), Compliance Manager (D5) |
| Microsoft Entra admin center | `https://entra.microsoft.com` | Conditional Access, PIM (D4) |

**Checkpoint:** všechny čtyři konzole se otevřely pod účtem `@cloudedu.cz`. **Negativní:**
v žádné z nich jsi nic neuložil — lektor se zeptá, a odpověď je „nic".

### 6. Tenant B: přihlášení a MFA — přepnutí tenantu

Přepni do okna **GOC248 B**. Otevři `https://www.office.com`, přihlas se účtem
`user.NN@spdemo.online`, změň heslo a zaregistruj Microsoft Authenticator stejně jako v kroku 2.
V aplikaci teď máš **dva** pracovní účty.

**Checkpoint (správný účet ve správném profilu):** okno má barvu a název profilu `GOC248 B`,
vpravo nahoře je účet `@spdemo.online` a na stránce Security info v tomto profilu je Microsoft
Authenticator.

### 7. Tenant B: tvůj web a hranice tvých práv

V profilu B otevři adresu svého webu `https://<tenant>.sharepoint.com/sites/isms-<ini>` (adresu
tenantu sdělí lektor).

Potom v témže profilu zkus otevřít `https://admin.microsoft.com`.

**Checkpoint:** web `isms-<ini>` se otevře a v nastavení webu (ozubené kolo) vidíš **Site
permissions** jako vlastník. **Negativní:** Microsoft 365 admin center tě na Tenant B nepustí
— nemáš tam admin roli. Pokud tě pustí, hlas se lektorovi: účet má roli navíc.

### 8. Negativní test: poznej špatný profil

V okně **GOC248 A** vlož adresu svého webu na **Tenant B** z kroku 7 a otevři ji. Sleduj, co se
stane: výběr účtu, žádost o přihlášení, nebo odmítnutí přístupu. **Nepřihlašuj se** — zavři
záložku.

**Checkpoint:** web Tenant B se v profilu A **neotevřel** s obsahem. Umíš říct, podle čeho jsi
to poznal (doména účtu vpravo nahoře, výzva k přihlášení, barva okna). Pokud se web otevřel
s obsahem, máš v profilu A přihlášený i účet B — odhlas ho a začni krok 1 znovu.

### 9. Pravidla týdne nahlas

Ve dvojici si odpovězte (lektor obchází):

1. Jak se bude jmenovat tvoje DLP politika ve středu?
2. Na koho smí cílit tvoje politika Conditional Access ve čtvrtek a v jakém režimu?
3. Co uděláš, když se ti v Authenticatoru objeví výzva, kterou jsi nevyvolal?

**Checkpoint:** odpovědi jsou „`<ini>-` + název", „jen `test-<ini>` / `isms-<ini>-users`,
report-only, nouzové účty vyloučené", „zamítnout a říct lektorovi".

### 10. Zapiš do SoA

V tomto labu **ne** — web `isms-<ini>` a seznam SoA vzniknou v
[`../isms-design-m365/`](../isms-design-m365/).

**Checkpoint:** nic — přeskoč.

## Ověření

- [ ] Dva profily Edge `GOC248 A` a `GOC248 B`, každý jiné barvy.
- [ ] Na obou tenantech je na stránce Security info zaregistrovaný Microsoft Authenticator.
- [ ] V Authenticatoru jsou i účet `test-<ini>@cloudedu.cz` a jeho nové heslo je jen na lístku.
- [ ] Na Tenant A máš roli Global Administrator; `isms-<ini>-users` a `test-<ini>` existují.
- [ ] Na Tenant B se otevře tvůj web `isms-<ini>` a jsi jeho vlastník.
- [ ] **Negativní:** na Tenant B tě Microsoft 365 admin center nepustí.
- [ ] **Negativní:** web Tenant B se v profilu A neotevřel s obsahem.
- [ ] **Negativní:** v žádné konzoli na Tenant A jsi nic neuložil.

## Fallback

- **Nelze naskenovat QR kód:** v Authenticatoru zvol zadání kódu ručně (nabídka pod
  skenerem). Jinak lektor — nikomu nediktuj heslo ani kód.
- **Průvodce MFA se nezobrazí a Security info nejde otevřít:** zavři všechna okna profilu,
  otevři znovu a přihlas se; jinak lektor (může jít o politiku tenantu).
- **Účet na Tenant B nefunguje:** pokračuj krokem 9 a B dokonči v přestávce — **nejpozději
  v úterý ráno** před `content-type-hub`. Bez MFA na B se v úterý nedostaneš k Autofill.
- **Edge na stroji nejde přidat profil:** použij pro jeden tenant Edge a pro druhý jiný
  nainstalovaný prohlížeč; pravidlo „pohled vpravo nahoru" platí dvojnásob.
- **Při časové tísni:** kroky 5 a 9 udělá lektor společně na projektoru; kroky 2, 6 a 8 se
  nevynechávají.

## Zdroje

- [Combined registration for SSPR and Microsoft Entra multifactor authentication](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-registration-mfa-sspr-combined)
- [Microsoft Entra licensing](https://learn.microsoft.com/en-us/entra/fundamentals/licensing)
