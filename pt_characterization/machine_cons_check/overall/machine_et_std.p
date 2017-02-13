unset key
unset label
unset size
set datafile missing "?"
set logscale x 2
set encoding iso_8859_1
set xlabel "Task length (sec)" font "Times-Roman, 20"
set xtics auto font "Times-Roman, 20"
set ytics auto font "Times-Roman, 18"
set term post eps enhanced
set key top right font "Times-Roman, 22"
set xrange [0.8:140]
set output 'machine_pt_std.eps'
set ylabel "Standard deviation of ET (msec)" font "Times-Roman, 22"
plot "machine_pt_std.dat" using 1:($2) title "sodb8" with linespoint ls 1,\
     "machine_pt_std.dat" using 1:($3) title "sodb9" with linespoint ls 2,\
     "machine_pt_std.dat" using 1:($4) title "sodb10" with linespoint ls 3,\
     "machine_pt_std.dat" using 1:($5) title "sodb12" with linespoint ls 4
set term X11; 
replot;
unset key;
