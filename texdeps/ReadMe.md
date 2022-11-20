
# TeX package imports tree

Parses the stdout of `latexmk` – 
namely the part that looks like:
```
(./main.tex
LaTeX2e <2022-11-01>
L3 programming layer <2022-11-02> (c:/TinyTeX/texmf-dist/tex/latex/memoir/memoir.cls
(c:/TinyTeX/texmf-dist/tex/latex/textcase/textcase.sty)) (./totex/Settings.tex (c:/TinyTeX/texmf-dist/tex/latex/base/fontenc.sty) (…
…
```
The `(…)` brackets are indented, by level.

The goal is to see what each of my `\usepackage`s imports, recursively.

<br>

---
Learning from output: _tikz_ is big (i.e. imports lots of other packages).
As I don't really use it, I'll cull it (from [totex](https://github.com/tfiers/totex)).

<!-- `latexmk -pdf -time`, after changing one char in text
(after warmup run after making change in Settings):
w/o tikz: 0.45 sec.
w/ tikz: 0.49.
Ok so no diff. 🙃
Hm ok no, there is a diff (after repeated runs).
It's just small.
-->

<br>

---
A smarter way than this script might be to define a syntax, and then give this syntax to a program that does the parsing and formating for us.
