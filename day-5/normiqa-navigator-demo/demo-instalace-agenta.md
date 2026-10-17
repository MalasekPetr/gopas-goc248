# Demo · Instalace hotového agenta z Marketplace

> Modul: `normiqa-navigator-demo` · Odhad: 30 min · Režim: instruktorské demo
> Tenant: B `spdemo.online` · Účet: lektor s rolí, která smí spravovat agenty (AI Administrator nebo Global Administrator)

Pořadí je závazné: **kritéria -> listing -> tenant -> agent -> exit**. Agent se neukazuje
dřív, než mají studenti před sebou šablonu
[`template-hodnoceni-agenta.md`](template-hodnoceni-agenta.md).

## 0. Kritéria (5 min)

Projeď sedm kritérií z [`README.md`](README.md). Řekni nahlas: „Agent, kterého teď uvidíte,
je produkt firmy autora kurzu. Proto ho hodnotíte stejnou šablonou jako vlastního agenta
a zapisujete jen to, co uvidíte."

**Checkpoint:** každý student má otevřenou šablonu se sloupci H a V.

## 1. Listing (5 min)

Otevři listing agenta na Microsoft Marketplace
([Normiqa Navigator](https://marketplace.microsoft.com/en-us/product/wa200011233?tab=overview)).
Nic nekomentuj, jen posouvej stránku a nech studenty vyplnit z listingu
kritéria 1 (vydavatel), 5 (cena) a 6 (podpora, privacy, terms).

**Checkpoint:** studenti mají v sloupci H vyplněná kritéria 1, 5 a 6 s poznámkou „listing".

## 2. Tenant — kdo to povoluje (5 min)

V Microsoft 365 admin center na B:

1. *Agents* > *Settings* > **Agent and plugin access** — ukaž, zda jsou povolení agenti
   externích vydavatelů. Nic neměň, pokud to demo nevyžaduje.
2. *Agents* > *Settings* > **User access** — kdo smí agenty používat.
3. *Agents* > *All agents* > **Registry** — filtr *Publisher type*.

**Checkpoint:** studenti mají vyplněné kritérium 4 (schválení) s místem v admin center.

## 3. Instalace a detail agenta (5 min)

Nainstaluj agenta podle toho, co tenant nabídne — z Agent Store pro sebe, nebo nasazením
v registru jen na svůj účet. Před potvrzením **zastav** na detailu agenta (oprávnění,
zdroje dat, akce, odkazy vydavatele). Pokud se zobrazí souhlas s oprávněními, nech ho
studentům přečíst. Pokud se nezobrazí, řekni to — i to je výsledek.

**Checkpoint:** studenti mají vyplněná kritéria 2 (oprávnění) a 3 (tok dat) a u každého
místo, kde to viděli.

## 4. Agent v akci (3 min)

Polož agentovi dva dotazy, které navrhnou studenti (jeden k NIS2 nebo ISO 27001, jeden
mimo téma). U každé odpovědi ukaž **citace** — odkud agent čerpal. Nic nedoplňuj ústně.

**Checkpoint:** studenti doplnili ke kritériu 3 pozorování z citací.

## 5. Exit (2 min)

V registru ukaž **Block** a **Remove** u agenta (nebo odinstalaci u sebe). Polož otázku:
„Co zůstane po odebrání — u nás a u vydavatele?" Odpověď hledejte v privacy statementu
z listingu.

**Checkpoint:** studenti mají vyplněné kritérium 7.

## 6. Verdikt (5 min)

Studenti dopíšou verdikt pro H a V a kontrolní otázku. Dva studenti přečtou verdikt
pro H — lektor nekomentuje, jen se ptá „kde jste to viděli?".

## Fallback

- **Listing není dostupný nebo agent nejde nainstalovat:** kompresní ventil 1 — studenti
  vyplní šablonu jen pro svého agenta (sloupec V) a lektor ukáže, kde by se v admin center
  hodnotil cizí agent (krok 2 a 5 bez instalace).
- **Na B je vypnutá volba externích vydavatelů a nesmí se měnit:** ukázat to jako nález —
  organizace má zavřenou bránu; hodnocení probíhá nad listingem.
- **Při časové tísni:** kroky 1, 3 a 5 zkrátit na projekci bez komentáře, verdikt jako domácí
  úkol do capstonu (řádek SoA zůstává povinný).
