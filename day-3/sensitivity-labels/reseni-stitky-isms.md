# Řešení · Taxonomie štítků a štítky na ISMS knihovně

Referenční řešení k [`lab-stitky-isms.md`](lab-stitky-isms.md). Návrh taxonomie není jediný
správný — hodnotí se zdůvodnění, ne shoda s tabulkou.

## A. Kurzovní taxonomie Tenant A (publikuje lektor)

| Priorita | Štítek | Pro jaké dokumenty Vltava Servis | Značení | Šifrování | Kontejner | Proč takhle |
|---|---|---|---|---|---|---|
| 1 | Veřejné | ceník služeb, tiskové zprávy | — | ne | — | jen klasifikace; umožní vědomé „snížení" se zdůvodněním |
| 2 | Interní | směrnice pro zaměstnance, interní postupy | zápatí `Vltava Servis - interni` | ne | Privacy None, externí sdílení jen stávající hosté | rozumný základ pro většinu obsahu; nezamyká soukromí skupin |
| 3 | Důvěrné \ Vltava | ISMS politiky, Risk Register, Asset Register | záhlaví `VLTAVA SERVIS - DUVERNE` | ne | Privacy None, sdílení jen v organizaci | výchozí úroveň řízené ISMS dokumentace; bez šifrování, aby DLP, vyhledávání a spoluautorství viděly obsah; web s tímto štítkem nesdílí ven — předání auditorovi je vědomé rozhodnutí mimo tento web |
| 3.x | Důvěrné \ `<ini>-ISMS důvěrné` | totéž pro workspace studenta | záhlaví s iniciálami | ne | — | studentský objekt; ve skupině, aby nebylo nutné přeřazovat sdílený seznam |
| 4 | Přísně důvěrné | podklady k incidentu před hlášením, přístupové údaje k nouzovým účtům | vodoznak `PRISNE DUVERNE` | ano, Assign permissions now, uživatelé organizace Co-Author, bez expirace | — | jediná úroveň, kde ochrana musí cestovat se souborem i mimo tenant |

Rozhodnutí, která drží týden:

- **Žádný výchozí a žádný povinný štítek v kurzovní policy** — propsaly by se do práce všech
  ve dnech 4 a 5.
- **Zdůvodnění při snížení zapnuté** v kurzovní policy — stopa pro den 4 (`test-<ini>` snižuje
  štítek) nesmí záviset na tom, zda se stihla propsat studentova policy.
- **Šifrování bez expirace** — štítek s expirací SharePoint neumí zpracovat a ve webových
  aplikacích ho nezobrazí
  ([Learn](https://learn.microsoft.com/en-us/purview/sensitivity-labels-sharepoint-onedrive-files)).

## B. Referenční studentský návrh (krok 2)

| Úroveň | Příklad z ISMS | Kdo smí otevřít | Značení | Šifrování | Kontejner |
|---|---|---|---|---|---|
| Veřejné | Prohlášení o ochraně osobních údajů na webu | kdokoli | — | ne | — |
| Interní | Pravidla používání e-mailu | zaměstnanci | zápatí | ne | jen stávající hosté |
| Důvěrné | Politika řízení přístupu, Risk Register | zaměstnanci, vybraní externí (auditor) | záhlaví | ne | jen organizace |
| Přísně důvěrné | Podklad k prvotnímu hlášení incidentu NÚKIB, seznam break-glass účtů | jmenovitě určené osoby | vodoznak | ano | — |

Odpověď na kontrolní otázku: výchozí úroveň pro ISMS dokumentaci se **nešifruje**, protože by
dokument nešel otevřít externímu auditorovi bez účtu, kterého lze autorizovat, a protože Learn
výslovně nedoporučuje šifrující štítek jako výchozí
([Learn: sensitivity labels](https://learn.microsoft.com/en-us/purview/sensitivity-labels)).

Typické chyby návrhu:

- Šest a více úrovní, nebo úrovně podle oddělení místo podle citlivosti.
- Šifrování na úrovni Interní — „bezpečnější" na papíře, v praxi obcházené.
- Záměna úrovně citlivosti s dobou uchování („Archiv 10 let" patří do retence, ne do taxonomie).

## C. Řádky SoA

| Opatření | Požadavek | Aplikovatelné | Zdůvodnění (vzor) | Capability M365 | Důkaz | Modul | Tenant |
|---|---|---|---|---|---|---|---|
| A.5.12 | vyhl. 410/2025 Sb. § 3 odst. 4 (podle mapovací matice `requirements-mapping-m365`) | ano | Vltava Servis třídí dokumenty ISMS do čtyř úrovní podle dopadu prozrazení; úrovně a odpovědnosti určuje bezpečnostní politika. | taxonomie sensitivity labels, label policy `<ini>-ISMS label policy` se zdůvodněním při snížení | snímek label policy (scope `isms-<ini>-users`) v knihovně důkazů | `sensitivity-labels` | A |
| A.5.13 | vyhl. 410/2025 Sb. § 3 odst. 4 (podle mapovací matice) | ano | Řízená dokumentace dostává štítek automaticky při uložení do knihovny; štítek je vidět v záhlaví dokumentu i ve sloupci knihovny; web nese kontejnerový štítek. | výchozí sensitivity label knihovny „Řízená dokumentace", značení obsahu, kontejnerový štítek webu `isms-<ini>` | odkaz na označenou Politiku + snímek nastavení knihovny | `sensitivity-labels` | A |

Volitelný řádek: mapovací matice z pondělí přiřazuje k tomuto bloku i **A.8.24** (§ 13 —
kryptografie) přes šifrování ve štítku. V labu student šifrující štítek nevytváří; kdo chce
řádek zapsat, dokládá kurzovní štítek Přísně důvěrné (nastavení šifrování) a v Zdůvodnění uvede,
že jde o konfiguraci lektora.

## D. Kontrolní body pro lektora

- Policy studenta: **Users and groups** = jen `isms-<ini>-users`.
- Štítek studenta: uvnitř skupiny Důvěrné, scope jen Files, bez šifrování.
- Auto-labeling (ventil 1): Locations jen vlastní web, stav simulace, automatické zapnutí vypnuté.
