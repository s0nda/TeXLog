# TeXLog

[Deutsch / German]

## FAQ ##

#### 1. `\dfrac{}{}`: Problem mit dem zu hoch dargestellten Zähler. ####

In LaTeX wird der Befehl `\cfrac` oder `\dfrac` verwendet, um
Bruchzahlen in größerer Schriftgröße darzustellen.

Leider wird diese Darstellung (*siehe Abbildung*) von vielen
Usern als nicht schön genug empfunden, da der vertikale
Abstand zwischen dem Zähler und dem Bruchstrich etwas zu groß
erscheint.

![cfrac_dfrac_cases](https://raw.githubusercontent.com/s0nda/TeXLog/main/media/img/cfrac_dfrac_cases.png)

**Abbildung:** Problem mit dem zu hoch dargestellten Zähler.
Zwischen dem Zähler "7" und dem Bruchstrich "_" besteht
relativ viel Leerabstand.

Um dieses Problem mit dem (hohen) Leerabstand umzugehen,
wird ein eigener Befehl (*engl.* command) `\ofrac` definiert,
mittels dessen Bruchzahlen mit besserem (kleinerem) Abstand
zwischen Zähler (Nenner) und Bruchstrich dargestellt werden.
Der Cobige de für `\ofrac` sieht folgendermaßen aus.
```
% new command for displaying fractions
\newcommand{\ofrac}[2]{%
  {\ensuremath{%
    {\:\displaystyle #1}_{\scriptscriptstyle\phantom{!}} \over {\:\displaystyle #2}^{\scriptscriptstyle\phantom{|}} % \: is for medium space.
    %\phatom{!} prints an invisible exclamation mark (!) as vertical spacing from fraction bar (_)
  }}
}
```

Die Befehlsdefinition `\newcommand{\ofrac}[2]` muss außerhalb
und vor dem `\begin{document}`-Bereich platziert sein.
Der Befehl `\ofrac{#1}{#2}` erwartet zwei Argumente, *#1*
für *Zähler*, *#2* für *Nenner*. Die Verwendung ist nach
folgendem Syntax.

**Syntax**: `\ofrac{<Zähler>}{<Nenner>}`

**Erklärung des Befehls**:
- `\ensuremath{<Inhalt>}` stellt sicher, dass sich der eingegebene
  `<Inhalt>` (Text, Formel) immer im `math mode` befindet.
  Das bedeutet, dass sowohl *mit* als auch *ohne* Markup-Zeichen
  `$..$` bzw. `\( .. \)` der `<Inhalt>` immer richtig als
  mathematischer Ausdruck interpretiert werden kann.
- `\displaystyle <Argument>` stellt das `<Argument>` (Zahlen,
  Formeln) in Großschrift dar. Aus diesem guten Grund ist
  `\dfrac{<Zähler>}{<Nenner>}` die Abkürzung für
  `\frac{\displaystyle <Zähler>}{\displaystyle <Nenner>}`.
  Also steht das `d` in `\dfrac` für `\displaystyle`.
- `\scriptscriptstyle <Argument>` stellt das `<Argument>` (Zahlen,
  Formeln) in Kleinschrift dar. Es gibt folgende Schriftgrößen
  für mathematische Ausdrücke - der Größe nach absteigend geordnet:
  
  - `\displaystyle` bzw. `\textstyle`,
  - `\scriptstyle`,
  - `\scriptscriptstyle`,
  - `\small`,
  - `\tiny`

- `\:` ist ein Ausdruck für das sogenannte *horizontal spacing*
  und stellt einen horizontalen Leerabstand von `.2222em` dar.
  Es gibt weitere solche *horinzontal spacing* wie z.B.

  - `\,` stellt horizontalen Leerabstand von `.16667em` dar,
  - `\!` ist das Gegenteil (negativ) von `\,`,
  - `\:` stellt horizontalen Leerabstand von `.2222em` dar,
  - `\>` ist äquivalent zu `\:`,
  - `\;` stellt horizontalen Leerabstand von `.2777em` dar,
  - Für mehr Informationen, siehe
  [StackExchange](https://tex.stackexchange.com/questions/74353/what-commands-are-there-for-horizontal-spacing)

- `\phantom{<Zeichen>}` fügt ein *unsichtbares* Zeichen ein.
- `\over` ist das *Oldschool* von `\frac{}{}` und wird verwendet,
  um Bruchzahlen darzustellen. Der Syntax lautet:
  ```
  <Zähler> \over <Nenner>`
  ```
  `\over` ist im Package `asmmath` definiert und mittels dessen
  der uns heute bekannte Befehl `\frac{}{}` definiert wird:
  ```
  \DeclareRobustCommand{\frac}[2]{{\begingroup#1\endgroup\@@over#2}}
  ```
  Für mehr Informationen, siehe:

  - [What is the difference between \over and \frac?](https://tex.stackexchange.com/questions/73822/what-is-the-difference-between-over-and-frac/)
  - [Practical consequences of using \over vs. \frac?](https://tex.stackexchange.com/questions/365328/practical-consequences-of-using-over-vs-frac)


