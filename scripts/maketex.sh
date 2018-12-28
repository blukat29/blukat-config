#!/bin/sh
set -e

name=$(echo "$1" | rev | cut -d. -f 2- | rev)
opts="--shell-escape"
pdflatex $opts "$name.tex"
bibtex "$name"
pdflatex $opts "$name.tex"
pdflatex $opts "$name.tex"
