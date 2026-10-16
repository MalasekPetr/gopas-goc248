# Řešení · PIM for Groups pro vlastníka ISMS webu

Referenční řešení k [`lab-pim-for-groups.md`](lab-pim-for-groups.md). Výsledky z tenantu
(časy aktivace, projev na webu) tu nejsou — lab nebyl na Tenant A zatím odzkoušen.

## Konfigurace

| Objekt | Hodnota | Proč |
|---|---|---|
| Skupina | `<ini>-isms-admins`, Security, Assigned, není role-assignable | nedrží roli Entra; dynamická skupina by v PIM nešla |
| Oprávnění webu | skupina ve skupině Vlastníci `isms-<ini>` | plná kontrola nad ISMS dokumentací = privilegovaný přístup |
| PIM nastavení Member | max 2 h, MFA, justification, approval (vlastní účet), bez trvalých eligible | JIT + čtyři oči + konec platnosti |
| Přiřazení | `test-<ini>` eligible do konce kurzu | eligible ≠ člen |
| Owner nastavení | beze změny | vlastnictví skupiny je samostatná cesta k eskalaci — v reálném nasazení nastavit stejně přísně |

Pozor na dvě cesty, kterými se PIM obchází: **přímé členství** přidané v Entra Groups a
**vlastník skupiny**, který si členy přidá sám. Obojí je v reálném nasazení nález pro revizi.

## Nález (věta do dokumentu Návrh rolí)

Příklad: „V kurzovním tenantu má 15 osob trvale roli Global Administrator, přestože pro všechny
ověřené úkoly stačily užší role. Vltava Servis zavede trvale aktivní Global Administrator jen
pro dva nouzové účty, ostatní správci dostanou užší role a privilegované role jen jako eligible
přes PIM."

## Řádky SoA

| Opatření | Aplikovatelné | Zdůvodnění (vzor, piš vlastní) | Capability M365 | Důkaz | Modul |
|---|---|---|---|---|---|
| A.5.15 | ano | Přístup k řízené dokumentaci ISMS se uděluje přes skupinu s pravidly, ne jednotlivcům natrvalo. | PIM for Groups, `<ini>-isms-admins` | odkaz na screenshot nastavení Member | `privileged-access-pim` |
| A.5.18 | ano | Přístupová práva mají konec platnosti, schválení a záznam; revize přístupu by vyžadovala ID Governance. | eligible přiřazení, schválení, Resource audit | odkaz na screenshot Resource audit | `privileged-access-pim` |
| A.8.2 | ano | Privilegovaný přístup je časově omezený; počet stálých Global Administratorů se snižuje podle Návrhu rolí. | PIM for Groups, návrh rolí | dokument Návrh rolí | `privileged-access-pim` |

Vlastní parafráze účelu opatření (ne text normy): **A.5.15** — kdo se k čemu dostane, určují
zapsaná pravidla, ne zvyk; **A.5.18** — každé oprávnění má důvod, dobu trvání a někoho, kdo ho
čas od času zkontroluje; **A.8.2** — správcovská oprávnění má co nejméně lidí na co nejkratší
dobu.
