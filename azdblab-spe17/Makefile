# Makefile generated using Paul A Jolly's makelatex script, with some
# modification by David Minton.  
#
# Last Modified: 01/07/2009

# Viewers - Change these to your favorites
#PSVIEWER = gv
#PDFVIEWER = evince
#PSVIEWER = gv
#PDFVIEWER = xpdf
PSVIEWER = open -a Preview
PDFVIEWER = open -a Preview


# Processors
LATEX = latex --interaction=nonstopmode
TEX = latex --interaction=nonstopmode
BIBTEX = bibtex
L2H = latex2html
PDFLATEX = pdflatex -shell-escape
#PS2PDF = ps2pdf
#DVIPS = dvips -Ppdf -G0
FIG2DEV = fig2dev
FIND = find
XARGS = xargs
GZIP = gzip -f
COPY = if test -r $*.toc; then cp $*.toc $*.toc.bak; fi
RM = rm -f


RERUN = (There were undefined references|Rerun to get)
RERUNBIB = There were undefined references|No file.*.bbl|There were undefined citations

#DVIFILES = paper.dvi
#GOALS = $(DVIFILES) paper.ps paper.pdf
GOALS = paper.pdf

ALLFILES =  paper.tex paper.bib *.tex 
IMAGEFILES = 

main:		$(IMAGEFILES) $(GOALS)

all:		$(IMAGEFILES) $(GOALS)

%.eepic:	%.fig
		fig2dev -L eepic $< $*.eepic

#%.dvi:		%.tex $(ALLFILES)
#		$(COPY);$(PDFLATEX) $<
#		egrep -c "$(RERUNBIB)" $*.log && ($(BIBTEX) $*;$(COPY);$(PDFLATEX) $<) ; true
#		egrep "$(RERUN)|$(RERUNBIB)" $*.log && ($(COPY);$(PDFLATEX) $<) ; true
#		if cmp -s $*.toc $*.toc.bak; then echo "OK" ;else $(PDFLATEX) $< ; fi
#		$(RM) $*.toc.bak

#%.ps:		%.dvi
#		dvips -Ppdf -G0 $< -o $@
#		cp $@ $@.copy
#		$(GZIP) $@
#		mv $@.copy $@

%.pdf:		%.tex $(ALLFILES)
		$(COPY);$(PDFLATEX) $<
		egrep -c "$(RERUNBIB)" $*.log && ($(BIBTEX) $*;$(COPY);$(PDFLATEX) $<) ; true
		egrep "$(RERUN)|$(RERUNBIB)" $*.log && ($(COPY);$(PDFLATEX) $<) ; true
		if cmp -s $*.toc $*.toc.bak; then echo "OK" ;else $(PDFLATEX) $< ; fi
		$(RM) $*.toc.bak
		#$(PDFLATEX) cover-letter.tex 
		#$(PDFLATEX) bio.tex 
		#$(PDFLATEX) highlights.tex 
		$(PDFVIEWER) $@
		

clean: 		
		$(FIND) ./ \
		    -maxdepth 1 \
		    -name "*.aux" -or \
		    -name "*.log" -or \
		    -name "*.bbl" -or \
		    -name "*converted*.pdf" -or \
		    -name "*.ps" -or \
		    -name "*.spl" -or \
		    -name "*.blg" -or \
		    -name "*.brf" -or \
		    -name "*.cb" -or \
		    -name "*.pyg" -or \
		    -name "*.ind" -or \
		    -name "*.idx" -or \
		    -name "*.ilg" -or \
		    -name "*.inx" -or \
		    -name "*.dvi" -or \
		    -name "*.thm" -or \
		    -name "*.toc" -or \
		    -name "*.lot" -or \
		    -name "*.lof" -or \
		    -name "*.bak" -or \
		    -name "*.out" \
		 | $(XARGS) $(RM)

cleaner:
		make clean
		$(RM) Makefile

