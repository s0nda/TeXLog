#!/bin/bash
#========================================================================================
#
# Constants & variables (file pdf, directories)
#
#========================================================================================
DEFAULT_FILE_NAME=seminar
DEFAULT_MAIN_TEX=${DEFAULT_FILE_NAME}.tex
DEFAULT_MAIN_BCF=${DEFAULT_FILE_NAME}.bcf # bcf (biber configuration file)
#========================================================================================
#
# Compile tex to pdf (1st time).
# During this compiling, an .bcf file is created from the .bib file.
#
#========================================================================================
pdflatex -synctex=1 -interaction=nonstopmode ${DEFAULT_MAIN_TEX}
#========================================================================================
#
# Run Biber backend processor to create bibliography.
#
#========================================================================================
biber ${DEFAULT_MAIN_BCF}
#========================================================================================
#
# Compile tex to pdf (2nd & 3rd time).
#
#========================================================================================
pdflatex -synctex=1 -interaction=nonstopmode ${DEFAULT_MAIN_TEX}
pdflatex -synctex=1 -interaction=nonstopmode ${DEFAULT_MAIN_TEX}
