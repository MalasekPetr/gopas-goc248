# Lab · PIM for Groups pro vlastníka ISMS webu

> Modul: `privileged-access-pim` · Odhad: 55 min · Režim: hands-on, vlastní scope (`<ini>-isms-admins`, `test-<ini>`)
> Tenant: A `cloudedu.cz` · Scénář: [`../../scenario-isms-vltava.md`](../../scenario-isms-vltava.md)

## Cíl

Skupina `<ini>-isms-admins` je vlastníkem webu `isms-<ini>` a `test-<ini>` do ní smí jen přes
PIM: na nejvýš 2 hodiny, s MFA, zdůvodněním a tvým schválením. Aktivace je dohledaná v historii
PIM a ve workspace je dokument Návrh rolí s nálezem k Global Administratorům.

**Jak lab číst:** každý krok končí **Checkpointem** — nesedí-li, nepokračuj.

## Předpoklady

- Profil prohlížeče **Tenant A**, vlastní kurzovní účet.
- Hotový [`../conditional-access/`](../conditional-access/): `test-<ini>` má MFA metodu (nebo
  platný TAP).
- Web `isms-<ini>` z [`../../day-1/isms-design-m365/`](../../day-1/isms-design-m365/).

## Kroky

### 1. Založ skupinu `<ini>-isms-admins`

Entra admin center → **Entra ID** → **Groups** → **New group**:

- **Group type:** Security · **Name:** `<ini>-isms-admins` · **Membership type:** Assigned
- **Microsoft Entra roles can be assigned to the group:** No (skupina nebude držet roli Entra)
- **Owners:** tvůj účet · **Members:** **nikoho**

**Checkpoint:** skupina existuje, typ Security, vlastník = ty, počet členů = 0.

### 2. Udělej ze skupiny vlastníka webu

Na webu `isms-<ini>`: **Nastavení** → **Oprávnění webu** → přidej skupinu `<ini>-isms-admins`
do skupiny **Vlastníci** webu (Full Control). Přesná cesta závisí na typu webu z dne 1 —
neověřeno na tenantu, lektor ukáže na projektoru.

**Checkpoint:** v oprávněních webu je `<ini>-isms-admins` ve skupině Vlastníci. `test-<ini>`
je na webu jen **členem** (přes `isms-<ini>-users`, nastavil lektor skriptem), mezi vlastníky
není.

### 3. Vezmi skupinu pod správu PIM

**ID Governance** → **Privileged Identity Management** → **Groups** → **Discover groups** →
vyber `<ini>-isms-admins` → **Manage groups** → **OK**.

> [!WARNING] Nevratný krok
> Skupinu pod správou PIM už ze správy vyjmout nejde. Ber jen **svou** skupinu — po kurzu se
> skupina smaže.

**Checkpoint:** `<ini>-isms-admins` je v seznamu **Groups** v PIM. Žádná cizí skupina, kterou
jsi tam nebyl předtím, nepřibyla.

### 4. Nastav pravidla aktivace členství

PIM → **Groups** → `<ini>-isms-admins` → **Settings** → **Member** → **Edit**:

- **Activation maximum duration:** 2 hodiny
- **On activation, require:** multifactor authentication
- **Require justification on activation:** ano
- **Require approval to activate:** ano → **Select approver(s)** → **tvůj účet**
- **Assignment** (eligible): **Expire eligible assignment after** — nepovolit trvalé
- **Notifications:** ponech výchozí; zkontroluj, že u aktivace a schválení je tvůj účet mezi
  příjemci

Po uložení udělej screenshot přehledu nastavení **Member** a ulož ho do knihovny ve workspace
`isms-<ini>` (stejné místo jako důkazy z ostatních bloků).

**Checkpoint:** v přehledu nastavení role **Member** je max. 2 h, MFA, justification, approval
se schvalovatelem = ty, bez trvalých eligible přiřazení. Nastavení **Owner** jsi neměnil.
Screenshot je ve workspace a máš jeho odkaz.

### 5. Dej `test-<ini>` eligible členství

PIM → **Groups** → `<ini>-isms-admins` → **Assignments** → **Add assignments** → **Select role:
Member** → `test-<ini>` → **Next** → **Assignment type: Eligible** → konec platnosti = poslední
den kurzu → **Assign**.

**Checkpoint:** v **Eligible assignments** je `test-<ini>` s datem konce. **Negativní:** v Entra
ID → **Groups** → `<ini>-isms-admins` → **Members** je pořád **0 členů** — eligible není člen.

### 6. Aktivuj členství jako `test-<ini>`

InPrivate okno profilu Tenant A → přihlas se jako `test-<ini>` do Entra admin center →
**ID Governance** → **Privileged Identity Management** → **My roles** → **Groups** → u
`<ini>-isms-admins` **Activate** → doba 1 h → **Reason:** např. „Úprava SoA po auditu, změna
CHG-<ini>-01" → **Activate**. Zapiš si čas (místní).

**Checkpoint:** `test-<ini>` musel projít MFA a vidí oznámení, že žádost čeká na schválení.
V **My requests** → **Groups** je žádost ve stavu čekání.

### 7. Schval žádost svým účtem

Hlavní okno (tvůj účet) → PIM → **Approve requests** → **Groups** → žádost od `test-<ini>` →
**Approve** → **Justification:** „Schváleno pro změnu CHG-<ini>-01" → **Confirm**.

**Checkpoint:** PIM → **Groups** → `<ini>-isms-admins` → **Assignments** → **Active
assignments** ukazuje `test-<ini>` s časem konce (nejvýš 2 h od aktivace). V Entra ID → Groups →
Members je teď `test-<ini>`.

### 8. Pozoruj přístup na web (doplňkové)

V InPrivate okně jako `test-<ini>` otevři `https://<tenant>.sharepoint.com/sites/isms-<ini>`
→ **Nastavení** → **Oprávnění webu**. Člen webu tam správu oprávnění nemá, vlastník ano. Zapiš:
čas pokusu, zda `test-<ini>` vidí správu oprávnění, případně kolik minut po schválení se to
změnilo.

**Checkpoint:** v dokumentu (krok 10) je zapsaný skutečný výsledek s časem — i „přístup se do
konce labu neprojevil" je platný výsledek. Nic nedopisuj z očekávání.

### 9. Najdi stopu v historii PIM

PIM → **Groups** → `<ini>-isms-admins` → **Resource audit** → dnešní den. Udělej screenshot
a ulož ho do knihovny ve workspace `isms-<ini>`.

Pak otevři (jen čtení) PIM nastavení **Member** u skupiny souseda `<xy>-isms-admins`.

**Checkpoint:** v Resource audit jsou záznamy o přiřazení eligible, žádosti `test-<ini>`
a tvém schválení. **Negativní:** u sousedovy skupiny je schvalovatelem soused, ne ty — tvé
nastavení se ho nedotklo.

### 10. Sepiš nález a návrh rolí

Ve workspace vytvoř dokument **Návrh rolí** podle
[`comparison-least-privilege-roles.md`](comparison-least-privilege-roles.md): pro každý den
kurzu jedna řádka „co jsme dělali → jaká role by stačila". Pod tabulku napiš jednu větu nálezu
pro vedení Vltava Servis a do druhé sekce výsledek kroku 8.

**Checkpoint:** dokument má aspoň 5 řádků, u každé role je odkaz na zdroj nebo poznámka
„ověřit"; nález obsahuje slovo Global Administrator a navrhovaný počet stálých
Global Administratorů.

### 11. Zapiš do SoA

Do seznamu SoA ve workspace `isms-<ini>` přidej řádky (Modul = `privileged-access-pim`,
Tenant = A):

| Opatření | Aplikovatelné | Capability M365 | Důkaz |
|---|---|---|---|
| A.5.15 | ano | PIM for Groups — vlastnictví ISMS webu přes skupinu s pravidly aktivace | odkaz na screenshot nastavení Member (krok 4) |
| A.5.18 | ano | eligible přiřazení s koncem platnosti, schválení, Resource audit | odkaz na screenshot Resource audit (krok 9) |
| A.8.2 | ano | JIT vlastnictví webu; návrh rolí s nejmenšími oprávněními | odkaz na dokument Návrh rolí |

Vyplň i Stav zavedení, Prioritu, Termín a Odpovědnou osobu (u zavedených opatření Termín
necháš prázdný).

**Checkpoint:** v SoA jsou 3 nové řádky s vyplněným sloupcem Důkaz a Modul =
`privileged-access-pim`.

## Ověření

- [ ] `<ini>-isms-admins`: Security, bez přímých členů před aktivací, vlastník webu `isms-<ini>`.
- [ ] Skupina pod správou PIM; nastavení Member: 2 h, MFA, justification, approval (ty).
- [ ] **Negativní:** před aktivací `test-<ini>` není členem skupiny v Entra Groups.
- [ ] Aktivace `test-<ini>` schválená, Active assignment s koncem.
- [ ] Resource audit zachycen ve workspace.
- [ ] **Negativní:** nastavení skupiny souseda se nezměnilo.
- [ ] Dokument Návrh rolí s nálezem; 3 řádky SoA.

## Fallback

- **Přístup na web se po aktivaci neprojevil:** očekávané podle dokumentace (až 24 h ve
  scénářích se SharePointem). Důkazem je Active assignment a Resource audit, ne web.
- **`test-<ini>` nevidí v My roles nic:** eligible přiřazení může chvíli trvat, nebo nemá
  licenci P2 — po pár minutách se odhlásit a přihlásit; pak lektor.
- **`test-<ini>` neprojde MFA při aktivaci:** zkus platný TAP z ranního bloku; když vypršel,
  vytvoř nový (krok 3 v [`../conditional-access/lab-ca-policy-set.md`](../conditional-access/lab-ca-policy-set.md)).
  Zda TAP splní požadavek „On activation, require MFA" v PIM, je **neověřeno** — když ne,
  vypni v kroku 4 MFA při aktivaci a zapiš to do dokumentu jako odchylku.
- **Schvalovací žádost nepřišla / vypršela (24 h):** `test-<ini>` podá novou.
- **Někdo přidal `test-<ini>` přímo do skupiny:** odeber ho v Entra Groups a zapiš to do
  dokumentu jako nález „obejití PIM".
- **Při časové tísni (ventil dne č. 2):** v kroku 4 bez schválení, kroky 6 a 7 sloučit —
  schvalovací tok ukáže lektor na projektoru. Krok 10 převzít z
  [`reseni-pim-for-groups.md`](reseni-pim-for-groups.md).

## Zdroje

- [PIM for Groups](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/concept-pim-for-groups)
- [Configure PIM for Groups settings](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/groups-role-settings)
- [Activate group membership or ownership](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/groups-activate-roles)
- [Approve activation requests for groups](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/groups-approval-workflow)
- [Audit activity history for groups](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/groups-audit)
