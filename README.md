# TeXLog

[Deutsch / German]

## FAQ ##

### 1. File `<package_name>.sty` not found. ^^M ###

Meist nach einer frischen Neuinstallation des Betriebssystems
(Windows, Linux etc.) und der TeX-Programme (TeXLive/MikTeX)
bekommt man während der Kompilierung seiner TeX-Datei die
folgende Fehlermeldung:

    File '<package_name>.sty' not found. ^^M

Diese Fehlermeldung weist auf das *Fehlen eines bestimmten
TeX-Pakets* hin und verlangt dessen nachträgliche
Installation.
Dabei steht `<package_name>` als Platzhalter für den Namen
des (fehlenden) Pakets.
Zum Beispiel, wird das Paket `imakeidx` vermisst, lautet die
Fehlermeldung:

    File 'imakeidx.sty' not found. ^^M

In diesem Fahll muss das fehlende Paket `imakeidx`
nachträglich installiert werden.


#### 1.1. Finden und Herunterladen des vermissten Pakets ####

Die fehlenden Pakete kann auf der CTAN-Seite gefunden und
herunterladen werden:

  [https://www.ctan.org/pkg](https://www.ctan.org/pkg)

Wird z.B. das Paket `imakeidx` vermisst, gibt man den Paketnamen
'imakeidx' im Suchfeld auf der o.g. Seite ein und klickt auf
'Suchen'. Anschließend folgt man dem (meist ersten) Link
zum `Package imakeidx` und kann die *.zip Datei, hier 
`imakeidx.zip`, herunterladen.

    [https://www.ctan.org/pkg/imakeidx](https://www.ctan.org/pkg/imakeidx)


#### 1.2. Extrahieren des Pakets ####

Angenommen, das Paket z.B. `imakeidx.zip`, welches die
benötigte Datei `imakeidx.sty` enthält, wurde unter dem
Ordner `/home/<user>/Downloads/` gespeichert.
Extrahiert im selben Ordner (`.`) wird diese Datei
`imakeidx.zip` mittels der Befehlszeile:

    $ sudo unzip -q imakeidx.zip -d .
    
wobei die Option (Modifier) `-q` für *quite* bzw.
*stilles Ausführen*, `-d` für *dicrectory* bzw. *Verzeichnis*
(nach welchem extrahiert wird), und `.` (dot, Punkt) für
das *aktuelle Verzeichnis*, in welchem die Datei
`imakeidx.zip` sich aktuell befindet, steht.

Dabei wird durch `-d .` in `/home/<user>/Downloads/` ein
Ordner `imakeidx` erstellt. Anschließend werden alle
(gezippten) Dateien in diesen Ordner extrahiert.
Es ergibt folgende Verzeichnisstruktur:

    root (/)
     |
     +-- home
          |
          +-- <user>
                |
                +-- Downloads/
                       |
                       +-- imakeidx.zip
                       +-- imakeidx/
                            |
                            +-- imakeidx.dtx
                            +-- (imakeidx.ins)
                            +-- imakeidx.pdf
                            +-- manifest.txt
                            +-- README


#### 1.3. Installieren des Pakets ####

Angenommen, alle LaTeX-Pakete wurden standardmäßig im
Ordner `/usr/share/texlive/texmf-dist/tex/latex/`
installiert.

Um das Paket `imakeidx` in das bestehende TeX-System zu
integrieren bzw. installieren, sind folgende drei Schritte
durchzuführen:


**1.3.1.** Generiert aus der mitgelieferten `.ins`- (bzw.
  `.dtx`) Datei die für die Installation notwendige
  `.sty`-Datei, mit Hilfe des `tex` Befehls:
       
       $ cd /home/<user>/Downloads/imakeidx/
       $ tex imakeidx.ins
       
Falls die Datei `imakeidx.ins` nicht vorliegt,
wird stattdessen `imakeidx.dtx` verwendet:
       
       $ tex imakeidx.dtx
       
(In einigen Fällen ist auch `latex`- oder `pdflatex`-
Befehl notwendig:
       
       $ latex imakeidx.ins
       $ latex imakeidx.dtx
       
oder:
       
       $ pdflatex imakeidx.ins
       $ pdflatex imakeidx.dtx
).

In jedem Fall werden zwei Dateien, `imakeidx.sty` für
die Installation und `imakeidx.log` als Logdatei, erstellt.
Die Logdatei ist redundant. Wichtig ist lediglich
`imakeidx.sty`.

    root (/)
     |
     +-- home
          |
          +-- <user>
                |
                +-- Downloads/
                       |
                       +-- imakeidx.zip
                       +-- imakeidx/
                            |
                            +-- imakeidx.dtx
                            +-- (imakeidx.ins)
                            +-- imakeidx.sty <==========
                            +-- imakeidx.log
                            +-- imakeidx.pdf
                            +-- manifest.txt
                            +-- README
         
                               
**1.3.2.** Erstellt im `/usr/share/texlive/texmf-dist/tex/latex/`
  einen neuen Ordner namens `imakeidx`:
           
       $ cd /usr/share/texlive/texmf-dist/tex/latex/
       $ sudo mkdir imakeidx
       
       
**1.3.3.** Kopiert alle Installationsdateien (d.h.
  `imakeidx.sty`, ggf. `imakeidx.dfg` und `imakeidx.def`)
  von `/home/<user>/Downloads/imakeidx/` nach
  `/usr/share/texlive/texmf-dist/tex/latex/imakeidx/`:
       
       $ cd /home/<user>/Downloads/imakeidx/
       
       $ sudo cp *.sty /usr/share/texlive/texmf-dist/tex/latex/imakeidx/
       
(falls vorhanden

       $ sudo cp *.dfg /usr/share/texlive/texmf-dist/tex/latex/imakeidx/
       $ sudo cp *.def /usr/share/texlive/texmf-dist/tex/latex/imakeidx/
)
       
       
**1.3.4.** Weist allen Installationsdateien (`*.sty`, ggf. `*.dfg`
  und `*.def`) im Ordner
  `/usr/share/texlive/texmf-dist/tex/latex/imakeidx/`
  entsprechende Rechte (`-rw-r--r--` bzw. `0644`) zu:

       $ cd /usr/share/texlive/texmf-dist/tex/latex/imakeidx/
       
       $ sudo chmod a=r *.sty
       $ sudo chmod u+w *.sty
       
bzw. (mit oktaler Schreibweise):

       $ sudo chmod 0644 *.sty
       
**Erklärung:**
- Die Zeile `sudo chmod a=r *.sty` bewirkt, dass ALLE (*all*, `a`)
  Gruppen (d.h. `a = {u,g,o}` wobei `u = user`, `g = group`,
  `o = others`) das **Lese**recht (`=r`) auf die .sty-Dateien
  (`*.sty`) zugewiesen erhalten.
  
  Die Zugriffsrechte für die Datei `imakeidx.sty` würde nach
  einer solchen Zuweisung wie folgt aussehen:
  
      $ sudo chmod a=r *.sty
      $ ls -la
      -r--r--r--    imakeidx.sty
      
- Die Zeile `sudo chmod u+w *.sty` bewirkt, dass ausschließlich
  BENUTZER (*user*, `u`) zusätzlich (`+`) das **Schreibe**recht
  (`+w`) auf die .sty-Dateien (`*.sty`) zugewiesen erhalten.
  
  Die Zugriffsrechte für die Datei `imakeidx.sty` würde nach
  einer solchen Zuweisung wie folgt aussehen:
  
      $ sudo chmod u+w *.sty
      $ ls -la
      -rw-r--r--    imakeidx.sty

- Alternativ kann auch durch die **oktale Notation** (`0644`)
  dieselbe Berechtigung zugewiesen werden.
  
      $ sudo chmod 0644 *.sty
      
      S U G O
      0 6 4 4
      
  Das Sticky-Bit (`S`) soll `0` sein.
  
  Das User-Bit (`U`, Benutzer) ist `6` und bedeutet, dass
  der Benutzer sowohl **lesend** als auch **schreibend**
  auf die .sty-Dateien zugreifen kann.
  Denn 6 = 4 (*lesen*) + 2 (*schreibend*).
  
  Das Group-Bit (`G`, Gruppe) ist `4` und bedeutet, dass
  die Gruppe **nur lesend** auf die .sty-Dateien zugreifen
  kann. Denn 4 = 4 (*lesen*) + 0 (*keine*).
  
  Das Others-Bit (`O`, Andere) ist `4` und bedeutet, dass
  die Anderen **nur lesend** auf die .sty-Dateien zugreifen
  können. Denn 4 = 4 (*lesen*) + 0 (*keine*).
  
  
**1.3.5.** Anschließend soll die TeX-Bibliothek aktualisiert
  werden, nachdem die `*.sty`-Dateien in den entsprechenden
  Zielordner `imakeidx/` kopiert und passende Rechte zugewiesen
  bekommen haben:
       
       $ sudo texhash
       
oder

       $ sudo mktexlsr



[https://wiki.ubuntuusers.de/TeX_Live/](https://wiki.ubuntuusers.de/TeX_Live/)

[https://de.wikipedia.org/wiki/Chmod](https://de.wikipedia.org/wiki/Chmod)

______________________________________________________________________

### 2. `\dfrac{}{}`: Problem mit dem zu hoch dargestellten Zähler. ###

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
  `\over` ist im Package `asmmath` definiert. Mithilfe von `\over`
  wird der uns heute bekannte Befehl `\frac{}{}` definiert:
  ```
  \DeclareRobustCommand{\frac}[2]{{\begingroup#1\endgroup\@@over#2}}
  ```
  Für mehr Informationen, siehe:

  - [What is the difference between \over and \frac?](https://tex.stackexchange.com/questions/73822/what-is-the-difference-between-over-and-frac/)
  - [Practical consequences of using \over vs. \frac?](https://tex.stackexchange.com/questions/365328/practical-consequences-of-using-over-vs-frac)

[Bachelorarbeit "Satz von Wilson"](https://www.overleaf.com/read/mzbmgbxsbrqj)


