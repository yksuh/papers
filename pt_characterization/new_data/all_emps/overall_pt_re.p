unset key
unset label
unset size
set log x 2
set log y 10 
set encoding iso_8859_1
#set xlabel "Task length (sec) in log scale" font "Times-Roman, 20"
set xlabel "Task length (sec)" font "Times-Roman, 20"
set xtics auto font "Times-Roman, 20"
set ytics auto font "Times-Roman, 18"
set term post eps enhanced
set key top right font "Times-Roman, 22"
#set xrange [-20:4200]
set xrange [0.8:20000]
set output 'overall_pt_re.eps'
set format y "%.1t{/Symbol \264}10^{%T}"
set ylabel "Relative error in log scale" font "Times-Roman, 22"
plot "overall_pt_re.dat" using 1:($2) title "EMPv1" with linespoint ls 1,\
     "overall_pt_re.dat" using 1:($3) title "EMPv2" with linespoint ls 2,\
     "overall_pt_re.dat" using 1:($4) title "EMPv3" with linespoint ls 3,\
     "overall_pt_re.dat" using 1:($5) title "EMPv4" with linespoint ls 4,\
     "overall_pt_re.dat" using 1:($6) title "EMPv5" with linespoint ls 5,\
     "overall_pt_re.dat" using 1:($7) title "EMPv6" with linespoint ls 6 
set term X11; replot;
unset key;
