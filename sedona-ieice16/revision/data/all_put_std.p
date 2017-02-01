unset key
unset label
unset size
set datafile missing "?"
set logscale x 2
set logscale y 10
set encoding iso_8859_1
#set xlabel "Task length (sec) in log scale" font "Times-Roman, 20"
set xtics auto font "Times-Roman, 20"
set ytics auto font "Times-Roman, 18"
set term post eps enhanced
#set key top right font "Times-Roman, 22"
set key bottom right font "Times-Roman, 18"
set xrange [0.8:20000]
set output 'all_put_et_std.eps'
set ylabel "Standard deviation of ET (msec) in log scale" font "Times-Roman, 22"
plot "all_put_before.dat" using 1:($3) title "ORG-ET" with linespoint ls 1,\
     "all_put_after.dat" using 1:($5) title "FIND-PT" with linespoint ls 2
set term X11; 
replot;
unset key;
