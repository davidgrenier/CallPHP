#!/bin/bash

DIR=`mktemp -d`
FILE=$DIR/file
TEX=$FILE.tex
echo "\\documentclass{amsart}\\usepackage{graphicx}\\begin{document}" > $TEX
cat >> $TEX
echo "\\end{document}" >> $TEX

pdflatex -halt-on-error -output-directory=$DIR $TEX > \dev\null
xdg-open $FILE.pdf
