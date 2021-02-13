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

Die Befehlsdefinition `\newcommand{}` muss außerhalb und
vor dem `\begin{document}`-Bereich platziert sein.
Die Verwendung von `\ofrac` ist nach folgendem Syntax.

**Syntax**: `\ofrac{<Zähler>}{<Nenner>}`

**Erklärung des Befehls**:
- `\ensuremath{<Inhalt>}` wird verwendet, um sicherzustellen, dass
  sich der eingegebene `<Inhalt>` (Text, Formel) immer im `math mode`
  befindet. Das bedeutet, sowohl *mit* als auch *ohne* das Markup-
  Zeichen `$..$` bzw. `\( .. \)` wird `<Inhalt>` immer richtig als
  mathematischer Ausdruck interpretiert.
- `\displaystyle <Argument>` wird verwendet, um das `<Argument>`
  (Zahlen, Formeln) in Großschrift darzustellen. Aus diesem guten
  Grund ist `\dfrac{<Zähler>}{<Nenner>}` die Abkürzung für
  `\frac{\displaystyle <Zähler>}{\displaystyle <Nenner>}`.
  Also steht das `d` in `\dfrac` für `\displaystyle`.
