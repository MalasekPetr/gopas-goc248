# Řešení · Sada CA politik pro testovacího uživatele a MFA pilot

Referenční řešení k [`lab-ca-policy-set.md`](lab-ca-policy-set.md). Pro ty, kdo nestihli, a pro
kontrolu zdůvodnění. **Výsledky z tenantu tu nejsou** — lab nebyl na Tenant A zatím odzkoušen,
a co ukáže sign-in log, se zapisuje až z běhu.

## Konfigurace politik

Společné pro všechny čtyři: Include = uživatel `test-<ini>` (přímo, ne přes skupinu), Exclude =
skupina nouzových účtů, Target resources = *All resources*.

| Politika | Podmínky | Grant | Session | Stav |
|---|---|---|---|---|
| `<ini>-CA01-Pilot-AllResources-MFA` | — | *Require authentication strength*: Multifactor authentication | — | On |
| `<ini>-CA02-Pilot-AllResources-LegacyAuth-Block` | Client apps: Exchange ActiveSync clients, Other clients | Block access | — | Report-only |
| `<ini>-CA03-Pilot-AllResources-SigninRiskMedHigh-MFA` | Sign-in risk: Medium, High | *Require authentication strength*: Multifactor authentication | Sign-in frequency: Every time | Report-only |
| `<ini>-CA04-Pilot-AllResources-UserRiskHigh-RiskRemediation` | User risk: High | *Require risk remediation* (authentication strength se doplní) | Sign-in frequency: Every time (doplní se) | Report-only |

Proč takto:

- **Uživatel přímo, ne skupina** — členství ve skupině může kdokoli s rolí Global Administrator
  změnit a politika se tím tiše rozšíří. Pro pilot je přímé přiřazení auditovatelnější.
- **Authentication strength místo „Require MFA"** — stejný efekt, ale politika je připravená na
  zpřísnění na *Phishing-resistant MFA* bez přestavby. Obojí v jedné politice nejde.
- **Risk jako dvě politiky** — Learn výslovně nedoporučuje kombinovat sign-in a user risk v jedné
  politice ([Risk policies](https://learn.microsoft.com/en-us/entra/id-protection/howto-identity-protection-configure-risk-policies)).
- **CA02 jen report-only** — blokace je nejtvrdší řízení přístupu; Learn ji doporučuje nejdřív
  ověřit ([Plan a Conditional Access deployment](https://learn.microsoft.com/en-us/entra/identity/conditional-access/plan-conditional-access)).

## Persona Admins (věta do dokumentu)

Příklad: „Vltava Servis zahrne do persony Admins všechny privilegované role Entra, vyžádá pro ně
sílu *Phishing-resistant MFA* (passkey / FIDO2) a nouzové účty vyloučí; TAP adminovi na tuto
politiku nestačí."

## What If — očekávání podle dokumentace

| Běh | Proč |
|---|---|
| a | CA02 vyžaduje klientskou aplikaci mimo prohlížeč, CA03/CA04 vyžadují riziko — první nesplněná podmínka je důvod |
| b, c | riziko je zadané, ostatní podmínky splněné |
| d, e | uživatel není v Include — důvod „user not included" nebo obdobný text v UI |

Přesné znění důvodů v UI je **neověřené na tenantu** — zapisuje se z běhu.

## Řádky SoA

| Opatření | Aplikovatelné | Zdůvodnění (vzor, piš vlastní) | Capability M365 | Důkaz | Modul |
|---|---|---|---|---|---|
| A.5.15 | ano | Pravidla přístupu k informacím jsou stanovená po personách a vynucená technicky, ne jen v dokumentu. | Conditional Access, `<ini>-CA01`–`CA04` | dokument Návrh CA politik | `conditional-access` |
| A.5.17 | ano | Přidělení prvního ověřovacího prostředku probíhá bez sdílení hesla, časově omezeným kódem. | Temporary Access Pass, authentication methods policy | dokument Návrh CA politik, krok onboardingu | `conditional-access` |
| A.8.5 | ano | Přihlášení vyžaduje vícefaktorové ověření; rizikové přihlášení a rizikový účet mají připravenou reakci. Bez Entra ID P2 by riziková část chyběla. | authentication strength, risk-based CA | výsledky sign-in logu `test-<ini>` v dokumentu | `conditional-access` |

Vlastní parafráze účelu opatření (ne text normy): **A.5.15** — kdo se k čemu dostane, určují
zapsaná pravidla, ne zvyk; **A.5.17** — s hesly, kódy a dalšími ověřovacími prostředky se
zachází tak, aby se od prvního předání po zneplatnění nedostaly do nepovolaných rukou;
**A.8.5** — čím citlivější cíl, tím těžší má být vydávat se za někoho jiného.

Sloupec Požadavek (ustanovení vyhlášky č. 410/2025 Sb.) se doplňuje podle mapovací matice
z [`../../day-1/requirements-mapping-m365/`](../../day-1/requirements-mapping-m365/).
