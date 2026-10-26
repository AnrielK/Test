# Kočičky – dětská hra pro iOS (SwiftUI)

Roztomilá hra o péči o koťátko. Veškerá grafika je nakreslená přímo v kódu
(SwiftUI tvary), takže projekt nepotřebuje žádné obrázky kromě ikony.

## Co ve hře je

| Obrazovka | Co se dělá |
|---|---|
| **Výběr kočičky** | Na jevišti spí tři koťátka (Zrzek, Micka, Mourek). Ťuknutím jedno probudíš. |
| **Menu** | Kartičky s minihrami a modrým tlačítkem ▶. Vpravo nahoře počet získaných hvězdiček. |
| **Šatník** | Čepice, trička a šaty, kalhoty a sukně, botičky a brýle. Ťuknutím obleč, dalším ťuknutím svleč. Zelené ✓ hru ukončí. Oblečení se pamatuje pro každou kočičku zvlášť. |
| **Krmení** | Kočička v bublině ukáže, na co má chuť. Přetáhni (nebo ťukni) správné jídlo z lednice. Po 5 dobrotách je hotovo. |
| **Záchodek** | Lopatkou nabírej hrudky z písku (vejdou se 3) a vysyp je do koše. |
| **Koupání** | Hřebenem vyčeš lístky, houbičkou umyj bláto (udělá se pěna) a sprchou pěnu opláchni. |

## Jak spustit

1. Potřebuješ Mac s **Xcode 16** nebo novějším (projekt cílí na iOS 17+).
2. Otevři `KockyHra.xcodeproj`.
3. V nastavení targetu *KockyHra → Signing & Capabilities* vyber svůj tým (stačí bezplatný Apple ID účet).
4. Vyber simulátor (např. iPhone 16) nebo připojený iPhone/iPad a dej **Run** (⌘R).

Hra běží jen na šířku (landscape) na iPhonu i iPadu.

## Struktura

```
KockyHra/
  App/KockyHraApp.swift      – start aplikace a přepínání obrazovek
  Model/                     – kočičky, oblečení, stav hry (ukládá se do UserDefaults)
  Drawing/                   – kreslení kočičky, jídla, nástrojů
  UI/                        – tlačítka, pozadí, oslava s konfetami
  Screens/                   – jednotlivé obrazovky a minihry
```

Kočička i oblečení se kreslí do plátna 300 × 400 bodů (`Board`), takže každý
doplněk sedí na správném místě a celé plátno se jen zvětší podle obrazovky.
Nový doplněk přidáš tak, že do příslušného `enum` v `Model/Outfit.swift` přidáš
`case` a jeho kresbu – v šatníku se objeví sám.

## Tipy na další rozšíření

- zvuky (mňoukání, chroupání) přes `AVAudioPlayer`,
- další kočičky v `Cat.all`,
- nová minihra (např. hraní s klubíčkem) – stačí přidat obrazovku do `Screen` a kartičku do `MenuView`.

## Automatický build

Při každém pushi do `main` (a u pull requestů) GitHub Actions projekt sestaví
pro iOS Simulator (`.github/workflows/build.yml`). Hotovou aplikaci pro
simulátor najdeš u běhu v záložce **Actions** jako artefakt `KockyHra-simulator`.
