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
PDFLATEX = pdflatex
PS2PDF = ps2pdf -dAutoRotatePages=/None
DVIPS = dvips -Ppdf -G0
FIG2DEV = fig2dev
FIND = find
XARGS = xargs
GZIP = gzip -f
COPY = if test -r $*.toc; then cp $*.toc $*.toc.bak; fi
#EPS = cd figures/EMP/sodb8-ntp-off-turbo-on; R --no-save < all_et.r; R --no-save < all_pt.r; cd ../../..;cd figures/EMP/sodb8-ntp-on-turbo-off; R --no-save < all_et.r; R --no-save < all_pt.r; cd ../../..; cd figures/EMP/sodb8-ntp-on-turbo-on; R --no-save < all_pt.r; cd ../../../; cd figures/EMP/sodb12-ntp-on-turbo-off; R --no-save < all_pt.r; cd ../../../;cd figures/EMP/v6/; R --no-save < minimal_sample.r; cd ../../../
RM = rm -f


RERUN = (There were undefined references|Rerun to get)
RERUNBIB = There were undefined references|No file.*.bbl|There were undefined citations

DVIFILES = third_response.dvi
GOALS = $(DVIFILES) third_response.ps third_response.pdf

ALLFILES =  third_response.tex *.tex 
#IMAGEFILES = figures/EMP/sodb8-ntp-off-turbo-on/8_sec_et_all_new.eps
IMAGEFILES = 

main:		$(IMAGEFILES) $(GOALS)

all:		$(IMAGEFILES) $(GOALS)

%.eepic:	%.fig
		fig2dev -L eepic $< $*.eepic

%.dvi:		%.tex $(ALLFILES)
		$(COPY);
		#$(EPS);
		$(LATEX) $<
		egrep -c "$(RERUNBIB)" $*.log && ($(BIBTEX) $*;$(COPY);$(LATEX) $<) ; true
		egrep "$(RERUN)|$(RERUNBIB)" $*.log && ($(COPY);$(LATEX) $<) ; true
		egrep "$(RERUN)|$(RERUNBIB)" $*.log && ($(COPY);$(LATEX) $<) ; true
		if cmp -s $*.toc $*.toc.bak; then echo "OK" ;else $(LATEX) $< ; fi
		$(RM) $*.toc.bak

%.ps:		%.dvi
		dvips -Ppdf -G0 $< -o $@
		cp $@ $@.copy
#		$(GZIP) $@
		mv $@.copy $@

%.pdf:		%.ps
		cp $< $<.copy
		$(PS2PDF) $<
		mv $<.copy $<
		$(PDFVIEWER) $@
		

clean: 		
		$(FIND) ./ \
		    -maxdepth 1 \
		    -name "*.aux" -or \
		    -name "*.log" -or \
		    -name "*.bbl" -or \
		    -name "*.ps" -or \
		    -name "*.blg" -or \
		    -name "*.brf" -or \
		    -name "*.cb" -or \
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

