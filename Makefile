all: mpi40-report-ja.pdf

.SUFFIXES: .adoc .pdf

pandoc_options += -s
pandoc_options += -f docbook
pandoc_options += --pdf-engine=lualatex
pandoc_options += -V documentclass=bxjsreport
pandoc_options += -V classoption=pandoc

.adoc.pdf:
	asciidoctor -b docbook5 -o - $^ | pandoc $(pandoc_options) -o $@
