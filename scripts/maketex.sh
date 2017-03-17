#!/bin/sh
set -e

name=$(echo "$1" | rev | cut -d. -f 2- | rev)
pdflatex "$name.tex"
bibtex "$name"
pdflatex "$name.tex"
pdflatex "$name.tex"
