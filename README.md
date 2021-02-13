# TeXLog

[Deutsch / German]

## FAQ ##

1. `\dfrac{}{}`: Problem mit dem zu hoch dargestellten Zähler.

In LaTeX wird der Befehl `\cfrac` oder `\dfrac` verwendet, um
Bruchzahlen in größerer Form darzustellen. Leider wird diese
Darstellung (*siehe Abbildung unten*) von vielen Usern als
nicht schön genug empfunden, da der vertikale Abstand zwischen
Zähler und dem Bruchstrich etwas zu groß dargestellt.

![cfrac_dfrac_cases](https://raw.githubusercontent.com/s0nda/TeXLog/main/media/img/cfrac_dfrac_cases.png)
**Abbildung:** Problem mit dem zu hoch dargestellten Zähler.

Um diesen *übermäßig* hohen Abstand auf die gewünschte Länge
zu verkürzen, wird durch die Definition eines eigenen Befehls
(engl. command) namens `\ofrac` erreicht. Der Code dafür sieht
folgendermaßen aus.

```
% new command for displaying fractions
\newcommand{\ofrac}[2]{%
  {\ensuremath{%
    {\:\displaystyle #1}_{\scriptscriptstyle\phantom{!}} \over {\:\displaystyle #2}^{\scriptscriptstyle\phantom{|}} % \: is for medium space.
    %\phatom{!} prints an invisible exclamation mark (!) as vertical spacing from fraction bar (_)
  }}
}
```

Die obige Definition über `\newcommand{}` muss außerhalb und
vor dem `\begin{document}` stattfinden. Die Verwendung von
`\ofrac` ist entsprechend folgendem Syntax.

```
\ofrac{<Zähler>}{<Nenner>}
```