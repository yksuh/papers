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
set key top right font "Times-Roman, 22"
set xrange [0.8:140]
set yrange [0.000001:0.001]
set output 'machine_et_re.eps'
set format y "%.1t{/Symbol \264}10^{%T}"
set ylabel "Relative error in log scale" font "Times-Roman, 22"
plot "machine_et_re.dat" using 1:($2) title "sodb8" with linespoint ls 1,\
     "machine_et_re.dat" using 1:($3) title "sodb9" with linespoint ls 2,\
     "machine_et_re.dat" using 1:($4) title "sodb10" with linespoint ls 3,\
     "machine_et_re.dat" using 1:($5) title "sodb12" with linespoint ls 4
set term X11; replot;
unset key;
