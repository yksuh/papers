unset key
unset label
unset size
set log x 2
set log y 10 
set encoding iso_8859_1
set xlabel "Task length (sec)" font "Times-Roman, 20"
set xtics auto font "Times-Roman, 20"
set ytics auto font "Times-Roman, 18"
set term post eps enhanced
set key top right font "Times-Roman, 18"
set xrange [0.8:20000]
set output 'all_put_re.eps'
set format y "%.1t{/Symbol \264}10^{%T}"
set ylabel "Relative error in log scale" font "Times-Roman, 22"
plot "all_put_before.dat" using 1:($4) title "ORG-ET" with linespoint ls 1,\
     "all_put_after.dat" using 1:($6) title "FIND-PT" with linespoint ls 2
set term X11; replot;
unset key;
