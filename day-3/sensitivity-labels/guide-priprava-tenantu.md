# Příprava Tenant A pro den 3 — lektor

Referenční postup pro lektora. Platí pro celý den 3 (`sensitivity-labels`, `dlp`,
`retention-lifecycle`). Studenti tento soubor nepotřebují.

> [!WARNING] Neověřeno na tenantu — stav k 2026-10.
> Postup je sestavený z Microsoft Learn (zdroje u každého kroku). Zkušební průchod na Tenant A
> proběhne v ověřovacím kole (prosinec 2026); výsledky a časy propagace zapsat do
> `mereni-propagace.md` v tomto modulu s datem.

## Časová osa

| Kdy | Co | Proč tak brzy |
|---|---|---|
| **T−10 dní** (nejpozději T−7 před středou) | kroky 1–7 | publikovaný retenční štítek se v SharePointu objeví „obvykle do jednoho dne, ale počítejte až se sedmi dny" ([Learn](https://learn.microsoft.com/en-us/purview/create-apply-retention-labels)) |
| **T−2 dny** (nejpozději neděle před kurzem) | kontrola členství skupin `isms-<ini>-users`, krok 8 | label policy závislá na nové skupině nebo změně členství se propisuje 24–48 h ([Learn](https://learn.microsoft.com/en-us/purview/create-sensitivity-labels)) |
| **Úterý večer** (den 2) | go/no-go kontrola dne 3 (konec souboru) | weby `isms-<ini>` vznikají v pondělí; teprve teď lze ověřit, že kurzovní štítky jsou na každém webu vidět |
| **Po kurzu** | úklid (konec souboru) | záznamy a retence blokují mazání webů |

## 1. Zjisti schéma štítků — a nic nemigruj

Purview portál → **Solutions** → **Information Protection** → **Sensitivity labels**.

- Zelený pruh o úspěšné migraci = **modern label scheme** (label groups místo nadřazených
  štítků). Tenanty založené od 2025-10-01 ho mají automaticky
  ([Learn: migrate label scheme](https://learn.microsoft.com/en-us/purview/migrate-sensitivity-label-scheme)).
- Pruh **Migrate to the modern label scheme** = classic schéma. **Nemigrovat** — migrace je
  nevratná. Laby mají variantu pro obě schémata.

**Výsledek zapiš:** schéma = modern / classic. Podle něj se v labu volí krok 4a nebo 4b.

## 2. Zapni sensitivity labels pro soubory v SharePointu a OneDrivu

Bez tohoto nastavení SharePoint nezpracuje obsah šifrovaných souborů, výchozí štítek knihovny
nejde nastavit a v knihovně nejsou vidět názvy štítků
([Learn](https://learn.microsoft.com/en-us/purview/sensitivity-labels-sharepoint-onedrive-files)).

- Portál: **Information Protection** → **Sensitivity labels** → pruh „turn on the ability to
  process content in Office online files" → **Turn on now** (jen Global Administrator).
- Nebo PowerShell (SharePoint Online Management Shell; `$AdminUrl` = adresa SharePoint admin
  centra tenantu z lektorského souboru):

```powershell
Connect-SPOService -Url $AdminUrl
(Get-SPOTenant).EnableAIPIntegration
Set-SPOTenant -EnableAIPIntegration $true
```

Tenantová změna SharePointu se podle Learn projeví zhruba za 15 minut.

**Ověření:** `(Get-SPOTenant).EnableAIPIntegration` vrací `True`.

## 3. Zapni štítky pro kontejnery (weby, skupiny, týmy)

Dva kroky, oba tenantové
([Learn: Purview](https://learn.microsoft.com/en-us/purview/sensitivity-labels-teams-groups-sites),
[Learn: Entra](https://learn.microsoft.com/en-us/entra/identity/users/groups-assign-sensitivity-labels)):

1. V Entra nastavit `EnableMIPLabels = True` v nastavení skupin (vyžaduje aspoň jednu aktivní
   licenci Microsoft Entra ID P1). Postup a skript jsou na stránce Entra; když hodnota už je
   `True`, nic nedělat.
2. Synchronizovat štítky do Entra ID:

```powershell
Connect-IPPSSession
Execute-AzureAdLabelSync
```

Podle Learn může po synchronizaci trvat až 24 h, než je štítek dostupný pro skupiny.

**Ověření:** při vytváření štítku je dostupný scope **Groups & sites**.

## 4. Vytvoř kurzovní taxonomii

Návrh a zdůvodnění je v [`reseni-stitky-isms.md`](reseni-stitky-isms.md) (část A). Technické
shrnutí:

| Pořadí (priorita) | Název (Name) | Zobrazovaný název | Scope | Ochrana |
|---|---|---|---|---|
| 1 | `GOC248-Verejne` | Veřejné | Files & other data assets, Emails | žádná |
| 2 | `GOC248-Interni` | Interní | Files & other data assets, Emails, Groups & sites | zápatí `Vltava Servis - interni`; kontejner: Privacy **None**, externí sdílení jen stávající hosté |
| 3 | skupina `GOC248-Duverne` | Důvěrné | — (label group / v classic schématu nadřazený štítek bez ochrany) | — |
| 3.1 | `GOC248-Duverne-Vltava` | Vltava (v aplikacích „Důvěrné \ Vltava") | Files & other data assets, Emails, Groups & sites | záhlaví `VLTAVA SERVIS - DUVERNE`; kontejner: Privacy **None**, externí sdílení jen lidé v organizaci |
| 4 | `GOC248-Prisne-duverne` | Přísně důvěrné | Files & other data assets, Emails | šifrování **Assign permissions now**, všichni uživatelé organizace jako Co-Author, **User access to content expires = Never**; vodoznak `PRISNE DUVERNE` |

Pravidla, která drží zbytek týdne:

- **Privacy = None** u kontejnerových štítků. Public/Private by soukromí skupiny zamklo a zasáhlo
  do dnů 4 a 5.
- **Šifrování jen u Přísně důvěrné** a nikdy s expirací — se expirací SharePoint obsah
  nezpracuje a štítek se v Office for the web nezobrazí
  ([Learn](https://learn.microsoft.com/en-us/purview/sensitivity-labels-sharepoint-onedrive-files)).
  Žádný krok labu na Přísně důvěrné nestojí.
- Studentské štítky vznikají **uvnitř skupiny Důvěrné** — tím mají prioritu danou skupinou
  a nikdo nemusí přeřazovat sdílený seznam.

## 5. Publikuj kurzovní label policy

**Information Protection** → **Publishing policies** → **Publish label**:

| Nastavení | Hodnota |
|---|---|
| Název | `GOC248 - kurzovni stitky` |
| Štítky | Veřejné, Interní, Důvěrné \ Vltava, Přísně důvěrné (v classic schématu i nadřazený Důvěrné) |
| Admin units | Full directory |
| Uživatelé a skupiny | všech 15 skupin `isms-<ini>-users` + lektorský účet — **ne All users** |
| Justification pro odstranění / snížení štítku | **zapnuto** |
| Default label (dokumenty, e-maily, kontejnery) | **žádný** |
| Mandatory labeling | **vypnuto** |

Proč tak: zapnutá justifikace musí platit pro `test-<ini>` i tehdy, když se studentova vlastní
policy nestihne propsat — stopa pro den 4 na tom stojí. Výchozí ani povinný štítek by se
v dalších dnech propsaly do práce celé třídy.

## 6. Kurzovní záznamový štítek (retention label)

Purview → **Solutions** → **Records Management** → **File plan** → **Create a label**
([Learn: declare records](https://learn.microsoft.com/en-us/purview/declare-records)):

| Nastavení | Hodnota |
|---|---|
| Název | `GOC248 ISMS zaznam` (název nejde později změnit) |
| Popis pro uživatele | „Jen pro kurz GOC248 (ISMS workspace isms-*). Jinde nepoužívat — záznam nejde smazat." |
| Retence | ponechat **1 rok**, počátek **When items were labeled** |
| Mark items as a record | **ano**, ne regulatory record |
| Record status | **zamčený** (nezapínat odemčení jako výchozí) |
| Po skončení | **Deactivate retention settings** |

Publikace: **Policies** → **Label policies** → **Publish labels**, název `GOC248 ISMS zaznam
publikace`, **Static**, lokace **SharePoint classic and communication sites = All** a **Microsoft
365 Group mailboxes & sites = All** (týmové weby připojené ke skupině nejsou v lokaci SharePoint
— [Learn: retention settings](https://learn.microsoft.com/en-us/purview/retention-settings)).

Publikace štítku do všech webů nic neaplikuje — jen zpřístupní volbu v nabídce **Apply label**.
Doba 1 rok úklid **neusnadňuje**: i po *Deactivate retention settings* zůstává u záznamu
omezení zamčení a odemčení ([Learn: retention settings](https://learn.microsoft.com/en-us/purview/retention-settings)).
Záznamy se po kurzu odstraňují podle úklidu níže. Realistický návrh (5 let, disposition review)
si studenti dělají na vlastním štítku.

> [!WARNING] Tenant A sdílí i jiný kurz
> Tenant A je stejný Developer tenant jako v kurzu SPO_DEV_1 (environment.md). Štítek
> publikovaný do *All* webů je v nabídce **Apply label** i na webech jiných kurzů a záznam s ním
> nejde smazat. Zmírnění: popis „Jen pro kurz GOC248", publikace nejdřív T−10 dní a **odebrání
> policy hned po běhu**; kolizi termínů se SPO_DEV_1 ověřit předem. Alternativa bez tohoto
> rizika: publikovat štítek až v pondělí večer na výčet webů `isms-<ini>` — za cenu, že do
> středy nemusí být vidět (až 7 dní).

## 7. Tenantová nastavení, na která se nesahá

- **Regulatory record**: nespouštět `Set-RegulatoryComplianceUI -Enabled $true`. Regulatory
  record po aplikaci nikdo, ani Global Administrator, neodstraní
  ([Learn](https://learn.microsoft.com/en-us/purview/records-management)).
- **Preservation Lock**: nikdy. Zamčenou politiku nelze vypnout, smazat ani zmírnit
  ([Learn](https://learn.microsoft.com/en-us/purview/retention)).
- **Records Management settings** → **Retention Labels**: zkontrolovat, že **Enable record
  versioning** je zapnuté (lab odemyká a zamyká záznam) a zapsat hodnotu nastavení pro mazání
  položek se standardním retenčním štítkem.

## 8. DLP a testovací data

- Lektorská demo politika `LEKTOR-DLP-demo` v simulaci na lektorský web — stejné nastavení jako
  v [`../dlp/reseni-dlp-simulace.md`](../dlp/reseni-dlp-simulace.md), vytvořená **T−2 dny**, aby
  ve středu měla výsledky simulace a upozornění pro kompresní ventil 2.
- **Testovací rodné číslo**: Purview má vestavěný typ citlivé informace *Czech personal identity
  number* ([Learn](https://learn.microsoft.com/en-us/purview/sit-defn-czech-personal-identity-number)).
  Vybrat fiktivní hodnotu a ověřit ji testem SIT v Purview (Data classification → Sensitive info
  types → Czech personal identity number → **Test**). Kandidát k ověření: `491231/0007`
  (formát nové podoby s lomítkem). **Otevřená otázka:** zda funkce SIT kontroluje platnost data
  narození — výsledek testu zapsat. Hodnotu napsat studentům na tabuli; do repa jen po ověření.
- Lab DLP má jako hlavní podmínku **štítek** (deterministická shoda), SIT je druhá podmínka.

## 9. SharePoint Advanced Management

SAM funkce (inactive site policy, site attestation) vyžadují kromě základní licence E3/E5
**buď přiřazenou licenci Microsoft Copilot, nebo add-on SAM Plan 1, nebo Microsoft 365 E7**
([Learn: SAM prerequisites](https://learn.microsoft.com/en-us/sharepoint/sharepoint-advanced-management-prerequisites)).
Tenant A Copilot nemá. Ověřit v SharePoint admin centru → **Policies** → **Site lifecycle
management**, zda je stránka dostupná. Když ne, demo v `retention-lifecycle` odpadá a platí
kompresní ventil 3.

## Go/no-go — úterý večer

- [ ] Na **každém** webu `isms-<ini>` je v knihovně „Řízená dokumentace" v podokně podrobností
      dokumentu nabídka **Apply label** se štítkem `GOC248 ISMS zaznam` (kontrola lektorským
      účtem namátkou na 3 webech + celá třída ráno v kroku 1 labu `retention-lifecycle`).
- [ ] Účet `test-<ini>` (namátkou 3) vidí v Office for the web štítky Veřejné, Interní,
      Důvěrné \ Vltava.
- [ ] Kontejnerový štítek Interní je nabízen v **Site information** webu `isms-<ini>`.
- [ ] Účty `test-<ini>` mají licenci s Purview (E5) a jsou členy `isms-<ini>-users` i členy
      webu `isms-<ini>`.
- [ ] Na tenantu nejsou politiky, štítky ani auto-labeling politiky z předchozího běhu (prefix
      iniciál studentů).

**Když go/no-go selže:** chybí-li kurzovní záznamový štítek na webech, krok 5 labu
`retention-lifecycle` a krok 4 stopy pro den 4 běží na lektorském webu jako demo a studenti
zapisují do poznámky čas demonstrace. Chybí-li kurzovní citlivostní štítky u `test-<ini>`, krok 2
stopy dělá lektor na svém testovacím účtu před třídou.

## Úklid po kurzu

Pořadí je důležité — záznam a retence blokují mazání:

1. Odebrat studentské retenční politiky z webů (nebo politiky smazat — bez Preservation Lock to
   jde, [Learn](https://learn.microsoft.com/en-us/purview/retention)). Kurzovní policy
   `GOC248 ISMS zaznam publikace` odebrat **hned po běhu** (viz varování v kroku 6).
2. Odemčené záznamy nejdřív **zamknout** (u odemčeného záznamu nejde štítek změnit ani odebrat
   nikomu), pak na zamčených záznamech odebrat retenční štítek jako správce webu — u zamčeného
   záznamu to smí jen správce kontejneru
   ([Learn](https://learn.microsoft.com/en-us/purview/records-management)).
3. Smazat retenční label policies, pak štítky (štítek označující záznam nejde smazat, dokud je
   na položkách, [Learn](https://learn.microsoft.com/en-us/purview/create-apply-retention-labels)).
4. Studentské citlivostní štítky nejdřív **odebrat z label policies**, počkat, pak teprve mazat
   ([Learn](https://learn.microsoft.com/en-us/purview/create-sensitivity-labels)).
5. DLP a auto-labeling politiky s prefixy studentů smazat.

> [!WARNING] Otevřená otázka — úklid není ověřený
> Zda po odebrání politik a štítků jde web `isms-<ini>` smazat hned, nebo až po doběhnutí
> časovače Preservation Hold library, je neověřené. Podklad pro plánovaný
> `scripts/Remove-CourseArtifacts.ps1`.
