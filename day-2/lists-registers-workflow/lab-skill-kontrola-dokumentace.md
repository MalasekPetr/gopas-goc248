# Lab · Skill pro kontrolu náležitostí řízené dokumentace

> Modul: `lists-registers-workflow` · Odhad: 25 min · Režim: hands-on na vlastním webu, **nebo instruktorské demo** podle go/no-go
> Tenant: B `spdemo.online` -> A `cloudedu.cz` · Scénář: [`../../scenario-isms-vltava.md`](../../scenario-isms-vltava.md)

## Cíl

Na webu `isms-<ini>` na Tenant B je Skill webu `Kontrola nalezitosti ISMS dokumentu`, který
nad vybranými dokumenty knihovny `Dokumentace` vrátí chybějící náležitosti a zapíše je do
seznamu — a negativní test ukáže, že Copilot na B nevidí registry z A.

**Jak lab číst:** každý krok končí **Checkpointem** — nesedí-li, nepokračuj.

> [!NOTE] Hands-on, nebo demo
> Lektor ráno ohlásí výsledek go/no-go „Skills na Tenant B pro účet bez licence Copilot".
> **Neprošlo** → kroky 2–5 dělá lektor na projektoru a ty je sleduješ; kroky 1, 6 a 7 děláš
> sám (krok 6 v tom případě odpadá s poznámkou, krok 7 zapisuješ s odkazem na lektorův web).

## Předpoklady

- Profil prohlížeče **Tenant B**; web `isms-<ini>` s knihovnou `Dokumentace` (7 dokumentů)
  a Autofill sloupci z [`../content-type-hub/`](../content-type-hub/).
- Na A hotový [`lab-registry-revize.md`](lab-registry-revize.md).

## Kroky

### 1. Přepni na Tenant B

V profilu **Tenant B** otevři `isms-<ini>` -> `Dokumentace`.

**Checkpoint:** přihlášený je `user.NN@spdemo.online`, adresa obsahuje **tvé** iniciály
a v knihovně je sedm dokumentů. Panel Copilota se z knihovny otevírá (stránka není v režimu
úprav).

### 2. Podívej se, co už Copilot umí

V chatu Copilot in SharePoint zadej `/skills`.

**Checkpoint:** vidíš seznam **Built-in skills** včetně schopnosti pro vytvoření skillu
(*Create skill*). Pokud chat neodpoví nebo se neotevře, jdi na Fallback.

### 3. Vytvoř Skill webu

Do chatu zadej:

> Vytvoř site skill s názvem Kontrola nalezitosti ISMS dokumentu. Pro každý vybraný dokument
> v knihovně Dokumentace zkontroluj, zda text uvádí vlastníka dokumentu, datum účinnosti,
> datum příští revize a klasifikaci. U dokumentů, jejichž název začíná ZAZ (záznamy), datum
> příští revize nevyžaduj. Výsledek vrať jako tabulku dokument / chybějící náležitosti.
> Dokumenty, kterým něco chybí, zapiš do seznamu Nalezy kontroly dokumentace se sloupci
> Dokument a Chybi; pokud seznam neexistuje, vytvoř ho.

Přečti návrh, který Copilot vrátí. Pokud v něm chybí výjimka pro záznamy, požádej o doplnění.
Pak potvrď uložení.

**Checkpoint:** Copilot potvrdil uložení skillu jako **site skill** (ne osobní) a návrh
obsahuje výjimku pro dokumenty ZAZ.

### 4. Najdi `SKILL.md`

Otevři obsah webu -> knihovna **Agent Assets** -> `Skills` -> složka skillu -> `SKILL.md`.

**Checkpoint:** soubor `SKILL.md` existuje v `/Agent Assets/Skills/<název>/` na **tvém**
webu a jeho kroky odpovídají zadání.

### 5. Spusť Skill nad dokumenty

V knihovně `Dokumentace` vyber všech sedm dokumentů a v chatu zadej
`Run Kontrola nalezitosti ISMS dokumentu on the selected documents.`

**Checkpoint:** v chatu je karta, že byl načten skill (skill indicator card), a odpověď
obsahuje tabulku. Porovnej ji s tabulkou z Autofill (krok 9 labu `content-type-hub`):
`SME-02` by měl mít nález u data revize (datum je jen odvozené), `ZAZ-01` nález u data revize
mít **nemá**. Seznam `Nalezy kontroly dokumentace` existuje a obsahuje řádky s nálezy.

### 6. Negativní test datové hranice

V témže chatu na B se zeptej: `Kolik rizik je v Risk Registeru a ktere maji miru rizika nad 12?`

**Checkpoint (negativní):** Copilot na Tenant B **nenajde** Risk Register ani žádné z rizik
z Tenant A (žádné „Neoprávněný přístup k zakázkám"). Pokud by je uvedl, je to **nález** —
zapiš ho a nahlas lektorovi.

### 7. Přepni zpět na Tenant A a zapiš do SoA

V profilu **Tenant A** otevři `isms-<ini>` -> `SoA` a přidej řádek. K položce přilož
screenshot výsledku skillu z kroku 5.

| Opatření | Aplikovatelné | Zdůvodnění | Capability M365 | Důkaz | Modul | Tenant |
|---|---|---|---|---|---|---|
| kap. 7.5 | ano | vlastní věta: co Skill kontroluje a co nekontroluje | Skill webu (Copilot in SharePoint) kontroluje náležitosti řízených dokumentů a zapisuje nálezy | odkaz na `SKILL.md` na Tenant B + screenshot v příloze | `lists-registers-workflow` | B |

**Checkpoint:** v profilu Tenant A je přihlášený tvůj účet `@cloudedu.cz`; v `SoA` je řádek
7.5 s Tenant = B, Modul = `lists-registers-workflow` a přílohou.

## Ověření

- [ ] `/skills` v chatu na B odpověděl (nebo je zapsáno, že Skills na tenantu nejdou).
- [ ] Skill webu existuje jako `SKILL.md` v Agent Assets **tvého** webu na B.
- [ ] Běh skillu vrátil tabulku; nález u SME-02, žádný nález data revize u ZAZ-01.
- [ ] **Negativní:** Copilot na B nezná Risk Register z A.
- [ ] Řádek 7.5 (Tenant B) v `SoA` na A.

## Fallback

- **Copilot in SharePoint se na B neotevře nebo `/skills` nefunguje** (licence, dostupnost
  webu): kroky 2–5 předvede lektor; ty napiš návrh skillu (krok 3) do poznámky a v SoA
  odkaž na lektorův `SKILL.md`.
- **Copilot si vyžádá potvrzení čerpání Copilot Credits** (advanced work): nepotvrzuj, ohlas
  lektorovi. Skill zjednoduš na 3 dokumenty.
- **Skill se uloží jako osobní:** požádej Copilota o uložení jako site skill; osobní skill
  žije v tvém OneDrivu a ostatní ho nevidí.
- **Při časové tísni:** celý lab jako demo lektora (kompresní ventil dne č. 2, −15 min);
  krok 7 všichni.

## Zdroje

- [Extend Copilot in SharePoint with skills](https://learn.microsoft.com/en-us/sharepoint/copilot-in-sharepoint-skills)
- [Get started with Copilot in SharePoint](https://learn.microsoft.com/en-us/sharepoint/copilot-in-sharepoint-get-started)
