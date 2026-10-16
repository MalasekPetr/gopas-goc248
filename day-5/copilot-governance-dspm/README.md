# Governance Copilotu a řízení rizik AI

> Typ: povinný · Den: 5 · Odhad: 60 min (10 demo na B + 10 výklad + 40 lab na A)
> Tenant: B `spdemo.online` (demo) + A `cloudedu.cz` (lab) · Režim: instruktorské demo + hands-on, vlastní scope
> Prostředí: [`../../environment.md`](../../environment.md) · Názvosloví: [`../../GLOSSARY.md`](../../GLOSSARY.md)

Dva předchozí bloky postavily a ohodnotily agenty. Tenhle blok odpovídá na otázku vedení:
**čím to řídíme?** Copilot nevidí nic, co uživatel nevidí — ale vidí **všechno**, co
uživatel vidět smí, i to, co dávno vidět neměl. Governance Copilotu proto stojí na třech
věcech z předchozích dnů: oprávnění (D2, D4), štítky (D3) a DLP (D3) — a na jedné nové:
kdo schvaluje agenty.

## Cíle

- Vysvětlit na živé ukázce, proč je oversharing hlavní riziko Copilotu a proč ho agent
  ani Copilot nezpůsobují, jen zviditelňují.
- Vytvořit politiku DLP pro umístění **Microsoft 365 Copilot and Copilot Chat**, která
  vyloučí obsah se štítkem z dne 3 ze zpracování Copilotem — v simulaci, na vlastním scope.
- Zorientovat se v Purview **Data Security Posture Management (DSPM)** a vědět, co ukáže
  a co na tenantu bez licencí Copilotu neukáže.
- Najít v admin center a v Entra místa, kde se rozhoduje o agentech a o souhlasu správce.
- Namapovat rizika AI na opatření A.5.23, A.8.12 a A.5.12.

## Výklad

### Co Copilot skutečně vidí (demo na B)

Copilot zpřístupňuje jen data, ke kterým má uživatel aspoň právo čtení, a sémantický index
respektuje hranici identity uživatele
([Learn: Copilot privacy](https://learn.microsoft.com/en-us/microsoft-365/copilot/microsoft-365-copilot-privacy)).
Z toho plynou dvě věty, které si student odnese:

- **Copilot nepřidává oprávnění** — agent ani Copilot nejsou nový bezpečnostní perimetr.
- **Copilot zrychluje nalezení přesdíleného obsahu.** Soubor sdílený „celé organizaci",
  o kterém nikdo neví, najde Copilot na první dotaz.

Postup dema: [`demo-copilot-na-b.md`](demo-copilot-na-b.md).

### DLP pro Microsoft 365 Copilot and Copilot Chat

Purview DLP má samostatné umístění **Microsoft 365 Copilot and Copilot Chat**
([Learn: DLP pro Copilot](https://learn.microsoft.com/en-us/purview/dlp-microsoft365-copilot-location-learn-about)):

| Podmínka | Akce | Co se stane |
|---|---|---|
| *Content contains* > *Sensitivity labels* | *Prevent Copilot from processing content* | Copilot obsah souboru nebo e-mailu se štítkem nepoužije v odpovědi; položka se může objevit v citacích |
| *Content contains* > *Sensitive information types* | *Prevent Copilot from processing content* > *Processing prompts* | Copilot na prompt s citlivým údajem neodpoví a nepoužije ho k vyhledávání (preview) |
| *Content contains* > *Sensitive information types* | *Prevent Copilot from processing content* > *Performing Web Searches* | prompt s citlivým údajem nejde do webového vyhledávání |
| *Email is received from* > *External users* | *Prevent Copilot from processing content* | externí e-maily se nepoužijí jako podklad (preview) |

Fakta pro lab (tamtéž):

- Umístění je jen v šabloně **Custom**; když ho zapneš, **ostatní umístění v politice se
  vypnou**.
- Podmínka na štítky a podmínka na SIT **nesmí být ve stejném pravidle** — dvě pravidla
  v jedné politice ano.
- **Simulace** je podporovaná; změna politiky se do Copilotu propíše **až za 4 hodiny**.
- Umístění **nepodporuje administrative units**.
- Ve Wordu, Excelu a PowerPointu se politika vyhodnocuje při otevření souboru — štítek
  přidaný během práce platí až od dalšího otevření.

### DSPM — Data Security Posture Management

> [!IMPORTANT] Názvosloví
> **DSPM for AI** a **DSPM** -> jedno řešení **Data Security Posture Management (DSPM)**.
> Předchozí verze jsou v portálu označené **DSPM for AI (classic)** a **Data Security Posture
> Management (classic)**
> ([Learn: DSPM](https://learn.microsoft.com/en-us/purview/data-security-posture-management-learn-about),
> [Learn: mapování úloh](https://learn.microsoft.com/en-us/purview/dspm-task-mapping)).
> Kurz pracuje jen s aktuální verzí.

DSPM odpovídá na čtyři otázky: jaká data máme, kde jsou, kdo k nim má přístup a jak jsou
chráněná. Pro kurz jsou podstatné stránky
([Learn: DSPM](https://learn.microsoft.com/en-us/purview/data-security-posture-management-learn-about)):

- **Objectives** — datové bezpečnostní cíle, mezi nimi *Prevent data exposure in Microsoft
  365 Copilot and Microsoft Copilot interactions* a *Prevent oversharing of sensitive data*.
  Každý cíl nabízí doporučené akce a jednoklikové politiky.
- **AI observability** — inventář AI aplikací a agentů s aktivitou za posledních 30 dní.
- **Discover** > **Data risk assessments** — odhalení přesdíleného obsahu v SharePointu.
- **Discover** > **Activity explorer** > *AI activities* — interakce s AI, citlivé údaje,
  shody DLP.

Co DSPM na kurzovních tenantech **neukáže**: monitorování interakcí s Copilotem vyžaduje
zapnutý audit **a uživatele s přiřazenou licencí Microsoft 365 Copilot**
([Learn: DSPM for AI considerations](https://learn.microsoft.com/en-us/purview/dspm-for-ai-considerations)).
Tenant A Copilot nemá, Tenant B nemá Purview — reporty o Copilotu budou na obou prázdné.
To je výsledek, ne chyba.

> [!WARNING] Jednoklikové politiky DSPM platí pro celou organizaci
> Výchozí politiky z DSPM (DLP, Insider Risk, Communication Compliance, collection
> policies) pokrývají všechny uživatele a skupiny
> ([Learn: DSPM for AI considerations](https://learn.microsoft.com/en-us/purview/dspm-for-ai-considerations)).
> Na Tenant A je každý student Global Administrator — **DSPM je v labu jen ke čtení**.

### Kdo schvaluje agenty a souhlas správce

| Místo | Co tam správce rozhoduje | Zdroj |
|---|---|---|
| Microsoft 365 admin center > *Agents* > *Settings* > **Agent and plugin access** | zda smí uživatelé instalovat agenty Microsoftu, vlastní organizace a externích vydavatelů | [agent settings](https://learn.microsoft.com/en-us/microsoft-365/admin/manage/agent-settings) |
| *Agents* > *Settings* > **Sharing** | kdo smí agenty z Agent Builderu sdílet celé organizaci | [agent settings](https://learn.microsoft.com/en-us/microsoft-365/admin/manage/agent-settings) |
| *Agents* > *All agents* > **Requests** | schválení agentů publikovaných v organizaci, vč. souhlasu s oprávněními v průvodci | [agent requests](https://learn.microsoft.com/en-us/microsoft-365/admin/manage/agent-requests) |
| *Agents* > *All agents* > **Registry** | inventář všech agentů, blokace, odebrání, agenti bez vlastníka | [agent registry](https://learn.microsoft.com/en-us/microsoft-365/admin/manage/agent-registry) |
| Microsoft Entra admin center > *Enterprise apps* > *Consent and permissions* > **Admin consent settings** | zda uživatelé smí požádat o souhlas správce a kdo žádosti posuzuje | [admin consent workflow](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/configure-admin-consent-workflow) |

Všechno v tabulce je **tenantové nastavení**. V labu se na něj jen díváme.

### Mapování na NIS2 a ISO 27001

| Riziko AI | Opatření ISO/IEC 27001:2022 (vlastní parafráze) | Capability v kurzu |
|---|---|---|
| Copilot shrne dokument, který uživatel smí číst, ale neměl by ho dostat do odpovědi | A.8.12 — na systémech zpracovávajících citlivé informace se uplatňují opatření proti úniku dat | DLP pro Copilot podle štítku (lab) |
| Pravidlo „co Copilot nesmí zpracovat" nemá oporu | A.5.12 — informace se klasifikují podle potřeby ochrany | štítek z `sensitivity-labels` jako podmínka DLP |
| Zaměstnanci používají AI mimo kontrolu / instalují agenty libovolných vydavatelů | A.5.23 — bezpečnost cloudových služeb se řídí od výběru po ukončení | `SME-02`, nastavení agentů, hodnocení agenta |
| Přesdílený obsah vyplave v odpovědi | A.5.15 — přístup k informacím se řídí pravidly podle potřeb organizace | oprávnění (D2, D4), data risk assessment v DSPM |

Požadavky vyhlášky č. 410/2025 Sb. k řádkům doplňuje student podle své mapovací matice
z `requirements-mapping-m365` (den 1) — tady se znovu nemapují.

## Klíčové rozlišení

- **DSPM vs. DLP** — DSPM ukazuje stav a navrhuje akce; DLP akci vynucuje. Jednoklikové
  politiky z DSPM jsou ve skutečnosti politiky DLP, Insider Risk a dalších řešení.
- **Štítek vs. DLP pro Copilot** — štítek se šifrováním omezuje, kdo obsah otevře; politika
  DLP pro Copilot omezuje, co Copilot z obsahu použije, i když ho uživatel otevřít smí.
- **Oprávnění vs. DLP** — DLP pro Copilot neřeší oversharing. Kdo nemá k souboru mít
  přístup, tomu se přístup odebírá, ne zakrývá politikou.
- **Schválení agenta vs. souhlas s oprávněními** — první je rozhodnutí, že agent v organizaci
  smí být; druhé je udělení oprávnění aplikaci v Entra.

## Licence

| Funkce v bloku | Business Premium | E3 | E5 / add-on | Zdroj |
|---|---|---|---|---|
| DLP: Copilot nezpracuje soubory a e-maily se štítkem | ne | ne | ano (M365 E5, Purview Suite, E5 Information Protection and Governance, O365 E5) | [Purview service description — DLP for Copilot](https://learn.microsoft.com/en-us/office365/servicedescriptions/microsoft-365-service-descriptions/microsoft-365-tenantlevel-services-licensing-guidance/microsoft-purview-service-description) |
| DLP: ochrana promptů (SIT) | ano, pro všechny uživatele Copilotu a Copilot Chat | ano | ano | tamtéž |
| DSPM | ? | ? | ? | tamtéž — sekce DSPM odkazuje na samostatné podmínky; ověřit |
| Monitorování interakcí s Copilotem v DSPM | vyžaduje licenci Microsoft 365 Copilot | totéž | totéž | [DSPM for AI considerations](https://learn.microsoft.com/en-us/purview/dspm-for-ai-considerations) |
| Správa agentů v admin center | ? | ? | ? | [Manage agents](https://learn.microsoft.com/en-us/microsoft-365/admin/manage/manage-copilot-agents-integrated-apps) — zapnuto v tenantech s licencí Copilot |

Licenční pointa pro capstone: organizace na Business Premium nebo E3 **nemá** vyloučení
obsahu se štítkem z Copilotu přes DLP — zbývá jí ochrana promptů, oprávnění a štítky se
šifrováním.

## Naše prostředí

- **Demo na B** (10 min): lektor ukazuje Copilot nad přesdíleným obsahem — studenti jen
  sledují, případně položí dotaz přes sdíleného agenta lektora.
- **Lab na A**: studenti jsou Global Administrator. Politika DLP jen s prefixem `<ini>-`,
  jen na `isms-<ini>-users`, jen v simulaci. DSPM, nastavení agentů a souhlas v Entra
  **jen ke čtení**.
- Tenant A nemá Copilot — politika se nedá ověřit chováním Copilotu, checkpoint je stav
  konfigurace. Go/no-go: [`../../environment.md`](../../environment.md), položka „DLP
  umístění pro Microsoft 365 Copilot".

## Lab

Viz [`lab-copilot-dlp.md`](lab-copilot-dlp.md).

## Nosná linka

Ve workspace přibyla politika `<ini>-DLP-Copilot` (simulace) a záznam o tom, kde se schvalují
agenti. Do SoA ([`../../scenario-isms-vltava.md`](../../scenario-isms-vltava.md)):

| Opatření | Capability M365 | Důkaz |
|---|---|---|
| A.8.12 | DLP pro umístění Microsoft 365 Copilot and Copilot Chat, štítek z D3, simulace | screenshot politiky `<ini>-DLP-Copilot` (A) |
| A.5.12 | štítek jako podmínka, co Copilot smí zpracovat | screenshot pravidla se štítkem (A) |
| A.5.23 | nastavení přístupu k agentům a souhlasu správce jako kontrolní body výběru AI služeb | zápis aktuálních hodnot nastavení (A, případně B z dema) |

## Zdroje

- [Microsoft Purview DLP for Microsoft 365 Copilot](https://learn.microsoft.com/en-us/purview/dlp-microsoft365-copilot-location-learn-about)
- [Learn about Data Security Posture Management (DSPM)](https://learn.microsoft.com/en-us/purview/data-security-posture-management-learn-about)
- [Map tasks from DSPM for AI and DSPM to the new DSPM](https://learn.microsoft.com/en-us/purview/dspm-task-mapping)
- [DSPM for AI (classic) — considerations](https://learn.microsoft.com/en-us/purview/dspm-for-ai-considerations)
- [Data, Privacy, and Security for Microsoft Copilot](https://learn.microsoft.com/en-us/microsoft-365/copilot/microsoft-365-copilot-privacy)
- [Microsoft Purview service description](https://learn.microsoft.com/en-us/office365/servicedescriptions/microsoft-365-service-descriptions/microsoft-365-tenantlevel-services-licensing-guidance/microsoft-purview-service-description)
- [Agent settings](https://learn.microsoft.com/en-us/microsoft-365/admin/manage/agent-settings) · [Agent registry](https://learn.microsoft.com/en-us/microsoft-365/admin/manage/agent-registry) · [Agent requests](https://learn.microsoft.com/en-us/microsoft-365/admin/manage/agent-requests)
- [Configure the admin consent workflow](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/configure-admin-consent-workflow)

## Stav produktu / delta

> [!WARNING] Ověřit k datu běhu — stav k 2026-10.
> **Vyřazení DSPM (classic) a DSPM for AI (classic)**: Learn k 2026-10-17 datum neuvádí —
> jen označuje classic verze a odkazuje na novou DSPM. Message Center (zdroj není citovatelný
> podle konvencí) uvádí okno 2026-11-30 až 2026-12-31; ověřit na Learn v ověřovacím kole
> 2026-12. Název umístění DLP *Microsoft 365 Copilot and Copilot Chat* se může změnit
> s přejmenováním na Microsoft Copilot. Blokace SIT v promptech je preview a rolluje jen do
> tenantů s Copilotem — na Tenant A nemusí být k dispozici.

> [!IMPORTANT] Názvosloví
> Microsoft 365 Copilot -> **Microsoft Copilot**, Microsoft 365 Copilot Chat -> **Microsoft
> Copilot Chat** (Learn, 2026-10). Starý název může zůstat v UI a v licencích.
