# Šablona · Hodnocení AI agenta před nasazením

> Modul: `normiqa-navigator-demo` · Vyplňuje: student · Čas: 10 min + průběžně během dema
> Kritéria a jejich zdůvodnění: [`README.md`](README.md)

Šablona je obecná — použij ji na **jakéhokoli** agenta, vlastního i cizího. V kurzu ji
vyplníš dvakrát: **sloupec H** pro hotového agenta z dema, **sloupec V** pro svého agenta
`<ini>-ISMS Asistent` z bloku [`../ai-agents-tenant/`](../ai-agents-tenant/).

Pravidla vyplňování:

- Zapisuj jen to, co jsi **sám viděl** (listing, detail v admin center, odpověď agenta).
  Ke každému zápisu připiš, **kde** jsi to viděl.
- „Nezobrazeno" a „nezjištěno" jsou platné odpovědi. Domněnka platná odpověď není.
- Červená vlajka = důvod, proč by agent ve Vltava Servis bez dalšího kroku nasazen nebyl.

## Hodnocení

| # | Kritérium | Otázka | H: hotový agent — co jsem viděl a kde | V: můj agent — co vím a kde | Červená vlajka? |
|---|---|---|---|---|---|
| 1 | Vydavatel | Kdo agenta vydává? Odpovídá vydavatel na listingu a v detailu v admin center? | | | |
| 2 | Oprávnění | Žádá agent o oprávnění (Graph, akce)? Jaká? Odpovídají účelu? | | | |
| 3 | Tok dat | Odkud bere znalosti (tenant, web, služba vydavatele)? Odcházejí data tenantu mimo Microsoft 365? | | | |
| 4 | Schválení | Kdo v organizaci musí agenta povolit a kde (nastavení externích vydavatelů, registr, admin consent)? | | | |
| 5 | Cena a licence | Cena agenta? Jakou licenci Copilotu potřebují uživatelé pro jeho schopnosti? | | | |
| 6 | Podpora | Je kontakt na podporu, privacy statement a terms of use na veřejné URL? | | | |
| 7 | Exit | Jak agenta zablokovat a odebrat? Co zůstane po odebrání? | | | |

## Verdikt

| | H: hotový agent | V: můj agent |
|---|---|---|
| Rozhodnutí | ano / ne / ano za podmínek | ano / ne / ano za podmínek |
| Podmínky (max. 3, konkrétně: kdo, co, do kdy) | | |
| Vlastník rozhodnutí ve Vltava Servis (role) | | |
| Kdy hodnocení zopakovat (spouštěč) | | |

## Kontrolní otázka

Liší se odpovědi ve sloupci H a V u kritéria **Tok dat**? Jednou větou: co z toho plyne pro
pravidlo `SME-02 Používání AI nástrojů`.

## Zapiš do SoA

Ulož vyplněnou šablonu jako dokument do workspace `isms-<ini>` na **Tenant A** (žádná data
z Tenant B, jen tvoje zápisy) a přidej řádek:

| Opatření | Požadavek | Aplikovatelné | Zdůvodnění | Capability M365 | Důkaz | Modul | Tenant |
|---|---|---|---|---|---|---|---|
| A.5.23 | dle mapovací matice | ano | AI agent je cloudová služba a před nasazením se hodnotí podle stejných kritérií jako jiný dodavatel | nastavení *Agent and plugin access*, registr agentů, blokace a odebrání agenta | odkaz na vyplněnou šablonu | `normiqa-navigator-demo` | B |

**Checkpoint:** v SoA je řádek s Modul = `normiqa-navigator-demo` a odkazem na šablonu
uloženou na Tenant A.
