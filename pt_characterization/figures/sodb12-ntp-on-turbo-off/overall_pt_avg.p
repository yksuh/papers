unset key
unset label
unset size
set encoding iso_8859_1
set xlabel "Task Length (sec)" font "Times-Roman, 24"
set xtics auto font "Times-Roman, 20"
set ytics auto font "Times-Roman, 17"
set term post eps enhanced
set key top left font "Times-Roman, 20"
set xrange [-20:2100]
set yrange [512:2100000]
set output 'overall_pt_avg.eps'
set format y "%.2t{/Symbol \264}10^{%T}"
set ylabel "Average Process Time (msec)" font "Times-Roman, 20"
plot "overall_pt.dat" using 1:5 title "Avg. Process Time over Increasing Task Length" with linespoint
set term X11; replot;
unset key;
