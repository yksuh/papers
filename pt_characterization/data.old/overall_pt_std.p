unset key
unset label
unset size
set datafile missing "?"
set logscale x 2
set logscale y 10
set encoding iso_8859_1
#set xlabel "Task length (sec) in log scale" font "Times-Roman, 20"
set xlabel "Task length (sec) in log scale" font "Times-Roman, 20"
set xtics auto font "Times-Roman, 20"
set ytics auto font "Times-Roman, 18"
set term post eps enhanced
#set key top right font "Times-Roman, 22"
set key bottom right font "Times-Roman, 22"
#set xrange [-20:2100]
#set xrange [0.8:4400]
set xrange [0.8:20000]
set output 'overall_pt_std.eps'
set ylabel "Standard deviation of PT (msec) in log scale" font "Times-Roman, 22"
plot "overall_pt_std.dat" using 1:($5) title "" with linespoint ls 1
set term X11; 
replot;
unset key;
